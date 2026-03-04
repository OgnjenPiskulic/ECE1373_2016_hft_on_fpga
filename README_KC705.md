# KC705 Port — HFT FPGA Design

## Overview

This document describes the port of the HFT FPGA design from the original custom board
(Xilinx Kintex UltraScale `xcku115-flva1517-2-e`, 10G SFP+) to the
**Xilinx KC705 evaluation board** (Kintex-7 `xc7k325tffg900-2`, 1G Ethernet GMII).

### What Changed and Why

| Aspect | Original (KU115) | KC705 Port |
|---|---|---|
| FPGA | `xcku115-flva1517-2-e` | `xc7k325tffg900-2` |
| Ethernet MAC | `axi_10g_ethernet` (10G, SFP+ via GTH) | `axi_ethernet` (1G, GMII to Marvell 88E1111) |
| MAC interface width | 64-bit AXI-Stream | 8-bit AXI-Stream |
| MAC clock | 156.25 MHz from GTH `txusrclk2_out` | 125 MHz `gtx_clk` from `clk_wiz_0` |
| Processing clock | 156.25 MHz (from MAC GTH) | 200 MHz (from `clk_wiz_0`) |
| System clock input | 200 MHz single-ended (`refclk200`) | 200 MHz differential (`sys_diff_clock_clk_p/n`) |
| Reset source | `perst_n` (PCIe reset) AND `network_reset_done` | `cpu_resetn` (CPU reset button on KC705) |
| Physical interface | `txp/n`, `rxp/n`, `refclk_p/n`, `sfp_tx_disable` | GMII signals, MDIO, `phy_rst_n` |

The key challenge is bridging the MAC's 8-bit AXI-Stream (1G) to the 64-bit AXI-Stream
used by the HLS UDP/IP stack. This is done with **AXI-Stream Data Width Converters**
inside the `network_module` hierarchy.

---

## Architecture

```
  KC705 Board
  ┌──────────────────────────────────────────────────────────────────────┐
  │                                                                      │
  │  sys_diff_clock (200 MHz) ──► clk_wiz_0 ──► clk_200MHz (all IPs)   │
  │                                         └──► clk_125MHz (MAC GTX)   │
  │                                                                      │
  │  Marvell 88E1111 PHY                                                 │
  │  (GMII 1G)                                                           │
  │      │  gmii_rxd/tx_en/...                                           │
  │      ▼                                                               │
  │  ┌─────────────────────────────────────────────────────┐             │
  │  │  network_module                                     │             │
  │  │                                                     │             │
  │  │  ┌────────────────┐    ┌──────────────────────┐    │             │
  │  │  │  axi_ethernet  │    │  axis_dwidth_conv_rx  │    │             │
  │  │  │  (1G GMII MAC) ├───►│  8-bit → 64-bit      ├───►│ M_AXIS      │
  │  │  │                │    └──────────────────────┘    │  (64-bit)   │
  │  │  │                │    ┌──────────────────────┐    │             │
  │  │  │                │◄───┤  axis_dwidth_conv_tx  │◄───┤ S_AXIS      │
  │  │  │                │    │  64-bit → 8-bit      │    │  (64-bit)   │
  │  │  └────────────────┘    └──────────────────────┘    │             │
  │  └─────────────────────────────────────────────────────┘             │
  │           │                         ▲                                │
  │           ▼ M_AXIS (64-bit)         │ S_AXIS (64-bit)                │
  │  ┌─────────────────────────────────────────────────────┐             │
  │  │  udp_ip_wrapper (HLS UDP/IP Stack)                  │             │
  │  │  ip_handler / udp / arp / icmp / mac_ip_encode      │             │
  │  │  (all unchanged, 64-bit AXI-Stream, 200 MHz)        │             │
  │  └─────────────────────────────────────────────────────┘             │
  │           │ rxData/Metadata                 ▲ txData/Length/Metadata │
  │           ▼                                 │                        │
  │  ┌─────────────────────────────────────────────────────┐             │
  │  │  udpAppMux_0                                        │             │
  │  └───────────┬─────────────────────────────────────────┘             │
  │              │                                                        │
  │    ┌─────────▼──────────┐  ┌─────────────────┐                      │
  │    │  fast_protocol_0   │  │  microblaze_0   │                      │
  │    │  (FAST decoder)    │  │  + MDM + periph │                      │
  │    └─────────┬──────────┘  └─────────────────┘                      │
  │    ┌─────────▼──────────┐                                            │
  │    │  order_book_0      │                                            │
  │    └─────────┬──────────┘                                            │
  │    ┌─────────▼──────────┐                                            │
  │    │  simple_threshold_0│                                            │
  │    └────────────────────┘                                            │
  └──────────────────────────────────────────────────────────────────────┘
```

---

## Files Modified

| File | Change |
|---|---|
| `src/block_design.tcl` | FPGA part, `network_module` hierarchy, clocking, ports, reset |
| `src/build_project.tcl` | Reference `kc705.xdc` instead of `ad_8k5.xdc` |
| `src/kc705.xdc` | **New** — KC705 pin assignments and I/O standards |

### HLS IPs — UNCHANGED

The following IPs are completely unchanged and require no recompilation:
- `fast_hls/` — FAST protocol decoder
- `udp_hls/` — UDP/IP stack (arpServerWrapper, icmp_server, ip_handler, mac_ip_encode, udp)
- `threshold_hls/` — simple_threshold
- `order_book_hls/` — order_book
- `microblaze_to_switch_hls/` — MicroblazeToSwitch

---

## Build Instructions

### Prerequisites

- Vivado 2016.3 (matching the original project version)
- KC705 evaluation board
- A host connected via JTAG for programming and SDK debugging

### Steps

1. **Build HLS cores** (if not already built):
   ```tcl
   # In Vivado Tcl console or vivado_hls batch mode:
   source src/build_fast_core.tcl
   source src/build_order_book_core.tcl
   source src/build_threshold_core.tcl
   source src/build_microblaze_to_switch_core.tcl
   ```

2. **Create the Vivado project and block design**:
   ```tcl
   cd src
   vivado -mode batch -source build_project.tcl
   ```
   This will:
   - Create project targeting `xc7k325tffg900-2`
   - Generate the block design with 1G GMII network_module
   - Add the `kc705.xdc` constraints

3. **Open in Vivado GUI** (optional, to inspect the design):
   ```
   vivado hft_proj/hft_proj.xpr
   ```

4. **Synthesise, Implement, and Generate Bitstream** (Vivado GUI or batch):
   ```tcl
   launch_runs synth_1
   wait_on_run synth_1
   launch_runs impl_1 -to_step write_bitstream
   wait_on_run impl_1
   ```

5. **Program the FPGA** via Vivado Hardware Manager or SDK.

---

## Pin Mapping Summary

### System Clock

| Port | Package Pin | Standard | Note |
|---|---|---|---|
| `sys_diff_clock_clk_p` | AD12 | LVDS | 200 MHz differential P |
| `sys_diff_clock_clk_n` | AD11 | LVDS | 200 MHz differential N |

### Reset & LEDs

| Port | Package Pin | Standard | Note |
|---|---|---|---|
| `cpu_resetn` | AB7 | LVCMOS15 | CPU Reset button (active-low) |
| `led_l[0]` | AB8 | LVCMOS15 | Reset status |
| `led_l[1]` | AA8 | LVCMOS15 | Reserved (always 0) |
| `led_l[2]` | AC9 | LVCMOS15 | Active-high reset indicator |

### Ethernet GMII (Marvell 88E1111 PHY)

| Port | Package Pin | Direction | Note |
|---|---|---|---|
| `phy_rst_n` | L20 | Out | PHY hardware reset |
| `gmii_txd[7:0]` | H16–H18 | Out | TX data |
| `gmii_tx_en` | H15 | Out | TX enable |
| `gmii_tx_er` | J15 | Out | TX error |
| `gmii_tx_clk` | F15 | Out | TX clock (from FPGA) |
| `gmii_rxd[7:0]` | M14, U18–P18 | In | RX data |
| `gmii_rx_dv` | N14 | In | RX data valid |
| `gmii_rx_er` | P15 | In | RX error |
| `gmii_rx_clk` | P20 | In | RX clock (from PHY) |
| `gmii_col` | R15 | In | Collision detect |
| `gmii_crs` | P16 | In | Carrier sense |
| `mdio_mdc` | N18 | Out | MDIO clock |
| `mdio_mdio_io` | M18 | BiDir | MDIO data |

All GMII/MDIO signals use LVCMOS25 (2.5 V bank on KC705).

---

## Known Limitations

1. **Throughput: 1G vs 10G**
   The original design used a 10G SFP+ link (10 Gbps). The KC705 port is limited to
   1 Gbps (125 Mbytes/sec). For HFT applications where ultra-low latency is the
   priority over raw throughput, 1G is typically sufficient for market data feeds.

2. **Clock domain crossing (CDC)**
   The `axi_ethernet` MAC operates at 125 MHz (TX `gtx_clk`, RX `rx_mac_aclk`).
   The AXI-Stream width converters inside `network_module` run at 200 MHz (processing
   clock). The MAC's 8-bit AXI-Stream (at 125 MHz) connects to the 8-bit slave side
   of the width converter (clocked at 200 MHz), creating a clock domain crossing
   without an explicit CDC FIFO. In Vivado synthesis this will generate
   timing warnings. For a production design, either:
   - Configure `axi_ethernet` with `SupportLevel {1}` to include embedded FIFOs, or
   - Add AXI-Stream clock converters (`axis_clock_converter`) between the 8-bit
     MAC clock domain (125 MHz) and the 8-bit input of the width converter (200 MHz), or
   - Run the width converters (and the rest of the design) from `clk_125MHz`.

3. **Processing clock: 200 MHz vs 156.25 MHz**
   All HLS IPs now run at 200 MHz instead of 156.25 MHz. The HLS cores were
   synthesised with timing constraints for the original frequency. Verify that
   timing closure is achieved at 200 MHz on Kintex-7. If not, lower the `clk_200MHz`
   target frequency in `clk_wiz_0`.

4. **Vivado version**
   The block design Tcl was generated for Vivado 2016.3. The `axi_ethernet` IP
   version (7.2) and `axis_dwidth_converter` (1.1) versions used in the new
   `network_module` should be available in that release. Adjust IP VLNV versions
   if using a different Vivado release.

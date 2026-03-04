# KC705 constraints for HFT FPGA design (1G Ethernet port)
# Target: Xilinx KC705 evaluation board (xc7k325tffg900-2)

# ----------------------------------------------------------------------------
# KC705 System Clock — 200 MHz differential on AD12 (P) / AD11 (N)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AD12 [get_ports sys_diff_clock_clk_p]
set_property PACKAGE_PIN AD11 [get_ports sys_diff_clock_clk_n]
set_property IOSTANDARD LVDS [get_ports sys_diff_clock_clk_p]
set_property IOSTANDARD LVDS [get_ports sys_diff_clock_clk_n]
create_clock -period 5.000 -name sys_clk [get_ports sys_diff_clock_clk_p]

# ----------------------------------------------------------------------------
# CPU Reset Button — active-low on KC705 (AB7, LVCMOS15)
# Note: port named cpu_resetn to match active-low convention used in the design
# (0 = reset asserted, 1 = running normally)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AB7 [get_ports cpu_resetn]
set_property IOSTANDARD LVCMOS15 [get_ports cpu_resetn]
set_false_path -from [get_ports cpu_resetn]

# ----------------------------------------------------------------------------
# GPIO LEDs (LVCMOS15)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AB8 [get_ports {led_l[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led_l[0]}]
set_property PACKAGE_PIN AA8 [get_ports {led_l[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led_l[1]}]
set_property PACKAGE_PIN AC9 [get_ports {led_l[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led_l[2]}]

# ----------------------------------------------------------------------------
# Ethernet PHY (Marvell 88E1111) — GMII Interface (LVCMOS25)
# ----------------------------------------------------------------------------

# PHY Reset (active-low output)
set_property PACKAGE_PIN L20 [get_ports phy_rst_n]
set_property IOSTANDARD LVCMOS25 [get_ports phy_rst_n]

# GMII TX
set_property PACKAGE_PIN H16 [get_ports {gmii_txd[0]}]
set_property PACKAGE_PIN H17 [get_ports {gmii_txd[1]}]
set_property PACKAGE_PIN G16 [get_ports {gmii_txd[2]}]
set_property PACKAGE_PIN J16 [get_ports {gmii_txd[3]}]
set_property PACKAGE_PIN G17 [get_ports {gmii_txd[4]}]
set_property PACKAGE_PIN G18 [get_ports {gmii_txd[5]}]
set_property PACKAGE_PIN F18 [get_ports {gmii_txd[6]}]
set_property PACKAGE_PIN H18 [get_ports {gmii_txd[7]}]
set_property PACKAGE_PIN H15 [get_ports gmii_tx_en]
set_property PACKAGE_PIN J15 [get_ports gmii_tx_er]
set_property PACKAGE_PIN F15 [get_ports gmii_tx_clk]

# GMII RX
set_property PACKAGE_PIN M14 [get_ports {gmii_rxd[0]}]
set_property PACKAGE_PIN U18 [get_ports {gmii_rxd[1]}]
set_property PACKAGE_PIN U17 [get_ports {gmii_rxd[2]}]
set_property PACKAGE_PIN T18 [get_ports {gmii_rxd[3]}]
set_property PACKAGE_PIN T17 [get_ports {gmii_rxd[4]}]
set_property PACKAGE_PIN N16 [get_ports {gmii_rxd[5]}]
set_property PACKAGE_PIN N15 [get_ports {gmii_rxd[6]}]
set_property PACKAGE_PIN P18 [get_ports {gmii_rxd[7]}]
set_property PACKAGE_PIN N14 [get_ports gmii_rx_dv]
set_property PACKAGE_PIN P15 [get_ports gmii_rx_er]
set_property PACKAGE_PIN P20 [get_ports gmii_rx_clk]
set_property PACKAGE_PIN R15 [get_ports gmii_col]
set_property PACKAGE_PIN P16 [get_ports gmii_crs]

# GMII IOSTANDARD
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[*]}]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_en]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_er]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[*]}]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_dv]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_er]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_clk]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_col]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_crs]

# ----------------------------------------------------------------------------
# MDIO Management Interface (LVCMOS25)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN N18 [get_ports mdio_mdc]
set_property PACKAGE_PIN M18 [get_ports mdio_mdio_io]
set_property IOSTANDARD LVCMOS25 [get_ports mdio_mdc]
set_property IOSTANDARD LVCMOS25 [get_ports mdio_mdio_io]

# ----------------------------------------------------------------------------
# Bitstream settings for KC705
# ----------------------------------------------------------------------------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

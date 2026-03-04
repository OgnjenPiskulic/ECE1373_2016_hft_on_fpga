
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./hft_proj/hft_proj.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project hft_proj hft_proj -part xc7k325tffg900-2
}


# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "fast_hls"] [file normalize "udp_hls"] [file normalize "threshold_hls"] [file normalize "order_book_hls"] [file normalize "microblaze_to_switch_hls"]" $obj

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: udp_ip_wrapper
proc create_hier_cell_udp_ip_wrapper { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_udp_ip_wrapper() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_S_Stream
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXI_M_Stream
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 portOpenReplyIn
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 requestPortOpenOut
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rxDataIn
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rxMetadataIn
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 txDataOut
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 txLengthOut
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 txMetadataOut

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I aresetn
  create_bd_pin -dir I -from 47 -to 0 -type data myMacAddress_V
  create_bd_pin -dir I -from 31 -to 0 -type data regIpAddress_V

  # Create instance: arpServerWrapper_0, and set properties
  set arpServerWrapper_0 [ create_bd_cell -type ip -vlnv user.org:user:arpServerWrapper:1.0 arpServerWrapper_0 ]

  # Create instance: axis_interconnect_2to1, and set properties
  set axis_interconnect_2to1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_2to1 ]
  set_property -dict [ list \
CONFIG.ARB_ON_MAX_XFERS {0} \
CONFIG.ARB_ON_TLAST {1} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
 ] $axis_interconnect_2to1

  # Create instance: axis_interconnect_3to1, and set properties
  set axis_interconnect_3to1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_3to1 ]
  set_property -dict [ list \
CONFIG.ARB_ON_TLAST {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_REGSLICE {1} \
 ] $axis_interconnect_3to1

  # Create instance: axis_register_arp_in_slice, and set properties
  set axis_register_arp_in_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_arp_in_slice ]

  # Create instance: axis_register_icmp_in_slice, and set properties
  set axis_register_icmp_in_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_icmp_in_slice ]

  # Create instance: gateway, and set properties
  set gateway [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gateway ]
  set_property -dict [ list \
CONFIG.CONST_VAL {16843009} \
CONFIG.CONST_WIDTH {32} \
 ] $gateway

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: icmp_server_0, and set properties
  set icmp_server_0 [ create_bd_cell -type ip -vlnv xilinx.labs:hls:icmp_server:1.67 icmp_server_0 ]

  # Create instance: ip_handler_0, and set properties
  set ip_handler_0 [ create_bd_cell -type ip -vlnv xilinx.labs:hls:ip_handler:1.21 ip_handler_0 ]

  # Create instance: mac_ip_encode_0, and set properties
  set mac_ip_encode_0 [ create_bd_cell -type ip -vlnv xilinx.labs:hls:mac_ip_encode:1.04 mac_ip_encode_0 ]

  # Create instance: subnet, and set properties
  set subnet [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 subnet ]
  set_property -dict [ list \
CONFIG.CONST_VAL {16777215} \
CONFIG.CONST_WIDTH {32} \
 ] $subnet

  # Create instance: udp_0, and set properties
  set udp_0 [ create_bd_cell -type ip -vlnv xilinx.labs:hls:udp:1.41 udp_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {16} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXIS_S_Stream_1 [get_bd_intf_pins AXIS_S_Stream] [get_bd_intf_pins ip_handler_0/dataIn]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins portOpenReplyIn] [get_bd_intf_pins udp_0/confirmPortStatus]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rxMetadataIn] [get_bd_intf_pins udp_0/inputPathOutputMetadata]
  connect_bd_intf_net -intf_net S01_AXIS_1 [get_bd_intf_pins axis_interconnect_2to1/S01_AXIS] [get_bd_intf_pins mac_ip_encode_0/dataOut]
  connect_bd_intf_net -intf_net arpServerWrapper_0_axi_arp_to_arp_slice [get_bd_intf_pins arpServerWrapper_0/axi_arp_to_arp_slice] [get_bd_intf_pins axis_interconnect_2to1/S00_AXIS]
  connect_bd_intf_net -intf_net arpServerWrapper_0_axis_arp_lookup_reply [get_bd_intf_pins arpServerWrapper_0/axis_arp_lookup_reply] [get_bd_intf_pins mac_ip_encode_0/arpTableIn_V]
  connect_bd_intf_net -intf_net axis_interconnect_2to1_M00_AXIS [get_bd_intf_pins AXI_M_Stream] [get_bd_intf_pins axis_interconnect_2to1/M00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_3to1_M00_AXIS [get_bd_intf_pins axis_interconnect_3to1/M00_AXIS] [get_bd_intf_pins mac_ip_encode_0/dataIn]
  connect_bd_intf_net -intf_net axis_register_arp_in_slice_M_AXIS [get_bd_intf_pins arpServerWrapper_0/axi_arp_slice_to_arp] [get_bd_intf_pins axis_register_arp_in_slice/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_icmp_in_slice_M_AXIS [get_bd_intf_pins axis_register_icmp_in_slice/M_AXIS] [get_bd_intf_pins icmp_server_0/dataIn]
  connect_bd_intf_net -intf_net icmp_server_0_dataOut [get_bd_intf_pins axis_interconnect_3to1/S00_AXIS] [get_bd_intf_pins icmp_server_0/dataOut]
  connect_bd_intf_net -intf_net ip_handler_0_ARPdataOut [get_bd_intf_pins axis_register_arp_in_slice/S_AXIS] [get_bd_intf_pins ip_handler_0/ARPdataOut]
  connect_bd_intf_net -intf_net ip_handler_0_ICMPdataOut [get_bd_intf_pins axis_register_icmp_in_slice/S_AXIS] [get_bd_intf_pins ip_handler_0/ICMPdataOut]
  connect_bd_intf_net -intf_net ip_handler_0_ICMPexpDataOut [get_bd_intf_pins icmp_server_0/ttlIn] [get_bd_intf_pins ip_handler_0/ICMPexpDataOut]
  connect_bd_intf_net -intf_net ip_handler_0_UDPdataOut [get_bd_intf_pins ip_handler_0/UDPdataOut] [get_bd_intf_pins udp_0/inputPathInData]
  connect_bd_intf_net -intf_net mac_ip_encode_0_arpTableOut_V_V [get_bd_intf_pins arpServerWrapper_0/axis_arp_lookup_request] [get_bd_intf_pins mac_ip_encode_0/arpTableOut_V_V]
  connect_bd_intf_net -intf_net openPort_1 [get_bd_intf_pins requestPortOpenOut] [get_bd_intf_pins udp_0/openPort]
  connect_bd_intf_net -intf_net txDataOut_1 [get_bd_intf_pins txDataOut] [get_bd_intf_pins udp_0/outputPathInData]
  connect_bd_intf_net -intf_net txLengthOut_1 [get_bd_intf_pins txLengthOut] [get_bd_intf_pins udp_0/outputpathInLength]
  connect_bd_intf_net -intf_net txMetadataOut_1 [get_bd_intf_pins txMetadataOut] [get_bd_intf_pins udp_0/outputPathInMetadata]
  connect_bd_intf_net -intf_net udp_0_inputPathPortUnreachable [get_bd_intf_pins icmp_server_0/udpIn] [get_bd_intf_pins udp_0/inputPathPortUnreachable]
  connect_bd_intf_net -intf_net udp_0_inputpathOutData [get_bd_intf_pins rxDataIn] [get_bd_intf_pins udp_0/inputpathOutData]
  connect_bd_intf_net -intf_net udp_0_outputPathOutData [get_bd_intf_pins axis_interconnect_3to1/S01_AXIS] [get_bd_intf_pins udp_0/outputPathOutData]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins aclk] [get_bd_pins arpServerWrapper_0/aclk] [get_bd_pins axis_interconnect_2to1/ACLK] [get_bd_pins axis_interconnect_2to1/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_2to1/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_2to1/S01_AXIS_ACLK] [get_bd_pins axis_interconnect_3to1/ACLK] [get_bd_pins axis_interconnect_3to1/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_3to1/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_3to1/S01_AXIS_ACLK] [get_bd_pins axis_register_arp_in_slice/aclk] [get_bd_pins axis_register_icmp_in_slice/aclk] [get_bd_pins icmp_server_0/ap_clk] [get_bd_pins ip_handler_0/ap_clk] [get_bd_pins mac_ip_encode_0/ap_clk] [get_bd_pins udp_0/aclk]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins arpServerWrapper_0/aresetn] [get_bd_pins axis_interconnect_2to1/ARESETN] [get_bd_pins axis_interconnect_2to1/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_2to1/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_2to1/S01_AXIS_ARESETN] [get_bd_pins axis_interconnect_3to1/ARESETN] [get_bd_pins axis_interconnect_3to1/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_3to1/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_3to1/S01_AXIS_ARESETN] [get_bd_pins axis_register_arp_in_slice/aresetn] [get_bd_pins axis_register_icmp_in_slice/aresetn] [get_bd_pins icmp_server_0/ap_rst_n] [get_bd_pins ip_handler_0/ap_rst_n] [get_bd_pins mac_ip_encode_0/ap_rst_n] [get_bd_pins udp_0/aresetn]
  connect_bd_net -net gateway_dout [get_bd_pins gateway/dout] [get_bd_pins mac_ip_encode_0/regDefaultGateway_V]
  connect_bd_net -net gnd_dout [get_bd_pins axis_interconnect_2to1/S00_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_2to1/S01_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_3to1/S00_ARB_REQ_SUPPRESS] [get_bd_pins axis_interconnect_3to1/S01_ARB_REQ_SUPPRESS] [get_bd_pins gnd/dout] [get_bd_pins ip_handler_0/TCPdataOut_TREADY] [get_bd_pins udp_0/portRelease_TVALID]
  connect_bd_net -net myMacAddress_V_1 [get_bd_pins myMacAddress_V] [get_bd_pins arpServerWrapper_0/myMacAddress] [get_bd_pins ip_handler_0/myMacAddress_V] [get_bd_pins mac_ip_encode_0/myMacAddress_V]
  connect_bd_net -net regIpAddress_V_1 [get_bd_pins regIpAddress_V] [get_bd_pins arpServerWrapper_0/myIpAddress] [get_bd_pins ip_handler_0/regIpAddress_V]
  connect_bd_net -net subnet_dout [get_bd_pins mac_ip_encode_0/regSubNetMask_V] [get_bd_pins subnet/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins udp_0/portRelease_TDATA] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: network_module
# KC705 port: replaced axi_10g_ethernet with axi_ethernet (GMII/1G) + AXI-Stream
# data-width converters (8-bit MAC <-> 64-bit HLS UDP/IP stack)
proc create_hier_cell_network_module { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_network_module() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  # 64-bit AXI-Stream to/from HLS UDP/IP stack (unchanged from 10G design)
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave  -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS
  # GMII interface to Marvell 88E1111 PHY on KC705
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii
  # MDIO management interface to PHY
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio

  # Create pins
  create_bd_pin -dir I           aresetn
  create_bd_pin -dir I -type clk clk_125
  create_bd_pin -dir I -type clk clk_200
  create_bd_pin -dir O           phy_rst_n
  create_bd_pin -dir I -type rst reset

  # Create instance: axi_ethernet_0 — 1G Tri-Mode Ethernet MAC (GMII mode)
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.2 axi_ethernet_0 ]
  set_property -dict [ list \
CONFIG.PHY_TYPE {GMII} \
CONFIG.ENABLE_LVDS {false} \
CONFIG.SupportLevel {0} \
 ] $axi_ethernet_0

  # Create instance: axis_dwidth_converter_rx — 8-bit MAC RX -> 64-bit stack
  set axis_dwidth_converter_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_rx ]
  set_property -dict [ list \
CONFIG.S_TDATA_NUM_BYTES {1} \
CONFIG.M_TDATA_NUM_BYTES {8} \
 ] $axis_dwidth_converter_rx

  # Create instance: axis_dwidth_converter_tx — 64-bit stack TX -> 8-bit MAC
  set axis_dwidth_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_tx ]
  set_property -dict [ list \
CONFIG.S_TDATA_NUM_BYTES {8} \
CONFIG.M_TDATA_NUM_BYTES {1} \
 ] $axis_dwidth_converter_tx

  # RX status sink — always accept MAC RX status stream (discard it)
  set rxs_tready [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 rxs_tready ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
CONFIG.CONST_WIDTH {1} \
 ] $rxs_tready

  # TX control source — no control/error injection (tvalid=0)
  set txc_tvalid [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 txc_tvalid ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {1} \
 ] $txc_tvalid

  # Create interface connections
  # Expose GMII and MDIO through hierarchy to top-level ports
  connect_bd_intf_net -intf_net gmii_1 [get_bd_intf_pins gmii] [get_bd_intf_pins axi_ethernet_0/GMII]
  connect_bd_intf_net -intf_net mdio_1 [get_bd_intf_pins mdio] [get_bd_intf_pins axi_ethernet_0/MDIO]

  # RX path: 8-bit MAC output -> width converter -> 64-bit M_AXIS
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd \
    [get_bd_intf_pins axi_ethernet_0/m_axis_rxd] \
    [get_bd_intf_pins axis_dwidth_converter_rx/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_rx_M_AXIS \
    [get_bd_intf_pins axis_dwidth_converter_rx/M_AXIS] \
    [get_bd_intf_pins M_AXIS]

  # TX path: 64-bit S_AXIS -> width converter -> 8-bit MAC input
  connect_bd_intf_net -intf_net S_AXIS_1 \
    [get_bd_intf_pins S_AXIS] \
    [get_bd_intf_pins axis_dwidth_converter_tx/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_tx_M_AXIS \
    [get_bd_intf_pins axis_dwidth_converter_tx/M_AXIS] \
    [get_bd_intf_pins axi_ethernet_0/s_axis_txd]

  # Create port connections
  # 125 MHz GTX clock to MAC
  connect_bd_net -net clk_125_1 \
    [get_bd_pins clk_125] \
    [get_bd_pins axi_ethernet_0/gtx_clk]

  # 200 MHz processing clock to AXI-Stream width converters
  connect_bd_net -net clk_200_1 \
    [get_bd_pins clk_200] \
    [get_bd_pins axis_dwidth_converter_rx/aclk] \
    [get_bd_pins axis_dwidth_converter_tx/aclk]

  # Active-low reset to width converters
  connect_bd_net -net aresetn_1 \
    [get_bd_pins aresetn] \
    [get_bd_pins axis_dwidth_converter_rx/aresetn] \
    [get_bd_pins axis_dwidth_converter_tx/aresetn] \
    [get_bd_pins axi_ethernet_0/axi_txd_arstn] \
    [get_bd_pins axi_ethernet_0/axi_txc_arstn] \
    [get_bd_pins axi_ethernet_0/axi_rxd_arstn] \
    [get_bd_pins axi_ethernet_0/axi_rxs_arstn]

  # Active-high global reset to MAC
  connect_bd_net -net reset_1 \
    [get_bd_pins reset] \
    [get_bd_pins axi_ethernet_0/glbl_rst]

  # PHY reset output
  connect_bd_net -net phy_rst_n_1 \
    [get_bd_pins phy_rst_n] \
    [get_bd_pins axi_ethernet_0/phy_rst_n]

  # Always-ready sink for RX status stream
  connect_bd_net -net rxs_tready_dout \
    [get_bd_pins rxs_tready/dout] \
    [get_bd_pins axi_ethernet_0/m_axis_rxs_tready]

  # No TX control frames
  connect_bd_net -net txc_tvalid_dout \
    [get_bd_pins txc_tvalid/dout] \
    [get_bd_pins axi_ethernet_0/s_axis_txc_tvalid]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 lmb_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set led_l [ create_bd_port -dir O -from 2 -to 0 led_l ]
  set cpu_resetn [ create_bd_port -dir I cpu_resetn ]
  set sys_diff_clock_clk_p [ create_bd_port -dir I -type clk sys_diff_clock_clk_p ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {200000000} \
 ] $sys_diff_clock_clk_p
  set sys_diff_clock_clk_n [ create_bd_port -dir I sys_diff_clock_clk_n ]
  set phy_rst_n [ create_bd_port -dir O phy_rst_n ]
  set user_sw_l [ create_bd_port -dir I user_sw_l ]
  # GMII interface port (expands to individual gmii_txd, gmii_tx_en, ... in wrapper)
  set gmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii ]
  # MDIO interface port (expands to mdio_mdc, mdio_mdio_io in wrapper)
  set mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio ]

  # Create instance: MicroblazeToSwitch_0, and set properties
  set MicroblazeToSwitch_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:MicroblazeToSwitch:1.0 MicroblazeToSwitch_0 ]

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [ list \
CONFIG.Output_Width {64} \
 ] $c_counter_binary_0

  # Create instance: clk_wiz_0, and set properties
  # KC705: differential 200 MHz input -> clk_200MHz (processing) + clk_125MHz (MAC GTX)
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
CONFIG.CLKIN1_JITTER_PS {50.0} \
CONFIG.CLKOUT1_DRIVES {Buffer} \
CONFIG.CLKOUT1_JITTER {98.146} \
CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.CLKOUT1_USED {true} \
CONFIG.CLKOUT2_DRIVES {Buffer} \
CONFIG.CLKOUT2_JITTER {114.829} \
CONFIG.CLKOUT2_PHASE_ERROR {89.971} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125.000} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {Buffer} \
CONFIG.CLKOUT4_DRIVES {Buffer} \
CONFIG.CLKOUT5_DRIVES {Buffer} \
CONFIG.CLKOUT6_DRIVES {Buffer} \
CONFIG.CLKOUT7_DRIVES {Buffer} \
CONFIG.CLK_OUT1_PORT {clk_200MHz} \
CONFIG.CLK_OUT2_PORT {clk_125MHz} \
CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
CONFIG.MMCM_CLKIN1_PERIOD {5.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {8} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.RESET_TYPE {ACTIVE_LOW} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKOUT1_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT2_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT3_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT4_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT5_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT6_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT7_DRIVES.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.RESET_TYPE.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_0

  # Create instance: fast_protocol_0, and set properties
  set fast_protocol_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:fast_protocol:1.0 fast_protocol_0 ]

  # Create instance: gnd1, and set properties
  # 1-bit constant zero — used as placeholder for LED In1 (was network_reset_done)
  set gnd1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd1 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {1} \
 ] $gnd1

  # Create instance: ip, and set properties
  set ip [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ip ]
  set_property -dict [ list \
CONFIG.CONST_VAL {16843009} \
CONFIG.CONST_WIDTH {32} \
 ] $ip

  # Create instance: mac, and set properties
  set mac [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac ]
  set_property -dict [ list \
CONFIG.CONST_VAL {252462509656576} \
CONFIG.CONST_WIDTH {48} \
 ] $mac

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [ list \
CONFIG.C_USE_UART {1} \
 ] $mdm_1

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
CONFIG.C_DEBUG_ENABLED {1} \
CONFIG.C_D_AXI {1} \
CONFIG.C_D_LMB {1} \
CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: network_module
  create_hier_cell_network_module [current_bd_instance .] network_module

  # Create instance: order_book_0, and set properties
  set order_book_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:order_book:1.0 order_book_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: rst_clk_wiz_0_200M, and set properties
  set rst_clk_wiz_0_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_200M ]

  # Create instance: simple_threshold_0, and set properties
  set simple_threshold_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:simple_threshold:1.0 simple_threshold_0 ]

  # Create instance: timer_stream_adapter_0, and set properties
  set timer_stream_adapter_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:timer_stream_adapter:1.0 timer_stream_adapter_0 ]

  # Create instance: udpAppMux_0, and set properties
  set udpAppMux_0 [ create_bd_cell -type ip -vlnv xilinx.labs:hls:udpAppMux:1.1 udpAppMux_0 ]

  # Create instance: udp_ip_wrapper
  create_hier_cell_udp_ip_wrapper [current_bd_instance .] udp_ip_wrapper

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net MicroblazeToSwitch_0_rxDataMonitor [get_bd_intf_pins MicroblazeToSwitch_0/rxDataMonitor] [get_bd_intf_pins udpAppMux_0/rxDataMonitor]
  connect_bd_intf_net -intf_net MicroblazeToSwitch_0_rxLengthMonitor_V_V [get_bd_intf_pins MicroblazeToSwitch_0/rxLengthMonitor_V_V] [get_bd_intf_pins udpAppMux_0/rxLengthMonitor]
  connect_bd_intf_net -intf_net MicroblazeToSwitch_0_rxMetadataMonitor_V [get_bd_intf_pins MicroblazeToSwitch_0/rxMetadataMonitor_V] [get_bd_intf_pins udpAppMux_0/rxMetadataMonitor]
  connect_bd_intf_net -intf_net fast_protocol_0_lbRequestPortOpenOut [get_bd_intf_pins fast_protocol_0/lbRequestPortOpenOut] [get_bd_intf_pins udpAppMux_0/rxRequestPortFAST]
  connect_bd_intf_net -intf_net fast_protocol_0_lbTxDataOut [get_bd_intf_pins fast_protocol_0/lbTxDataOut] [get_bd_intf_pins udpAppMux_0/rxDataFAST]
  connect_bd_intf_net -intf_net fast_protocol_0_lbTxLengthOut [get_bd_intf_pins fast_protocol_0/lbTxLengthOut] [get_bd_intf_pins udpAppMux_0/rxLengthFAST]
  connect_bd_intf_net -intf_net fast_protocol_0_lbTxMetadataOut [get_bd_intf_pins fast_protocol_0/lbTxMetadataOut] [get_bd_intf_pins udpAppMux_0/rxMetadataFAST]
  connect_bd_intf_net -intf_net fast_protocol_0_metadata_to_book [get_bd_intf_pins fast_protocol_0/metadata_to_book_V] [get_bd_intf_pins order_book_0/incoming_meta_V]
  connect_bd_intf_net -intf_net fast_protocol_0_order_to_book_V [get_bd_intf_pins fast_protocol_0/order_to_book_V] [get_bd_intf_pins order_book_0/order_stream_V]
  connect_bd_intf_net -intf_net fast_protocol_0_tagsOut [get_bd_intf_pins fast_protocol_0/tagsOut] [get_bd_intf_pins udpAppMux_0/rxTimeFAST]
  connect_bd_intf_net -intf_net fast_protocol_0_time_to_book [get_bd_intf_pins fast_protocol_0/time_to_book_V_V] [get_bd_intf_pins order_book_0/incoming_time_V_V]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins order_book_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins MicroblazeToSwitch_0/s_axi_AXILiteS] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_mdm_axi [get_bd_intf_pins mdm_1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net network_module_M_AXIS [get_bd_intf_pins network_module/M_AXIS] [get_bd_intf_pins udp_ip_wrapper/AXIS_S_Stream]
  connect_bd_intf_net -intf_net order_book_0_outgoing_meta_V [get_bd_intf_pins order_book_0/outgoing_meta_V] [get_bd_intf_pins simple_threshold_0/incoming_meta_V]
  connect_bd_intf_net -intf_net order_book_0_outgoing_time_V_V [get_bd_intf_pins order_book_0/outgoing_time_V_V] [get_bd_intf_pins simple_threshold_0/incoming_time_V_V]
  connect_bd_intf_net -intf_net order_book_0_top_ask_V [get_bd_intf_pins order_book_0/top_ask_V] [get_bd_intf_pins simple_threshold_0/top_ask_V]
  connect_bd_intf_net -intf_net order_book_0_top_bid_V [get_bd_intf_pins order_book_0/top_bid_V] [get_bd_intf_pins simple_threshold_0/top_bid_V]
  connect_bd_intf_net -intf_net simple_threshold_0_outgoing_meta_V [get_bd_intf_pins fast_protocol_0/metadata_from_book_V] [get_bd_intf_pins simple_threshold_0/outgoing_meta_V]
  connect_bd_intf_net -intf_net simple_threshold_0_outgoing_order_V [get_bd_intf_pins fast_protocol_0/order_from_book_V] [get_bd_intf_pins simple_threshold_0/outgoing_order_V]
  connect_bd_intf_net -intf_net simple_threshold_0_outgoing_time_V_V [get_bd_intf_pins fast_protocol_0/time_from_book_V_V] [get_bd_intf_pins simple_threshold_0/outgoing_time_V_V]
  connect_bd_intf_net -intf_net timer_stream_adapter_0_synchTime_1 [get_bd_intf_pins timer_stream_adapter_0/synchTime_1] [get_bd_intf_pins udpAppMux_0/time_1]
  connect_bd_intf_net -intf_net timer_stream_adapter_0_synchTime_2 [get_bd_intf_pins timer_stream_adapter_0/synchTime_2] [get_bd_intf_pins udpAppMux_0/time_2]
  connect_bd_intf_net -intf_net txDataOut_1 [get_bd_intf_pins udpAppMux_0/txDataNetwork] [get_bd_intf_pins udp_ip_wrapper/txDataOut]
  connect_bd_intf_net -intf_net txLengthOut_1 [get_bd_intf_pins udpAppMux_0/txLengthNetwork] [get_bd_intf_pins udp_ip_wrapper/txLengthOut]
  connect_bd_intf_net -intf_net txMetadataOut_1 [get_bd_intf_pins udpAppMux_0/txMetadataNetwork] [get_bd_intf_pins udp_ip_wrapper/txMetadataOut]
  connect_bd_intf_net -intf_net udpAppMux_0_txDataFAST [get_bd_intf_pins fast_protocol_0/lbRxDataIn] [get_bd_intf_pins udpAppMux_0/txDataFAST]
  connect_bd_intf_net -intf_net udpAppMux_0_txMetadataFAST [get_bd_intf_pins fast_protocol_0/lbRxMetadataIn] [get_bd_intf_pins udpAppMux_0/txMetadataFAST]
  connect_bd_intf_net -intf_net udpAppMux_0_txReplyPortFAST [get_bd_intf_pins fast_protocol_0/lbPortOpenReplyIn] [get_bd_intf_pins udpAppMux_0/txReplyPortFAST]
  connect_bd_intf_net -intf_net udpAppMux_0_txRequestPortNetwork [get_bd_intf_pins udpAppMux_0/txRequestPortNetwork] [get_bd_intf_pins udp_ip_wrapper/requestPortOpenOut]
  connect_bd_intf_net -intf_net udpAppMux_0_txTimeFAST [get_bd_intf_pins fast_protocol_0/tagsIn] [get_bd_intf_pins udpAppMux_0/txTimeFAST]
  connect_bd_intf_net -intf_net udp_ip_wrapper_AXI_M_Stream [get_bd_intf_pins network_module/S_AXIS] [get_bd_intf_pins udp_ip_wrapper/AXI_M_Stream]
  connect_bd_intf_net -intf_net udp_ip_wrapper_portOpenReplyIn [get_bd_intf_pins udpAppMux_0/rxReplyPortNetwork] [get_bd_intf_pins udp_ip_wrapper/portOpenReplyIn]
  connect_bd_intf_net -intf_net udp_ip_wrapper_rxDataIn [get_bd_intf_pins udpAppMux_0/rxDataNetwork] [get_bd_intf_pins udp_ip_wrapper/rxDataIn]
  connect_bd_intf_net -intf_net udp_ip_wrapper_rxMetadataIn [get_bd_intf_pins udpAppMux_0/rxMetadataNetwork] [get_bd_intf_pins udp_ip_wrapper/rxMetadataIn]

  # Create port connections
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins c_counter_binary_0/Q] [get_bd_pins timer_stream_adapter_0/asyncTime_V]
  # 200 MHz clock from clk_wiz drives all HLS processing IPs, MicroBlaze, and width converters
  connect_bd_net -net clk_wiz_0_clk_200MHz [get_bd_pins clk_wiz_0/clk_200MHz] [get_bd_pins MicroblazeToSwitch_0/ap_clk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins fast_protocol_0/aclk] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins network_module/clk_200] [get_bd_pins order_book_0/ap_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins rst_clk_wiz_0_200M/slowest_sync_clk] [get_bd_pins simple_threshold_0/aclk] [get_bd_pins timer_stream_adapter_0/aclk] [get_bd_pins udpAppMux_0/aclk] [get_bd_pins udp_ip_wrapper/aclk]
  # 125 MHz clock to 1G MAC GTX clock input
  connect_bd_net -net clk_wiz_0_clk_125MHz [get_bd_pins clk_wiz_0/clk_125MHz] [get_bd_pins network_module/clk_125]
  # gnd1 (1-bit 0) as placeholder for LED In1
  connect_bd_net -net gnd1_dout [get_bd_pins gnd1/dout] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net mac_dout [get_bd_pins mac/dout] [get_bd_pins udp_ip_wrapper/myMacAddress_V]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_0_200M/mb_debug_sys_rst]
  # cpu_resetn (active-low): drives reset controllers, LED In0, and NOT gate for network_module reset
  connect_bd_net -net cpu_resetn_1 [get_bd_ports cpu_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins rst_clk_wiz_0_200M/ext_reset_in] [get_bd_pins util_vector_logic_1/Op1] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net regIpAddress_V_1 [get_bd_pins ip/dout] [get_bd_pins udp_ip_wrapper/regIpAddress_V]
  connect_bd_net -net rst_clk_wiz_0_200M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_0_200M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_0_200M_interconnect_aresetn [get_bd_pins MicroblazeToSwitch_0/ap_rst_n] [get_bd_pins fast_protocol_0/aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins network_module/aresetn] [get_bd_pins order_book_0/ap_rst_n] [get_bd_pins rst_clk_wiz_0_200M/interconnect_aresetn] [get_bd_pins simple_threshold_0/aresetn] [get_bd_pins timer_stream_adapter_0/aresetn] [get_bd_pins udpAppMux_0/aresetn] [get_bd_pins udp_ip_wrapper/aresetn]
  connect_bd_net -net rst_clk_wiz_0_200M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_0_200M/mb_reset]
  connect_bd_net -net rst_clk_wiz_0_200M_peripheral_aresetn [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_200M/peripheral_aresetn]
  # sys_diff_clock -> clk_wiz differential input
  connect_bd_net -net sys_diff_clock_clk_p_1 [get_bd_ports sys_diff_clock_clk_p] [get_bd_pins clk_wiz_0/clk_in1_p]
  connect_bd_net -net sys_diff_clock_clk_n_1 [get_bd_ports sys_diff_clock_clk_n] [get_bd_pins clk_wiz_0/clk_in1_n]
  # NOT(cpu_resetn) -> active-high reset to network_module MAC + LED In2
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins network_module/reset] [get_bd_pins util_vector_logic_1/Res] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net xlconcat_0_dout [get_bd_ports led_l] [get_bd_pins xlconcat_0/dout]
  # PHY reset from network_module to top-level port
  connect_bd_net -net phy_rst_n_1 [get_bd_ports phy_rst_n] [get_bd_pins network_module/phy_rst_n]
  # GMII and MDIO interface connections
  connect_bd_intf_net -intf_net network_module_gmii [get_bd_intf_ports gmii] [get_bd_intf_pins network_module/gmii]
  connect_bd_intf_net -intf_net network_module_mdio [get_bd_intf_ports mdio] [get_bd_intf_pins network_module/mdio]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs MicroblazeToSwitch_0/s_axi_AXILiteS/Reg] SEG_MicroblazeToSwitch_0_Reg
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x41400000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_1/S_AXI/Reg] SEG_mdm_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs order_book_0/s_axi_AXILiteS/Reg] SEG_order_book_0_Reg

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



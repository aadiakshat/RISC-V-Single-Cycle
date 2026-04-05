###########################################
## External SRAM Pin Constraints for ZedBoard
## Mapping SRAM_ADDR (19 pins), SRAM_DQ (16 pins), and Control Pins
## This assumes connection via FMC or PMOD Expansion Headers
###########################################

set_property IOSTANDARD LVCMOS33 [get_ports sram_*]

# Control Signals (Example FMC Mapping)
set_property PACKAGE_PIN M19 [get_ports sram_ce_n]
set_property PACKAGE_PIN N19 [get_ports sram_we_n]
set_property PACKAGE_PIN M20 [get_ports sram_oe_n]
set_property PACKAGE_PIN N20 [get_ports sram_lb_n]
set_property PACKAGE_PIN M21 [get_ports sram_ub_n]

# SRAM Address [18:0] (Example FMC Mapping)
set_property PACKAGE_PIN L21 [get_ports {sram_addr[0]}]
set_property PACKAGE_PIN L22 [get_ports {sram_addr[1]}]
set_property PACKAGE_PIN K21 [get_ports {sram_addr[2]}]
set_property PACKAGE_PIN K22 [get_ports {sram_addr[3]}]
set_property PACKAGE_PIN J21 [get_ports {sram_addr[4]}]
set_property PACKAGE_PIN J22 [get_ports {sram_addr[5]}]
set_property PACKAGE_PIN M15 [get_ports {sram_addr[6]}]
set_property PACKAGE_PIN M16 [get_ports {sram_addr[7]}]
set_property PACKAGE_PIN P17 [get_ports {sram_addr[8]}]
set_property PACKAGE_PIN P18 [get_ports {sram_addr[9]}]
set_property PACKAGE_PIN N17 [get_ports {sram_addr[10]}]
set_property PACKAGE_PIN N18 [get_ports {sram_addr[11]}]
set_property PACKAGE_PIN R18 [get_ports {sram_addr[12]}]
set_property PACKAGE_PIN R19 [get_ports {sram_addr[13]}]
set_property PACKAGE_PIN T16 [get_ports {sram_addr[14]}]
set_property PACKAGE_PIN T17 [get_ports {sram_addr[15]}]
set_property PACKAGE_PIN N22 [get_ports {sram_addr[16]}]
set_property PACKAGE_PIN P22 [get_ports {sram_addr[17]}]
set_property PACKAGE_PIN R20 [get_ports {sram_addr[18]}]

# SRAM Data [15:0] (Example FMC Mapping)
set_property PACKAGE_PIN R21 [get_ports {sram_dq[0]}]
set_property PACKAGE_PIN T21 [get_ports {sram_dq[1]}]
set_property PACKAGE_PIN T22 [get_ports {sram_dq[2]}]
set_property PACKAGE_PIN U21 [get_ports {sram_dq[3]}]
set_property PACKAGE_PIN U22 [get_ports {sram_dq[4]}]
set_property PACKAGE_PIN V22 [get_ports {sram_dq[5]}]
set_property PACKAGE_PIN W22 [get_ports {sram_dq[6]}]
set_property PACKAGE_PIN U19 [get_ports {sram_dq[7]}]
set_property PACKAGE_PIN U14 [get_ports {sram_dq[8]}]
set_property PACKAGE_PIN P20 [get_ports {sram_dq[9]}]
set_property PACKAGE_PIN P21 [get_ports {sram_dq[10]}]
set_property PACKAGE_PIN N15 [get_ports {sram_dq[11]}]
set_property PACKAGE_PIN P15 [get_ports {sram_dq[12]}]
set_property PACKAGE_PIN M17 [get_ports {sram_dq[13]}]
set_property PACKAGE_PIN R15 [get_ports {sram_dq[14]}]
set_property PACKAGE_PIN R16 [get_ports {sram_dq[15]}]

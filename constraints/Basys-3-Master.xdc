## Clock (100 MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }]

## Buttons
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33 } [get_ports { btnU }]
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports { btnC }]

## 7-segment segments (a b c d e f g)
## NOTE: seg(6) = a, seg(0) = g in our decoder
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports { seg[6] }]  ;# a
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports { seg[5] }]  ;# b
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { seg[4] }]  ;# c
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports { seg[3] }]  ;# d
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports { seg[2] }]  ;# e
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports { seg[1] }]  ;# f
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports { seg[0] }]  ;# g

## Decimal point
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports { dp }]

## Anodes (active-low). an[0]=rightmost ... an[3]=leftmost
## Anodes (active-low). If digits appear in wrong positions, your anode order is reversed.
## Swap mapping so Vivado's an[3..0] matches physical left->right on your board.

set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports { an[0] }]
set_property -dict { PACKAGE_PIN U4 IOSTANDARD LVCMOS33 } [get_ports { an[1] }]
set_property -dict { PACKAGE_PIN V4 IOSTANDARD LVCMOS33 } [get_ports { an[2] }]
set_property -dict { PACKAGE_PIN W4 IOSTANDARD LVCMOS33 } [get_ports { an[3] }]


transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Doc/Quartus\ Projects/isa\ post\ card {E:/Doc/Quartus Projects/isa post card/ISAPostCard.v}
vlog -sv -work work +incdir+E:/Doc/Quartus\ Projects/isa\ post\ card {E:/Doc/Quartus Projects/isa post card/ISAPostCard.sv}


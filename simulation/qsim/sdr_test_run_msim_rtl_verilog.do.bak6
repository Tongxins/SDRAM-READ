transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/PLL.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdr_para.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/uart_tx.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/uart_speed_select.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/uart_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdr_test.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdram_top.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sys_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/wrfifo.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdfifo_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/rdfifo.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/datagene.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/rom.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/db {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdram_cmd.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdram_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdram_wr_data.v}

vlog -vlog01compat -work work +incdir+F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test {F:/FPGA/EP4CE10-Verilog-VHDL/verilog/SDRAM_Test/sdram_rom_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  sdram_rom_tb

add wave *
view structure
view signals
run 200 ns

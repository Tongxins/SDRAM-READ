//dcfifo ADD_RAM_OUTPUT_REGISTER="ON" CBX_SINGLE_OUTPUT_FILE="ON" CLOCKS_ARE_SYNCHRONIZED="FALSE" INTENDED_DEVICE_FAMILY="Cyclone" LPM_HINT="RAM_BLOCK_TYPE=M4K" LPM_NUMWORDS=512 LPM_SHOWAHEAD="OFF" LPM_TYPE="dcfifo" LPM_WIDTH=16 LPM_WIDTHU=9 OVERFLOW_CHECKING="ON" UNDERFLOW_CHECKING="ON" USE_EAB="ON" data q rdclk rdreq wrclk wrreq wrusedw
//VERSION_BEGIN 13.1 cbx_mgl 2013:10:23:18:06:54:SJ cbx_stratixii 2013:10:23:18:05:48:SJ cbx_util_mgl 2013:10:23:18:05:48:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2013 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.



//synthesis_resources = dcfifo 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgvbv
	( 
	data,
	q,
	rdclk,
	rdreq,
	wrclk,
	wrreq,
	wrusedw) /* synthesis synthesis_clearbox=1 */;
	input   [15:0]  data;
	output   [15:0]  q;
	input   rdclk;
	input   rdreq;
	input   wrclk;
	input   wrreq;
	output   [8:0]  wrusedw;

	wire  [15:0]   wire_mgl_prim1_q;
	wire  [8:0]   wire_mgl_prim1_wrusedw;

	dcfifo   mgl_prim1
	( 
	.data(data),
	.q(wire_mgl_prim1_q),
	.rdclk(rdclk),
	.rdreq(rdreq),
	.wrclk(wrclk),
	.wrreq(wrreq),
	.wrusedw(wire_mgl_prim1_wrusedw));
	defparam
		mgl_prim1.add_ram_output_register = "ON",
		mgl_prim1.clocks_are_synchronized = "FALSE",
		mgl_prim1.intended_device_family = "Cyclone",
		mgl_prim1.lpm_numwords = 512,
		mgl_prim1.lpm_showahead = "OFF",
		mgl_prim1.lpm_type = "dcfifo",
		mgl_prim1.lpm_width = 16,
		mgl_prim1.lpm_widthu = 9,
		mgl_prim1.overflow_checking = "ON",
		mgl_prim1.underflow_checking = "ON",
		mgl_prim1.use_eab = "ON",
		mgl_prim1.lpm_hint = "RAM_BLOCK_TYPE=M4K";
	assign
		q = wire_mgl_prim1_q,
		wrusedw = wire_mgl_prim1_wrusedw;
endmodule //mgvbv
//VALID FILE

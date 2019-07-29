import lc3b_types::*;
module array #(parameter width = 16)
(
	input clk,
	input write,
	input [4:0] index,
	output logic [width-1:0] dataout
);

logic [15:0] dat;
logic [width-1:0] data [31:0];
/* Initialize array */
initial
begin
	for (int i = 0; i < $size(data); i++)
	begin
	  case (i)
	  5'd0: data[i] = 16'h6211; 
	  5'd1: data[i] = 16'h6412; 
	  5'd2: data[i] = 16'h6613; 
	  5'd3: data[i] = 16'h18c2; 
	  5'd4: data[i] = 16'h16c3; 
	  5'd5: data[i] = 16'h9abf; 
	  5'd6: data[i] = 16'h1b41; 
	  5'd7: data[i] = 16'h1905; 
	  5'd8: data[i] = 16'h07fb; 
	  5'd9: data[i] = 16'h5ec4; 
	  5'd10: data[i] = 16'h7e14; 
	  5'd11: data[i] = 16'h6214; 
	  5'd12: data[i] = 16'h91ff; 
	  5'd13: data[i] = 16'h5040; 
	  5'd14: data[i] = 16'h7014; 
	  5'd15: data[i] = 16'h6215; 
	  5'd16: data[i] = 16'h0fff; 
	  5'd17: data[i] = 16'h0001; 
	  5'd18: data[i] = 16'h0002; 
	  5'd19: data[i] = 16'h0008; 
	  5'd20: data[i] = 16'h0022; 
	  5'd21: data[i] = 16'h600d; 
	  5'd22: data[i] = 16'h0000;
	  5'd23: data[i] = 16'h0000;
	  5'd24: data[i] = 16'h0000;
	  5'd25: data[i] = 16'h0000;
     default: data[i] = 16'h0000;
	  endcase 
	end
end

always_ff @(posedge clk)
begin
	if (write == 1)
	begin
		dat = data[index];
	end
end

assign dataout = dat;

endmodule : array
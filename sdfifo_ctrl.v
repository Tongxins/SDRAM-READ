`timescale 1ns / 1ps

module sdfifo_ctrl(
				clk_20m,//20Mʱ��
				clk_100m,//100Mʱ��
				
				wrf_din,			//wrFIFOд������
				wrf_wrreq,		//wrFIFOд������
				sdram_wr_ack,	//wrFIFO�������			
				sys_data_in,		//wrFIFO�������			
				sdram_wr_req,	//����д��SDRAM
				
				sys_data_out,  //rdFIFOд������
				rdf_rdreq,			//rdFIFO�������
				sdram_rd_ack,	//rdFIFOд������
				rdf_dout,			//rdFIFO�������
				sdram_rd_req,	//�������SDRAM
				
				syswr_done,		//д�����ݽ���
				tx_start	,			//��������ڷ���
				
				wrf_use,
				rdf_use
			);

input clk_20m;	//PLL����25MHzʱ��
input clk_100m;	//PLL����100MHzʱ��

//wrfifo
input[15:0] 	wrf_din;							//wrFIFOд������
input 				wrf_wrreq;						//wrFIFOд������
input 				sdram_wr_ack;				//wrFIFO�������	
output[15:0] sys_data_in;					//wrFIFO�������
output 			sdram_wr_req;				//����д��SDRAM


//rdfifo
input[15:0] 	sys_data_out;			//rdFIFOд������
input 				rdf_rdreq;					//rdFIFO�������
input 				sdram_rd_ack;			//rdFIFOд������
output[15:0] rdf_dout;					//rdFIFO�������
output 			sdram_rd_req;			//�������SDRAM


input syswr_done;		//��������д��sdram���ɱ�־λ
output tx_start;			//���ڷ����������־λ������Ч

output[8:0] wrf_use;
output[8:0] rdf_use; 


/*-------------------------------------Wire---------------------------------------------*/
wire[8:0] wrf_use;			//sdram����д�뻺��FIFO���ô洢�ռ����
wire[8:0] rdf_use;			//sdram���ݶ���FIFO���ô洢�ռ����	


/*-------------------------------------Assignment--------------------------------------*/
//assign sys_addr = 22'h1a9e21;	//������
assign sdram_wr_req = ((wrf_use >= 9'd8) & ~syswr_done);	//FIFO��8��16bit���ݣ�������дSDRAM�����ź�


//���޸ġ����ӽ����ж�
assign sdram_rd_req = ((rdf_use <= 9'd256) & syswr_done) && (!read_stop);	//sdramд��������FIFO���գ�256��16bit���ݣ���������SDRAM�����ź�


assign tx_start = ((rdf_use != 9'd0) & syswr_done);				//����ڷ�������

////////////////////////���޸Ŀ�ʼ//////////////////////////////////
//Ϊ��ֻ��ȡ4��SDRAM�������������䣬���������������ֹ����
reg		[3:0]read_counter	=4'd0;
reg		read_stop					=1'd0;
wire	__wire_read_stop	=read_stop;

always @ (posedge sdram_rd_ack)
begin
		if(read_counter==4'd3)
				read_stop	<=1'd1;
		else if(read_stop==1'd0)
				read_counter	<=	read_counter+1;
end
//////////////////////���޸Ľ���////////////////////////////////		

	


wrfifo			uut_wrfifo(
					.data(wrf_din),
					.rdclk(clk_100m),
					.rdreq(sdram_wr_ack),				
					.wrclk(clk_100m),//ע�⣬���ﾭ���޸ģ���Ϊ100M
					.wrreq(wrf_wrreq),
					.q(sys_data_in),
					.wrusedw(wrf_use)
					);	


rdfifo			uut_rdfifo(
					.data(sys_data_out),
					.rdclk(clk_20m),
					.rdreq(rdf_rdreq),				
					.wrclk(clk_100m),
					.wrreq(sdram_rd_ack),
					.q(rdf_dout),
					.wrusedw(rdf_use)
					);	

endmodule

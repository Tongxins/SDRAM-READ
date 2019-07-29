`timescale 1ns / 1ps

module sdr_test(
				rst_n,
				clk,
				clk_100m,
				sdram_clk,
				sdram_cke,
				sdram_cs_n,
				sdram_ras_n,
				sdram_cas_n,
				sdram_we_n,
				sdram_ba,
				sdram_addr,
				sdram_data,
				sdram_udqm,
				sdram_ldqm,	
				rs232_tx,
				tx_start,
				wrf_use,
				rdf_use,
			);

input 			clk;											//ϵͳʱ�ӣ�100MHz
input 			rst_n;									//��λ�źţ��͵�ƽ��Ч
output 		clk_100m;
output 		sdram_clk;							//	SDRAMʱ���ź�
output 		sdram_cke;						//  SDRAMʱ����Ч�ź�
output 		sdram_cs_n;						//	SDRAMƬѡ�ź�
output 		sdram_ras_n;					//	SDRAM�е�ַѡͨ����
output 		sdram_cas_n;					//	SDRAM�е�ַѡͨ����
output 		sdram_we_n;					//	SDRAMд����λ
output		[1:0] sdram_ba;				//	SDRAM��L-Bank��ַ��
output		[12:0] sdram_addr;		//  	SDRAM��ַ����
output 		sdram_udqm;					// 	SDRAM���ֽ����
output 		sdram_ldqm;						// 	SDRAM���ֽ����
inout			[15:0] sdram_data;		// 	SDRAM��������
output 		rs232_tx;							//RS232���������ź�
output 		tx_start;
output 		[8:0] wrf_use;
output 		[8:0] rdf_use;

/*-------------------------------------------------------------------------------
														Wire
*------------------------------------------------------------------------------*/

// SDRAM�ķ�װ�ӿ�
wire sdram_wr_req;			//ϵͳдSDRAM�����ź�
wire sdram_rd_req;			//ϵͳ��SDRAM�����ź�
wire sdram_wr_ack;			//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO��������Ч�ź�
wire sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�	
wire[21:0] sys_addr;			//��дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
wire[15:0] sys_data_in;	//дSDRAMʱ�����ݴ���

wire[15:0] sys_data_out;	//sdram���ݶ���FIFO������������
wire sdram_busy;			// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
wire sys_dout_rdy;			// SDRAM�����������ɱ�־


wire[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
wire wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч

wire[15:0] rdf_dout;		//sdram���ݶ���FIFO������������	
wire rdf_rdreq;			//sdram���ݶ���FIFO�����������󣬸���Ч


wire clk_20m;	//PLL����20MHzʱ��
wire clk_100m;	//PLL����100MHzʱ��
wire sys_rst_n;	//ϵͳ��λ�źţ�����Ч
wire tx_start;		//���ڷ����������־λ������Ч

wire syswr_done;
wire [4:0] index;
wire  write;
wire [15:0] dat;

/*-------------------------------------------------------------------------------
					ϵͳ��λ�źź�PLL����ģ��
*------------------------------------------------------------------------------*/
sys_ctrl		uut_sysctrl(
					.clk(clk),
					.rst_n(rst_n),
					.sys_rst_n(sys_rst_n),
					.clk_20m(clk_20m),
				   .clk_100m(clk_100m),
				   .sdram_clk(sdram_clk)
					);



/*-------------------------------------------------------------------------------
					SDRAM��װ����ģ��
*------------------------------------------------------------------------------*/
sdram_top		uut_sdramtop(				
							.clk(clk_100m),
							.rst_n(sys_rst_n),
							.sdram_wr_req(sdram_wr_req),
							.sdram_rd_req(sdram_rd_req),
							.sdram_wr_ack(sdram_wr_ack),
							.sdram_rd_ack(sdram_rd_ack),	
							.sys_addr(sys_addr),
							.sys_data_in(sys_data_in),
							.sys_data_out(sys_data_out),
							.sdram_cke(sdram_cke),
							.sdram_cs_n(sdram_cs_n),
							.sdram_ras_n(sdram_ras_n),
							.sdram_cas_n(sdram_cas_n),
							.sdram_we_n(sdram_we_n),
							.sdram_ba(sdram_ba),
							.sdram_addr(sdram_addr),
							.sdram_data(sdram_data),
							.sdram_udqm(sdram_udqm),
							.sdram_ldqm(sdram_ldqm)
					);
	
/*-------------------------------------------------------------------------------
					FIFO ģ��
*------------------------------------------------------------------------------*/
sdfifo_ctrl			uut_sdffifoctrl(
						.clk_20m(clk_100m),
						.clk_100m(clk_100m),
						.wrf_din(wrf_din),
						.wrf_wrreq(wrf_wrreq),
						.sdram_wr_ack(sdram_wr_ack),					
						.sys_data_in(sys_data_in),
						.sdram_wr_req(sdram_wr_req),
						.sys_data_out(sys_data_out),
						.rdf_rdreq(rdf_rdreq),
						.sdram_rd_ack(sdram_rd_ack),
						.rdf_dout(rdf_dout),
						.sdram_rd_req(sdram_rd_req),
						.syswr_done(syswr_done),
						.tx_start(tx_start),					
						.wrf_use(wrf_use),
						.rdf_use(rdf_use),
						);	
						

/*-------------------------------------------------------------------------------
					���ݷ���ģ��
*------------------------------------------------------------------------------*/
datagene			uut_datagene(
						.clk_20m(clk_100m),
						.clk_100m(clk_100m),
						.rst_n(sys_rst_n),
						.wrf_din(wrf_din),
						.wrf_wrreq(wrf_wrreq),
						.moni_addr(sys_addr),
						.syswr_done(syswr_done),
						.sdram_rd_ack(sdram_rd_ack),
						.write(write),
						.index(index),
						.datain(dat)
					);

/*-------------------------------------------------------------------------------
					�������ݷ��Ϳ���ģ��
*------------------------------------------------------------------------------*/
uart_ctrl		uut_uartctrl(
					.clk(clk_100m),
					.rst_n(sys_rst_n),
					.tx_data(rdf_dout[7:0]),
					.tx_start(tx_start),		
					.fifo232_rdreq(rdf_rdreq),
					.rs232_tx(rs232_tx)
					);
array    array(
	         .clk(clk_20m),
	         .write(write),
	         .index(index),
	         .dataout(dat)
);

endmodule

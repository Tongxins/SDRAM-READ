`timescale 1ns / 1ps

module datagene(
				clk_20m,
				clk_100m,
				rst_n,
				wrf_din,
				wrf_wrreq,
				moni_addr,
				syswr_done,
				sdram_rd_ack,
				datain,
				write,
				index
			);

input clk_20m;				//FPAG����ʱ���ź�20MHz
input clk_100m;
input rst_n;						//FPGA���븴λ�ź�
input [15:0] datain;
output			[15:0] wrf_din;				//sdram����д�뻺��FIFO������������
output 			wrf_wrreq;	
output         write;
output         [4:0] index;						//sdram����д�뻺��FIFO�����������󣬸���Ч

output			[21:0] moni_addr;			//sdram��д��ַ����
output 			syswr_done;						//��������д��sdram���ɱ�־λ

input 				sdram_rd_ack;					//Ϊ1��ʾϵͳ���ڽ��ж�ȡSDRAM����,��ΪrdFIFO����д��Ч�ź�,���ﲶ�������½�����Ϊ���ַ�����ӱ�־λ


/*-------------------------------------Registers------------------------------------------*/
reg 				sdr_rdackr1;
reg					sdr_rdackr2;
reg					[15:0] delay;			//500us��ʱ������
reg 				wr_done;				//��������д��sdram���ɱ�־λ
reg					[18:0] 	addr;			//sdram��ַ�Ĵ���
reg 				wrf_wrreqr;			//wrfifo��д����Ч�ź�
reg					[15:0] wrf_dinr;	//wrfifo��д������
reg             arwrite;
reg             [4:0] indexx;
/*------------------------------------Wire----------------------------------------------*/
wire 				neg_rdack 		= ~sdr_rdackr1 & sdr_rdackr2;//��׽sdram_rd_ack�źŵ��½���
wire 				delay_done 	= (delay == 16'd50000);	

/*-------------------------------------Parameter---------------------------------------*/
parameter 	[18:0] 	addr_end=19'h00003;//ֻд4��

/*--------------------------------------Assign---------------------------------------------*/
assign        index =indexx;
assign        write = arwrite;
assign 			wrf_wrreq 		= wrf_wrreqr;
assign 			wrf_din 			= wrf_dinr;
assign 			syswr_done 	= wr_done;
assign 			moni_addr 		= {addr,3'b0};

/**************************************************
P1:		����sdram_rd_ack�½��ر�־λ
**************************************************/
always @(posedge clk_100m or negedge rst_n)		
		if(!rst_n) 
			begin
				sdr_rdackr1 <= 1'b0;
				sdr_rdackr2 <= 1'b0;
			end
			
		else 
			begin
				sdr_rdackr1 <= sdram_rd_ack;
				sdr_rdackr2 <= sdr_rdackr1;				
			end


/**************************************************
P2:�ϵ�500us��ʱ�ȴ�sdram����
**************************************************/
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) 
			delay <= 16'd0;
	else if(delay < 16'd50000) 
			delay <= delay+1'b1;

/**************************************************
P3:д�����ɿ��� & ��ַ����
**************************************************/
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) 
			begin
					wr_done	<=1'b0;
					addr 			<= 19'd0;
			end
	else if(addr == addr_end) // 0x80000 * 8 = 4MB Ѱ�ҿռ� ���ٿ�����������16bit��������64Mbit��
			begin
					wr_done 	<= 1'b1;
					addr			<=	19'd0;
			end
	else if(!wr_done && cntwr == 6'h3f) //ÿ64��ʱ�����ڸ���һ�ε�ַ����
			addr 	<= addr+1'b1;	//д��ַ����
					
	else if(neg_rdack) 
			addr	<=	addr+1'b1;

/**************************************************
P4:������дsdram��ַ(ÿ640ns����һ�ε�ַ����)
**************************************************/
//��P3�ϲ���	
		
/**************************************************
P5:ÿ640nsд��8��16bit���ݵ�sdram 
**************************************************/
reg[5:0] cntwr;	//дsdram��ʱ������

always @(posedge clk_100m or negedge rst_n)//ע��������ʱ�ӣ�������100M
	if(!rst_n) 
			cntwr <= 6'd0;
	else if(delay_done) 
			cntwr <= cntwr+1'b1;//�����ϵ�500us��ʱ�������ż���


/**************************************************
P6:дsdram�����źŲ�������wrfifo��д����Ч�ź�
**************************************************/
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) begin
			wrf_wrreqr <= 1'b0;
			indexx <= 5'b0;
	      arwrite <= 1'b0;
			end 
	else if(!wr_done) 
			begin	
					if((cntwr >= 6'h05) && (cntwr < 6'h0d))  begin 
							wrf_wrreqr <= 1'b1;
							indexx <= indexx + 1;
	                  arwrite <= 1'b1;
							end 
					else if(cntwr == 6'h0d) begin  
							wrf_wrreqr <= 1'b0;
		
							end 
			end

	
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) begin 
			wrf_dinr <= 16'h6211;

			end 
	else if(!wr_done && ((cntwr > 6'h05) && (cntwr <= 6'h0d))) 
			begin	
			wrf_dinr <= datain;	
				
			end
	
endmodule















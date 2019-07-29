`timescale 1ns / 1ps
/*****************************************************

// Description	: 		SDRAM״̬����ģ��
//	ʵ�ֹ���			��P1.�ϵ���ʼ200us�ȶ��ڿ���
								P2.��ʱ������������״̬��ʱ�����ƣ�
								P3.SDRAM��ʼ����״̬����ʵ�� init_state_r
								P4.��ʱ������ˢ������(ÿ15us)
								P5.����״̬ʵʱ����	work_state_r(����SDRAM�Ķ�д�Լ���ˢ�²���״̬��)
								P6.�����������߼�
*****************************************************/
module sdram_ctrl(
				clk,
				rst_n,
				sdram_wr_req,
				sdram_rd_req,
				sdram_wr_ack,
				sdram_rd_ack,
				init_state,
				work_state,
				cnt_clk
			);
			

input clk;				//ϵͳʱ�ӣ�100MHz(ʱ�����ڣ�10ns)
input rst_n;			//��λ�źţ��͵�ƽ��Ч


// SDRAM��װ�ӿ�	
input sdram_wr_req;			//ϵͳдSDRAM�����ź�
input sdram_rd_req;			//ϵͳ��SDRAM�����ź�

output sdram_wr_ack;		//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO��������Ч�ź�
output sdram_rd_ack;		//ϵͳ��SDRAM��Ӧ�ź�	
//output sdram_ref_w;		// SDRAM��ˢ�������ź�

//output sdram_busy;			// SDRAMæ��־λ���߱�ʾæ
//output sys_dout_rdy;			// SDRAM�����������ɱ�־


// SDRAM�ڲ��ӿ�
output[4:0] init_state;		// SDRAM��ʼ���Ĵ���
output[3:0] work_state;	// SDRAM����״̬�Ĵ���
output[8:0] cnt_clk;			//ʱ�Ӽ���



wire sdram_init_done;		// SDRAM��ʼ�����ɱ�־���߱�ʾ����
wire sdram_busy;				// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
reg sdram_ref_req;			// SDRAM��ˢ�������ź�
wire sdram_ref_ack;		// SDRAM��ˢ������Ӧ���ź�

`include "sdr_para.v"		// ����SDRAM��������ģ��


// SDRAMʱ����ʱ����
parameter	TRP_CLK		= 9'd4,//TRP=18nsԤ������Ч����(Ԥ����������������Ч����֮�����ӳ�ʱ��)��precharge command period
					TRFC_CLK		= 9'd6,//TRC=60ns�Զ�Ԥˢ������
					TMRD_CLK		= 9'd6,//ģʽ�Ĵ������õȴ�ʱ������
					TRCD_CLK		= 9'd2,//������Ч�����ݶ�д��ʱ��������һ����ȡ2ʱ�����ڻ�������ʱ�����ڣ�
					TCL_CLK			= 9'd2,//Ǳ����TCL_CLK=2��CLK���ڳ�ʼ��ģʽ�Ĵ����п�����
					TREAD_CLK	= 9'd8,//ͻ������������256CLK
					TWRITE_CLK	= 9'd8,//ͻ��д����256CLK
					TDAL_CLK		= 9'd3;//д���ȴ�


//------------------------------------------------------------------------------
//P1���ϵ���200us�ĵȴ�ʱ�䣨����ʱ������Ϊ10ns������Ҫ2����ʱ�����ڣ�
//------------------------------------------------------------------------------
wire done_200us;		//�ϵ���200us�����ȶ��ڽ�����־λ
reg[14:0] cnt_200us; 

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) 
			cnt_200us <= 15'd0;
	else if(cnt_200us < 15'd20_000) 
			cnt_200us <= cnt_200us+1'b1;	

assign done_200us = (cnt_200us == 15'd20_000);	//�ȴ�ʱ�䵽�� done_200us�ź�Ϊ1


//------------------------------------------------------------------------------
//P2����ʱ������������״̬��ʱ�����ƣ�
//------------------------------------------------------------------------------
reg[8:0] cnt_clk_r;		//ʱ�Ӽ���
reg 		cnt_rst_n;		//ʱ�Ӽ�����λ�ź�	

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) 
		cnt_clk_r <= 9'd0;			//�����Ĵ�����λ
	else if(!cnt_rst_n) 
		cnt_clk_r <= 9'd0;	//�����Ĵ�������
	else 
		cnt_clk_r <= cnt_clk_r+1'b1;		//�������ʱ
	
assign cnt_clk = cnt_clk_r;			//�����Ĵ����������ڲ�`define��ʹ�� 

//------------------------------------------------------------------------------
//P3��SDRAM�ĳ�ʼ������״̬��(��20��״̬)
//------------------------------------------------------------------------------
reg[4:0] init_state_r;	// SDRAM��ʼ��״̬

always @ (posedge clk or negedge rst_n)
	if(!rst_n) 
		init_state_r <= `I_NOP;
	else 
		case (init_state_r)
		
				//״̬0���ϵ縴λ��200us������������һ״̬
				`I_NOP: 	
					init_state_r <= done_200us ? `I_PRE:`I_NOP;		
				//״̬1��Ԥ����״̬
				`I_PRE: 	
					init_state_r <= (TRP_CLK == 0) ? `I_AR1:`I_TRP;	
				//״̬2��Ԥ�����ȴ�TRP_CLK����4����ʱ�����ڣ���ʵֻҪ�ٵ�2���ʱ�����ڣ���Ϊ��ʱcnt_clk_r=2
				`I_TRP: 	
					init_state_r <= (cnt_clk_r	== TRP_CLK) ? `I_AR1:`I_TRP;			
				
				//״̬3����1����ˢ�£��������¿�ʼ�����ˣ���ֱ������״̬4
				`I_AR1: 	
					init_state_r <= (TRFC_CLK == 0) ? `I_AR2:`I_TRF1;	
				//״̬4���ȴ���һ����ˢ�½�����60ns
				`I_TRF1:	
					init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_AR2:`I_TRF1;	
				
				//״̬5���ڶ�����ˢ��
				`I_AR2: 	
					init_state_r <= (TRFC_CLK == 0) ? `I_AR3:`I_TRF2; 
				//״̬6���ȴ��ڶ�����ˢ�½�����60ns
				`I_TRF2:	
					init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_AR3:`I_TRF2; 		
				
				//״̬7����������ˢ��
				`I_AR3: 	init_state_r <= (TRFC_CLK == 0) ? `I_AR4:`I_TRF3; 
				//״̬8���ȴ���������ˢ�½���
				`I_TRF3:	init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_AR4:`I_TRF3;	
				
				//״̬9��10�����Ĵ���ˢ��
				`I_AR4: 	init_state_r <= (TRFC_CLK == 0) ? `I_AR5:`I_TRF4; 
				`I_TRF4:	init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_AR5:`I_TRF4; 	
				
				//״̬11,12����������ˢ��
				`I_AR5: 	init_state_r <= (TRFC_CLK == 0) ? `I_AR6:`I_TRF5; 
				`I_TRF5:	init_state_r <= (`end_trfc) ? `I_AR6:`I_TRF5;			
				
				//״̬13,14����������ˢ��
				`I_AR6: 	init_state_r <= (TRFC_CLK == 0) ? `I_AR7:`I_TRF6; 
				`I_TRF6:	init_state_r <= (`end_trfc) ? `I_AR7:`I_TRF6;			
				
				//״̬15,16�����ߴ���ˢ��
				`I_AR7: 	init_state_r <= (TRFC_CLK == 0) ? `I_AR8:`I_TRF7; 
				`I_TRF7: 	init_state_r <= (`end_trfc) ? `I_AR8:`I_TRF7;		
				
				//״̬17,18����8����ˢ��
				`I_AR8: 	init_state_r <= (TRFC_CLK == 0) ? `I_MRS:`I_TRF8;	
				`I_TRF8:	init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_MRS:`I_TRF8;			
				
				//״̬19��ģʽ�Ĵ�������
				`I_MRS:		init_state_r <= (TMRD_CLK == 0) ? `I_DONE:`I_TMRD;
				
				//״̬20���ȴ�ģʽ�Ĵ�����������,TMRD_CLK��ʱ������
				`I_TMRD:	init_state_r <= (cnt_clk_r	== TRFC_CLK) ? `I_DONE:`I_TMRD;		
				
				//״̬21����ʼ������
				`I_DONE:	init_state_r <= `I_DONE;		
				default: init_state_r <= `I_NOP;
		endcase


assign init_state = init_state_r;
assign sdram_init_done = (init_state_r == `I_DONE);// SDRAM��ʼ�����ɱ�־




//------------------------------------------------------------------------------
//P4��15us��ʱ��ÿ60msȫ��4096�д洢������һ����ˢ��( �洢���е��ݵ�������Ч������������64ms )
//------------------------------------------------------------------------------	 
reg[10:0] cnt_15us;	//�����Ĵ���

always @ (posedge clk or negedge rst_n)
	if(!rst_n) 
		cnt_15us <= 11'd0;
	else if(cnt_15us < 11'd1499) 
		cnt_15us <= cnt_15us+1'b1;	// 60ms(64ms)/4096=15usѭ������
	else 
		cnt_15us <= 11'd0;	

always @ (posedge clk or negedge rst_n)
	if(!rst_n) 
		sdram_ref_req <= 1'b0;
	else if(cnt_15us == 11'd1498) 
		sdram_ref_req <= 1'b1;	//������ˢ��������ÿ15us����һ��������-->��������״̬���л�
	else if(sdram_ref_ack) 
		sdram_ref_req <= 1'b0;		//����Ӧ��ˢ�� 

		
		
//------------------------------------------------------------------------------
//P5��SDRAM�Ķ�д�Լ���ˢ�²���״̬��
//------------------------------------------------------------------------------
reg[3:0] work_state_r;		// SDRAM��д״̬
reg 			sys_r_wn;				// SDRAM��/д�����źţ���SDRAM��1��дSDRAM��0

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) 
		work_state_r <= `W_IDLE;
	else 
		case (work_state_r)
			//״̬0������״̬�����������������1.��ˢ��������2.��������3.д������
 			`W_IDLE:	
						//����1��������ˢ������(CS#=0,RAS#=0,CAS#=0,WE#=1)
						if(sdram_ref_req & sdram_init_done) 
							begin
								work_state_r <= `W_AR; 		//��ʱ��ˢ������
								sys_r_wn <= 1'b1;
							end 
						
						//����2��дSDRAM����,��������Ч״̬(CS#=0,RAS#=0,CAS#=1,WE#=1)
						else if(sdram_wr_req & sdram_init_done)//д���� 
							begin
								work_state_r <= `W_ACTIVE;//дSDRAM
								sys_r_wn <= 1'b0;	
							end		
						//����3����SDRAM����,,��������Ч״̬
						else if(sdram_rd_req && sdram_init_done)//������
							begin
								work_state_r <= `W_ACTIVE;//��SDRAM
								sys_r_wn <= 1'b1;	
							end
						//ʲôҲû�з���..����IDLE..
						else 
							begin 
								work_state_r <= `W_IDLE;
								sys_r_wn <= 1'b1;
							end	
						
						
			//״̬1������Ч���ж϶�д
			`W_ACTIVE: 	
						if(TRCD_CLK == 0)//��������ȷ������
							if(sys_r_wn) 
									work_state_r <= `W_READ;
							else 
									work_state_r <= `W_WRITE;
						else 
							work_state_r <= `W_TRCD;

			//״̬2���ȴ�RCD��ʱ��Ȼ��ת����/д״̬			
			`W_TRCD:	 if(cnt_clk_r	== TRCD_CLK-1)
						 	 if(sys_r_wn) 
									work_state_r <= `W_READ;
						 	 else 
									work_state_r <= `W_WRITE;
						else 
							work_state_r <= `W_TRCD;
							
			//״̬3����״̬������ת��Ǳ����
			`W_READ:	work_state_r <= `W_CL;
			
			//״̬4��Ǳ���ڣ�ֻ�ж�SDRAM��ʱ�����У���Ǳ����ʱ�䵽��ת�����ݶ�ȡ״̬
			`W_CL:		work_state_r <= (cnt_clk_r== TCL_CLK-1) ? `W_RD:`W_CL;	
			
			//״̬5����ȡ����(�����Ҫ��8��)
			`W_RD:		work_state_r <= (cnt_clk_r	== TREAD_CLK+2) ? `W_RWAIT:`W_RD;	//������Ҫ����һ�������ɺ���Ԥ�����ȴ�״̬
			
			//״̬6����ȡ��Ҫ���г��磬���ɺ���������״̬
			`W_RWAIT:	work_state_r <= (cnt_clk_r	== TRP_CLK) ? `W_IDLE:`W_RWAIT;
			
			//״̬7�� д״̬����,����Ҫ����Ǳ����
			`W_WRITE:	work_state_r <= `W_WD;
			
			//״̬8��д���ȴ���������
			`W_WD:		work_state_r <= (cnt_clk_r	== TWRITE_CLK-2) ? `W_TDAL:`W_WD;
			
			//״̬9���ȴ�д���ݲ���ˢ�½���
			`W_TDAL:		work_state_r <= (`end_tdal) ? `W_IDLE:`W_TDAL;
			
			
			//״̬10����ʼ��ˢ��			
			`W_AR:		
					work_state_r <= (TRFC_CLK == 0) ? `W_IDLE:`W_TRFC; 
					
			//״̬11����ˢ�µȴ�
			`W_TRFC:	
					work_state_r <= (cnt_clk_r	== TRFC_CLK) ? `W_IDLE:`W_TRFC;
					
			default: 	
					work_state_r <= `W_IDLE;
					
		endcase
end

// SDRAM����״̬�Ĵ�����ģ��������
assign work_state = work_state_r;	
	
// SDRAMæ��־λ��ģ��������
//assign sdram_busy = (sdram_init_done && work_state_r == `W_IDLE) ? 1'b0:1'b1;	

// SDRAM��ˢ��Ӧ���źţ��ڲ���ߣ�
assign sdram_ref_ack = (work_state_r == `W_AR);		

//��ʾ�������wrFIFO�е����ݣ�д��sdram
//���������䣺	1.��ǰ��������Ч�ȴ��Ҵ���д״̬
//							2.��ǰ���ڡ�׼��д����״̬��
//							3.��ǰ����д״̬���Ҽ�������С��6
assign sdram_wr_ack = ((work_state == `W_TRCD) & ~sys_r_wn) | (work_state == `W_WRITE) 
						| ((work_state == `W_WD) & (cnt_clk_r < 9'd6));		

//��SDRAM��Ӧ�ź�		

//ԭʼֵ				
//assign sdram_rd_ack = (work_state_r == `W_RD) & (cnt_clk_r > 9'd1) & (cnt_clk_r < 9'd10);		
assign sdram_rd_ack = (work_state_r == `W_RD) & (cnt_clk_r >=9'd0) & (cnt_clk_r < 9'd8);


// SDRAM�����������ɱ�־
//assign sys_dout_rdy = (work_state_r == `W_RD && `end_tread);		






//------------------------------------------------------------------------------
//P6�������������߼�
//------------------------------------------------------------------------------
always @ (init_state_r or work_state_r or cnt_clk_r) 
	begin
		case (init_state_r)
			//״̬1����������0
	    	`I_NOP:	
				cnt_rst_n <= 1'b0;
			//״̬2��Ԥ����״̬����ʱ�������cnt_rst_n=1
	   	`I_PRE:	cnt_rst_n <= (TRP_CLK != 0);	
			//״̬3������Ҫִ�кü��Σ�ֱ��Ԥ������ʱ����������������������
	   	`I_TRP:	cnt_rst_n <= (cnt_clk_r	== TRP_CLK) ? 1'b0:1'b1;	
			
			//ֻҪ��ʼ��һ����ˢ�£��ͽ�������ֵ����1
	    	`I_AR1,`I_AR2,`I_AR3,`I_AR4,`I_AR5,`I_AR6,`I_AR7,`I_AR8:
	         		cnt_rst_n <= (TRFC_CLK != 0);			//��ˢ����ʱ��������
						
			//�ȴ���ˢ����ʱ����������������������			
	    	`I_TRF1,`I_TRF2,`I_TRF3,`I_TRF4,`I_TRF5,`I_TRF6,`I_TRF7,`I_TRF8:
	         		cnt_rst_n <= (`end_trfc) ? 1'b0:1'b1;	
						
			`I_MRS:	cnt_rst_n <= (TMRD_CLK != 0);			//ģʽ�Ĵ���������ʱ��������
			`I_TMRD:	cnt_rst_n <= (cnt_clk_r	== TMRD_CLK) ? 1'b0:1'b1;	//�ȴ���ˢ����ʱ����������������������
			
		   `I_DONE:
						case (work_state_r)
								//����
								`W_IDLE:	cnt_rst_n <= 1'b0;
								
								//����Ч
								`W_ACTIVE: 	cnt_rst_n <= (TRCD_CLK == 0) ? 1'b0:1'b1;
								
								//RCD�ȴ�
								`W_TRCD:	cnt_rst_n <= (cnt_clk_r	== TRCD_CLK-1) ? 1'b0:1'b1;
								
								//Ǳ����
								`W_CL:		cnt_rst_n <= (cnt_clk_r   == TCL_CLK-1) ? 1'b0:1'b1;
								
								//
								`W_RD:		cnt_rst_n <= (cnt_clk_r	== TREAD_CLK+2) ? 1'b0:1'b1;
								
								//
								`W_RWAIT:	cnt_rst_n <= (`end_trwait) ? 1'b0:1'b1;
								
								//
								`W_WD:		cnt_rst_n <= (`end_twrite) ? 1'b0:1'b1;
								
								//
								`W_TDAL:	cnt_rst_n <= (`end_tdal) ? 1'b0:1'b1;
								
								//
								`W_TRFC:	
										cnt_rst_n <= (`end_trfc) ? 1'b0:1'b1;
										
								default: cnt_rst_n <= 1'b0;
		         	endcase
		default: 
				cnt_rst_n <= 1'b0;
		endcase
	end

endmodule

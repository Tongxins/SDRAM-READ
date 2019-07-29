`timescale 1ns / 1ps
/*****************************************************

// Description	: 		SDRAM����ģ��
//	ʵ�ֹ���			��	�����߼�ʵ��
*****************************************************/
module sdram_cmd(
				clk,rst_n,
				sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,sdram_we_n,sdram_ba,sdram_addr,
				sys_addr,
				init_state,work_state
			);

			
input clk;					//50MHz
input rst_n;				//�͵�ƽ��λ�ź�

// SDRAMӲ���ӿ�
output 			sdram_cke;				// SDRAMʱ����Ч�ź�
output 			sdram_cs_n;				//	SDRAMƬѡ�ź�
output 			sdram_ras_n;			//	SDRAM�е�ַѡͨ����
output 			sdram_cas_n;			//	SDRAM�е�ַѡͨ����
output 			sdram_we_n;			//	SDRAMд����λ
output[1:0] 	sdram_ba;					//	SDRAM��L-Bank��ַ��
output[12:0] sdram_addr;				// SDRAM��ַ����

// SDRAM��װ�ӿ�
input[21:0] sys_addr;			// ��дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 

// SDRAM�ڲ��ӿ�
input[4:0] init_state;			// SDRAM��ʼ��״̬�Ĵ���
input[3:0] work_state;		// SDRAM��д״̬�Ĵ���


`include "sdr_para.v"		// ����SDRAM��������ģ��

//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
reg[4:0] 	sdram_cmd_r;		//	SDRAM���������Ӧ5���ܽ�
reg[1:0] 	sdram_ba_r;			//BA[1:0]
reg[11:0] 	sdram_addr_r;

//�����ܽţ�	4				3				2				1				0
//						cke			cs_n		ras_n		cas_n		we_n
assign {sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,sdram_we_n} = sdram_cmd_r;
assign sdram_ba = sdram_ba_r;
assign sdram_addr = {1'b0,sdram_addr_r};

//-------------------------------------------------------------------------------
//SDRAM����������ֵ
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) 
			begin
				sdram_cmd_r <= 5'b01111;//�ϵ�������
				sdram_ba_r <= 2'b11;			//�ϵ�����ѡ����ʼֵ	
				sdram_addr_r <= 12'hfff;	//��ַ���߳�ʼ��
			end
			
	else
		case (init_state)
				`I_NOP,`I_TRP,`I_TRF1,`I_TRF2,`I_TRF3,`I_TRF4,`I_TRF5,`I_TRF6,`I_TRF7,`I_TRF8,`I_TMRD: 
					begin
						sdram_cmd_r <= `CMD_NOP;// 10111 �ղ�������
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;	
					end
					
				`I_PRE: //Ԥ����
					begin
						sdram_cmd_r <= `CMD_PRGE;//10010	Ԥ��������
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;
					end 
					
				`I_AR1,`I_AR2,`I_AR3,`I_AR4,`I_AR5,`I_AR6,`I_AR7,`I_AR8: //��ˢ��
					begin
						sdram_cmd_r <= `CMD_A_REF;//10001 ��ˢ������
						sdram_ba_r <= 2'b11;
						sdram_addr_r <= 12'hfff;						
					end 	
					
				`I_MRS: //��Ҫ������������
						begin	//ģʽ�Ĵ������ã��ɸ���ʵ����Ҫ��������
							sdram_cmd_r <= `CMD_LMR;//10000 ģʽ�Ĵ�������
							sdram_ba_r <= 2'b00;	//����ģʽ����
							sdram_addr_r <= {
										 2'b00,			//����ģʽ����
										 1'b0,			//����ģʽ����(��������ΪA9=0,��ͻ����/ͻ��д)
										 2'b00,			//����ģʽ����({A8,A7}=00),��ǰ����Ϊģʽ�Ĵ�������
										 
										 3'b010,			// CASǱ��������(��������Ϊ2��{A6,A5,A4}=010)
										 1'b0,				//ͻ�����䷽ʽ(��������Ϊ˳����A3=b0)
										 3'b011			//ͻ������(��������Ϊ8��{A2,A1,A0}=011)
									};
						end	
						
				`I_DONE:
					case (work_state)
					
								//�����Լ����ֵȴ�ʱ�䶼������NOP
								`W_IDLE,`W_TRCD,`W_CL,`W_TRFC,`W_RD,`W_WD,`W_TDAL: 
										begin
												sdram_cmd_r <= `CMD_NOP;
												sdram_ba_r <= 2'b11;
												sdram_addr_r <= 12'hfff;
										end
										
									//	����Ч״̬
									`W_ACTIVE: 
											begin
												sdram_cmd_r 	<= `CMD_ACTIVE;		//10011 ����Ч����
												sdram_ba_r 		<= sys_addr[21:20];	//L-Bank��ַ
												sdram_addr_r 	<= sys_addr[19:8];		//�е�ַ
											end
								
									
									`W_READ: 
											begin
												sdram_cmd_r <= `CMD_READ;		//10101 ��ʼ��������е�ַ
												sdram_ba_r <= sys_addr[21:20];	//L-Bank��ַ
												sdram_addr_r <= {
																4'b0100,				// A10=1,����д��������Ԥ����
																sys_addr[7:0]	//�е�ַ  
															};
											end
										
									`W_WRITE: 
											begin
													sdram_cmd_r <= `CMD_WRITE;//10100 ��ʼд�������е�ַ
													sdram_ba_r <= sys_addr[21:20];	//L-Bank��ַ
													sdram_addr_r <= {
																	4'b0100,				// A10=1,����д��������Ԥ����
																	sys_addr[7:0]	//�е�ַ  
																};
											end				
											
									`W_AR: 
											begin
													sdram_cmd_r <= `CMD_A_REF;//10001 ��ˢ��
													sdram_ba_r <= 2'b11;
													sdram_addr_r <= 12'hfff;	
											end
											
							default: begin
									sdram_cmd_r <= `CMD_NOP;
									sdram_ba_r <= 2'b11;
									sdram_addr_r <= 12'hfff;	
								end
						endcase
						
						
				default: begin
							sdram_cmd_r <= `CMD_NOP;
							sdram_ba_r <= 2'b11;
							sdram_addr_r <= 12'hfff;	
						end
			endcase
end

endmodule


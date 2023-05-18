module router_fsm_tb();
reg clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid, fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg[1:0]data_in;
wire detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy;

router_fsm DUT(clock,resetn,pkt_valid,busy,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,
                   fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

always #10 clock = ~clock;

task initialize();
begin
resetn = 1'b0;
soft_reset_0 = 1'b0;
soft_reset_1 = 1'b0;
soft_reset_2 = 1'b0;
pkt_valid = 1'b0;
clock = 1'b0;
low_pkt_valid = 1'b1;
fifo_full = 1'b0;
parity_done = 1'b0;
fifo_empty_0 = 1'b1;
fifo_empty_1 = 1'b1;
fifo_empty_2 = 1'b1;
end
endtask

task rstn;
begin
@(negedge clock)
resetn = 1'b0;
@(negedge clock)
resetn = 1'b1;
end
endtask

task soft_rst_0;
begin
soft_reset_0 = 1'b1;
#15;
soft_reset_0 = 1'b0;
end
endtask

task soft_rst_1;
begin
soft_reset_1 = 1'b1;
#15;
soft_reset_1 = 1'b0;
end
endtask

task soft_rst_2;
begin
soft_reset_2 = 1'b1;
#15
soft_reset_2 = 1'b0;
end
endtask

task DA_LFD_LD_LP_CPE_DA;
begin
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
#20;
fifo_full = 1'b0;
pkt_valid = 1'b0;
#10;
fifo_full = 1'b0;
end
endtask

task DA_LFD_LD_FFS_LAF_LP_CPE_DA;
begin
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
#20 fifo_full = 1'b1;
#20 fifo_full = 1'b0;
#30; 
parity_done = 1'b0;
low_pkt_valid = 1'b1;
#20;
fifo_full = 1'b0;
end
endtask

task DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
begin
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
#20 fifo_full = 1'b1;
#20 fifo_full = 1'b0;
#30;
parity_done = 1'b0;
low_pkt_valid = 1'b0;
#30;
fifo_full = 1'b0;
pkt_valid = 1'b0;
#20 fifo_full = 1'b0;
end
endtask

task DA_LFD_LD_LP_CPE_FFS_LAF_DA;
begin
pkt_valid = 1'b1;
data_in = 2'b01;
fifo_empty_1 = 1'b1;
#30; 
fifo_full = 1'b0;
pkt_valid = 1'b0;
#20 fifo_full = 1'b1;
#20 fifo_full = 1'b0;
#20 parity_done = 1'b1;
end
endtask

initial
begin
initialize;
rstn;
DA_LFD_LD_LP_CPE_DA;
#120;
DA_LFD_LD_FFS_LAF_LP_CPE_DA;
#160;
DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
#200;
DA_LFD_LD_LP_CPE_FFS_LAF_DA;
#100;
$finish;
end
endmodule



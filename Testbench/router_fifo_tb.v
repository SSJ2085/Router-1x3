module router_fifo_tb();

reg clock, resetn, soft_reset, write_enb, read_enb, lfd_state;
reg[7:0]data_in;
wire empty,full;
wire[7:0]data_out;
integer k;
integer i;

router_fifo DUT(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);

task initialize();
begin
clock = 1'b0;
resetn = 1'b0;
soft_reset = 1'b0;
write_enb = 1'b0;
read_enb = 1'b0;
end
endtask

always #10 clock = ~clock;
task rst_dut();
begin
@(negedge clock);
resetn = 1'b0;
@(negedge clock);
resetn = 1'b1;
end
endtask

task softrst_dut();
begin
@(negedge clock);
soft_reset = 1'b1;
@(negedge clock);
soft_reset = 1'b0;
end
endtask

task write_fifo();
reg[7:0] payload_data,parity,header;
reg[5:0]payload_len;
reg[1:0]addr;
begin
@(negedge clock)
payload_len= 6'd14;
addr = 2'b01;
header = {payload_len,addr};
data_in = header;
lfd_state = 1'b1;
write_enb = 1'b1;
for(k=0;k<payload_len;k=k+1)
begin
@(negedge clock);
lfd_state = 1'b1;
payload_data = {$random}%256;
data_in = payload_data;
end
@(negedge clock)
lfd_state = 1'b0;
parity = ($random)%256;
data_in = parity;
end
endtask

task read_fifo();
begin
@(negedge clock);
write_enb = 1'b0;
read_enb = 1'b1;
end
endtask

initial
begin
initialize;
#50;
rst_dut;
softrst_dut;

write_fifo;
for(i=0;i<17;i=i+1)
read_fifo;
#50;

read_enb  = 1'b0;
end

initial
$monitor("data_in = %d, data_out = %d, full = %b, empty = %b",data_in,data_out,full,empty);
endmodule

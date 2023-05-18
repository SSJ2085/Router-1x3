module router_top_tb();
reg clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
reg[7:0] data_in;
wire vld_out_0,vld_out_1,vld_out_2,err,busy;
wire [7:0] data_out_0,data_out_1,data_out_2;

router_top DUT(clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2,data_in,vld_out_0,vld_out_1,vld_out_2,err,busy,data_out_0,data_out_1,data_out_2);

task initialize();
begin
clock = 1'b0;
resetn = 1'b1;
end
endtask

always #10 clock =~clock;

task rst_dut();
begin
@(negedge clock)
resetn = 1'b0;
{read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in}=0;
@(negedge clock)
resetn =1'b1;
end
endtask

task packet_14();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_len;
reg [1:0] addr;
integer k;
begin
@(negedge clock)
wait(~busy)
@(negedge clock)
payload_len = 6'd14;
addr = 2'b01;
header ={payload_len,addr};
parity = 8'b0;
data_in = header;
pkt_valid = 1'b1;
parity = parity^header;
@(negedge clock)
wait(~busy)
for(k=0;k<payload_len;k=k+1)
begin
@(negedge clock);
wait(~busy)
payload_data = {$random}%256;
pkt_valid=1'b1;
data_in = payload_data;
parity = parity^data_in;
end
@(negedge clock);
wait(~busy)
pkt_valid = 1'b0;
data_in = parity;
end
endtask


// Packet_16

task packet_16();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_len;
reg [1:0] addr;
integer k;
begin
@(negedge clock)
wait(~busy)
@(negedge clock)
payload_len = 6'd16;
addr = 2'b01;
header ={payload_len,addr};
parity = 8'b0;
data_in = header;
pkt_valid = 1'b1;
parity = parity^header;
@(negedge clock)
wait(~busy)
for(k=0;k<payload_len;k=k+1)
begin
@(negedge clock)
wait(~busy)
payload_data = {$random}%256;
pkt_valid=1'b1;
data_in = payload_data;
parity = parity^data_in;
end
@(negedge clock);
wait(~busy)
pkt_valid = 1'b0;
data_in = parity;
end
endtask


initial
begin
initialize;
rst_dut;
packet_16;
@(negedge clock)
read_enb_1=1'b1;
wait(!vld_out_1)
@(negedge clock)
read_enb_1=1'b0;
#10;
packet_14;
@(negedge clock)
read_enb_1=1'b1;
wait(!vld_out_1)
@(negedge clock)
read_enb_1=1'b0;
packet_16;
@(negedge clock)
read_enb_1=1'b1;
wait(!vld_out_1)
@(negedge clock)
read_enb_1=1'b0;
$finish;
end
endmodule

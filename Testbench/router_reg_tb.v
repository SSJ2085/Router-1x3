module router_reg_tb();
reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,
ld_state,laf_state,full_state,lfd_state;
reg [7:0]data_in;
wire parity_done,low_pkt_valid,err;
wire [7:0]dout;

router_reg dut(clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,
ld_state,laf_state,full_state,lfd_state,data_in,parity_done,low_pkt_valid,err,dout);

always #10 clock=~clock;
 
task initialise();
begin 
clock=1'b0;
resetn=1'b1;
pkt_valid=1'b0;
fifo_full=1'b0;
rst_int_reg=1'b0;
detect_add=1'b0;
ld_state=1'b0;
laf_state=1'b0;
full_state=1'b0;
lfd_state=1'b0;
end
endtask

task rst_dut();
begin
@(negedge clock)
resetn=1'b0;
@(negedge clock)
resetn=1'b1;
end
endtask

initial
begin
initialise();
rst_dut();
fifo_full=1'b0;
full_state=1'b0;
#20 pkt_valid=1'b1;// loads the datain into hold header byte
detect_add=1'b1;
data_in=8'd5;
#20 detect_add=1'b0; //hold header byte gets through the dout
lfd_state=1'b1;
#20 lfd_state=1'b0;
data_in=8'd7;
ld_state=1'b1;// data_in goes to dout
#20 data_in=7'd8;
#20 data_in=7'd1;
#20 ld_state=1'b1;
fifo_full=1'b1;
data_in=7'd2;// loads datain into ffb
#20 fifo_full=1'b0;
full_state=1'b0;
ld_state=1'b0;
laf_state=1'b1;// ffb gets through dout
#40 laf_state=1'b0;
ld_state=1'b1;
pkt_valid=1'b0;
#20 data_in=8'd3;
#40 rst_int_reg=1'b1;
#250;
$finish;
end
endmodule
 



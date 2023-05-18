module router_reg(clock, resetn, pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state, laf_state,full_state,lfd_state,err,low_pkt_valid,parity_done,data_in,dout);

input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;
input [7:0]data_in;
output reg err,parity_done,low_pkt_valid;
output reg [7:0]dout;
reg[7:0] hold_header_byte,fifo_full_state_byte, internal_parity, packet_parity_byte;

always@(posedge clock)
begin
if(~resetn)
begin
hold_header_byte <= 8'b0;
fifo_full_state_byte <= 8'b0;
end
else if(pkt_valid && detect_add)
hold_header_byte <= data_in;
else if(ld_state && fifo_full)
fifo_full_state_byte <= data_in;
end

always@(posedge clock)
begin
if(~resetn)
dout <= 8'b0;
else if(lfd_state)
dout<= hold_header_byte;
else if(ld_state && ~fifo_full)
dout<=data_in;
else if(laf_state)
dout<=fifo_full_state_byte;
end

// Low packect valid logic
always@(posedge clock)
begin
if(~resetn)
low_pkt_valid <= 1'b0;
else if(ld_state && ~pkt_valid)
low_pkt_valid <= 1'b1;
else if(rst_int_reg)
low_pkt_valid <= 1'b0;
end

// parity_done login

always@(posedge clock)
begin
if(~resetn)
parity_done<=1'b0;
else if(detect_add)
parity_done<=1'b0;
else if((ld_state && ~fifo_full && ~pkt_valid)||(laf_state && pkt_valid && ~parity_done))
parity_done<=1'b1;
end

// Packet Parity logic
always@(posedge clock)
begin
if(~resetn)
packet_parity_byte <=8'b0;
else if(detect_add)
packet_parity_byte <=8'b0;
else if(ld_state && ~pkt_valid)
packet_parity_byte <= data_in;
end

// internal parity logic
always@(posedge clock)
begin
if(!resetn)
internal_parity <=8'b0;
else if(detect_add)
internal_parity <=8'b0;
else if(lfd_state)
internal_parity<= internal_parity^hold_header_byte;
else if(ld_state && pkt_valid && ~full_state)
internal_parity <= internal_parity^data_in;
end

// error logic

always@(posedge clock)
begin 
if(!resetn)
err<=1'b0;
else if(parity_done && (internal_parity != packet_parity_byte))
err<=1'b1;
else
err<=1'b0;
end

endmodule

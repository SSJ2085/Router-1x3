module router_fifo(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);
input clock,resetn,soft_reset,read_enb,write_enb,lfd_state;
input[7:0]data_in;
output full,empty;
output reg [7:0]data_out;

reg[8:0]mem[15:0];
reg[6:0]fifo_counter;

reg[4:0]rd_pt,wr_pt;
reg lfd_temp;

integer i;

// delay lfd by 1 cycle
always@(posedge clock)
begin
if(!resetn)
lfd_temp <= 1'b0;
else
lfd_temp = lfd_state;
end

//----Pointer generation block----
always@(posedge clock) 
begin
if(!resetn)
wr_pt<=0;
else if(soft_reset)
wr_pt<=0;
else if(write_enb && (~full))
wr_pt<=wr_pt+1;
end

always@(posedge clock) //Read address
begin
if(!resetn)
rd_pt<=0;
else if(soft_reset)
rd_pt<=0;
else if(read_enb && (~empty))
rd_pt<=rd_pt+1;
end

//fifo counter logic
always@(posedge clock)
begin
if(!resetn)
begin
fifo_counter <=7'b0000000;
end
else if(soft_reset)
begin
fifo_counter <=7'b0000000;
end
else if(read_enb && ~empty)
begin
if(mem[rd_pt[3:0]][8]==1'b1)
fifo_counter <=mem[rd_pt[3:0]][7:2]+1'b1;
else if(fifo_counter !=0)
fifo_counter <= fifo_counter -1'b1;
end
end

// read operation
always@(posedge clock)
begin
if(!resetn)
data_out <= 8'b0;
else if(soft_reset)
data_out <= 8'bz;
else if(fifo_counter == 0)
data_out <= 8'bz;
else if(read_enb && ~empty)
data_out <= mem[rd_pt[3:0]][7:0];
end

always@(posedge clock)
begin
if(!resetn || soft_reset)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;
end
else if(write_enb && (~full))
begin
if(lfd_temp)
begin
mem[wr_pt[3:0]][8]<=1'b1;
mem[wr_pt[3:0]][7:0]<=data_in;
end
else
begin
mem[wr_pt[3:0]][8]<=1'b0;
mem[wr_pt[3:0]][7:0]<=data_in;
end
end
end

assign full = (wr_pt==({~rd_pt[4],rd_pt[3:0]}))?1'b1:1'b0;
assign empty = (wr_pt == rd_pt)?1'b1:1'b0;
endmodule

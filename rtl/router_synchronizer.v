module router_sync(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2);

input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
input [1:0]data_in;
output reg[2:0]write_enb;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
output vld_out_0,vld_out_1,vld_out_2;
reg [1:0] data_in_tmp;
reg[4:0]count0,count1,count2;

always@(posedge clock)
begin
if(~resetn)
data_in_tmp<= 2'b00;
else if(detect_add)
data_in_tmp<=data_in;
else
data_in_tmp <= 2'b11;
end

// write enable logic
always@(*)
begin
write_enb = 3'b000;
if(write_enb_reg)
begin
case(data_in_tmp)
2'b00: write_enb<=3'b001;
2'b01: write_enb<=3'b010;
2'b10: write_enb<=3'b100;
default: write_enb <=3'b000;
endcase
end
end

//-----------------------------------Valid Byte block----------------------------------

assign vld_out_0 = (~empty_0);
assign vld_out_1 = (~empty_1);
assign vld_out_2 = (~empty_2);

// fifo full logic
always@(*)
begin
case(data_in_tmp)
2'b00: fifo_full<=full_0;
2'b01: fifo_full<=full_1;
2'b10: fifo_full<=full_2;
default: fifo_full<=0;
endcase
end

//---------------------------------soft_reset_0-----------------------------------------

always@(posedge clock)
begin
if(~resetn)
begin
count0<=0;
soft_reset_0<=0;
end
else if(vld_out_0)
begin
if(~read_enb_0)
begin
if(count0==29)
begin
soft_reset_0<=1'b1;
count0<=0;
end
else
begin
soft_reset_0<=1'b0;
count0<=count0+1'b1;
end
end
else
count0<=0;
end
end

always@(posedge clock)
  begin
  
  if(~resetn)
  begin
  count1<=0;
  soft_reset_1<=0;
  end

  else if(vld_out_1)
  begin
  if(~read_enb_1)
   
    begin
    if(count1==29)
      begin
      soft_reset_1<=1'b1;
      count1<=0;
      end
    else
      begin
      soft_reset_1<=1'b0;
      count1<=count1+1'b1;
      end
    end
  else
  count1<=0;
  end
  end

always@(posedge clock)
  begin
  
  if(~resetn)
  begin
  count2<=0;
  soft_reset_2<=0;
  end

  else if(vld_out_2)
  begin
  if(~read_enb_2)
   
    begin
    if(count2==29)
      begin
      soft_reset_2<=1'b1;
      count2<=0;
      end
    else
      begin
      soft_reset_2<=1'b0;
      count2<=count2+1'b1;
      end
    end
  else
  count2<=0;
  end
  end

endmodule

`timescale 1ns / 1ps



module keyboard(
input wire clk, reset,
input wire ps2d, ps2c,
output wire left, right, enter,
output reg key_relese
);
//declare veriables
wire [7:0] dout;
wire rx_done_tick;
supply1 rx_en; // always HIGH
reg [7:0] key;

//instantiate models
// Board converts USB to PS2, we grab that data with this module
ps2_rx ps2(clk, reset, ps2d, ps2c, 
            rx_en, rx_done_tick, dout);

//sequencial logic
always@(posedge clk)
begin
    if(rx_done_tick)
    begin 
        key <=dout; //key is one rx cycle behind dout
    if(key == 8'hf0)    //check if the key has been relesed
        key_relese <= 1'b1;
    else
        key_relese <= 1'b0;
    end
    
end
//output control keys of interest
assign left = (key==8'h1c) & !key_relese; // 1c is the code for 'A'
assign right = (key==8'h23) & !key_relese; // 1b is the code for 'B'
assign enter = (key==8'h5a) & !key_relese; // 5a is the code for 'Enter'



endmodule
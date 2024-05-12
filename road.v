`timescale 1ns / 1ps
module road(
input wire clk, reset,refresh_tick, pause,enter_key,
input wire [9:0] pixel_x, pixel_y,
output wire road_on, output reg finish_line,
output reg [11:0] road_rgb
);

//variables 
//square canvas for the road 
localparam MAX_X = 512;
localparam MAX_Y = 480;
localparam road_x_l = 64;
localparam road_x_r = road_x_l + MAX_X-1;
localparam road_y_t = 0;
localparam road_y_b = MAX_Y-1;
localparam road_x_delta = 120; //thickness of the road
 
reg [9:0] road_rom_addr; //960 lines
reg [8:0] road_rom_col; //512 lines
reg [0:511] road_rom_data; //x data length
wire road_rom_bit, canvas_on;
reg [11:0] counter, tempC;
reg [1:0] finish;
reg slow_count; //[1:0]


assign canvas_on =  (road_x_l<=pixel_x) && (pixel_x<=road_x_r);
assign road_rom_bit = road_rom_data[road_rom_col];
assign road_on = canvas_on & road_rom_bit;

//rolling road
always@(posedge clk)
begin
if(reset)
    begin
    // reset the road position,
    // sets the road such that car is at a flat part of the road
    counter <=4*MAX_Y -440; 
    finish <= 0;
    end
//if paused, don't increament the counter, pause the movement
else if(refresh_tick && !pause) 
    begin
     counter <= tempC%(4*MAX_Y);
     if((counter !=44)&& 
     (tempC%(4*MAX_Y) == 42 || tempC%(4*MAX_Y) == 44)) 
           finish <= finish + 1;
    end
else
    begin // this part could have been in else if.
    //it is here because gate level path was too long 
    if(enter_key && finish<=0) //turbo, road moves 2X the speed
     tempC <= (counter + 4*MAX_Y - 3);
    else if(enter_key && finish>0)
     tempC <= (counter + 4*MAX_Y - 4);
    else if(finish<=0)
     tempC <= (counter + 4*MAX_Y - 1);
    else if(finish>0)
     tempC <= (counter + 4*MAX_Y - 2);
    end

    
//making this a reg so that synthesiser inferes ram
road_rom_addr <= (pixel_y + counter)%(2*MAX_Y);


//indexing scheme: I use the original 2 frames 
//for frame 3 and 4, by fliping 1, 2 from left to right
//for a data that is power of 2, fliping LR is simple
//just invert the bit index
if(((pixel_y + counter)%(4*MAX_Y))>(2*MAX_Y))
   begin
   road_rom_col <= ~(pixel_x[8:0]-road_x_l);
   end
else
   begin
   road_rom_col <= (pixel_x[8:0]-road_x_l);
   end
  
end


always@*
begin
//wait for 8 frames, before enabling finish line, 
  //show the finish line
  if(road_rom_addr == 0 && (finish==2))
      begin
        road_rgb = 12'hf00; // grey
        finish_line =1'b1;  // finish line shown
      end
  else
      begin
       road_rgb = 12'h555; //grey
       finish_line = 1'b0; //finish line not shown
      end

end





always @*
begin
  if (road_rom_addr >= 10'd0 && road_rom_addr <= 10'd100)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd101 && road_rom_addr <= 10'd150)
    road_rom_data = {76'b0, {120{1'b1}},120'b0,{120{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd151 && road_rom_addr <= 10'd250)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd251 && road_rom_addr <= 10'd300)
    road_rom_data = {296'b0,{140{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd301 && road_rom_addr <= 10'd400)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd401 && road_rom_addr <= 10'd450)
    road_rom_data = {76'b0,{215{1'b1}},95'b0,{50{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd451 && road_rom_addr <= 10'd550)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd551 && road_rom_addr <= 10'd600)
    road_rom_data = {196'b0,{120{1'b1}}, 196'b0};
  else if (road_rom_addr >= 10'd601 && road_rom_addr <= 10'd700)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd701 && road_rom_addr <= 10'd750)
    road_rom_data = {156'b0,{80{1'b1}},80'b0,{80{1'b1}}, 156'b0};
  else if (road_rom_addr >= 10'd751 && road_rom_addr <= 10'd850)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};
  else if (road_rom_addr >= 10'd851 && road_rom_addr <= 10'd900)
    road_rom_data = {216'b0,{80{1'b1}}, 216'b0};
  else if (road_rom_addr >= 10'd901 && road_rom_addr <= 10'd959)
    road_rom_data = {76'b0, {360{1'b1}}, 76'b0};


  else
    road_rom_data = 512'b0; // Or any default value you prefer
end

endmodule


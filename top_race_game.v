`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// 
//////////////////////////////////////////////////////////////////////////////////


module top_race_game(
input wire clk, reset, ps2d, ps2c, 
output wire hsync, vsync,
output wire [11:0] rgb_out
);

//variables
wire left_key, right_key, enter_key, key_relese, game_reset;
wire video_on, p_tick, road_on, finish_line, car_on, 
start_en, crash_en, finish_en;
wire [9:0] pixel_x, pixel_y;

//intantiate models
//keyboard
keyboard inkey(clk, reset,ps2d, ps2c,  left_key, right_key, enter_key, key_relese);

                
           
//graphics
graphics race_graph(clk, game_reset, pause, left_key,
                right_key, enter_key, video_on, start_en,crash_en,
                finish_en, pixel_x, pixel_y, road_on, finish_line,
                car_on,rgb_out);

//game_state
game_state game_states(clk, reset, video_on, road_on, finish_line,
         car_on, enter_key, key_relese,
           start_en,crash_en,finish_en, pause, game_reset);

//vga_sync
vga_sync vga(clk, reset, hsync, vsync, video_on,
             p_tick, pixel_x, pixel_y);
             



endmodule

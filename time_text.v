//module time_text(
//    input wire clk, reset, pause,
//    input wire refresh_tick,
//    input wire [9:0] pix_x, pix_y,
//    output wire time_on,
//    output wire best_time_on,
//    output wire [2:0] bit_addr,
//    output wire [10:0] rom_addr);
    
//    // Variables 
//    wire [3:0] row_addr;
//    reg [6:0] char_addr;
//    reg [23:0] time_tick;
//    reg [9:0] raceTime, bestTime;
//    reg [3:0] dig_10th, dig_1s, dig_10s;
//    reg [3:0] best_dig_10th, best_dig_1s, best_dig_10s;
//    reg best_time_flag;

//    // Output signals
    

//    assign time_on = (pix_y[9:5] == 0) && (pix_x[9:4] < 9);
//    assign row_addr = pix_y[4:1];
//    assign bit_addr = pix_x[3:1];
//    assign rom_addr = {char_addr, row_addr};
//    assign best_time_on = (pix_y[9:5] == 1) && (pix_x[9:4] < 9);

//    // Measure time in milliseconds
//    always @(posedge clk) begin
//        time_tick <= time_tick + 1;
//        if (reset) begin
//            raceTime <= 0;
//            bestTime <= 0;
//        end
//        else if (pause) begin
//            raceTime <= raceTime;
//            bestTime <= bestTime;
//        end
//        else if (time_tick == 10000000) begin // 0.1 second
//            time_tick <= 0;
//            raceTime <= raceTime + 1;
//            // Update best time if necessary
//            if (raceTime < bestTime || bestTime == 0) begin
//                bestTime <= raceTime;
//                best_dig_10th <= dig_10th;
//                best_dig_1s <= dig_1s;
//                best_dig_10s <= dig_10s;
//            end
//        end

//        // Calculate decimal digits
//        if (refresh_tick) begin
//            dig_10th <= raceTime % 10;
//            dig_1s <= (raceTime % 100) / 10;
//            dig_10s <= (raceTime % 1000) / 100;
//        end
//    end

//    always @* begin
//        case (pix_x[7:4])
//            4'h0: char_addr = 7'h54; // T
//            4'h1: char_addr = 7'h69; // i
//            4'h2: char_addr = 7'h6d; // m
//            4'h3: char_addr = 7'h65; // e
//            4'h4: char_addr = 7'h3a; // :
//            4'h5: char_addr = {3'b011, dig_10s}; // d i g i t 10
//            4'h6: char_addr = {3'b011, dig_1s}; // d i g i t 1
//            4'h7: char_addr = 7'h2e; // .
//            4'h8: char_addr = {3'b011, dig_10th}; // d i g i t 10th
//            default: char_addr = 7'h00; // 
//        endcase
//    end

//    always @* begin
//        case (pix_x[7:4])
//            4'h0: char_addr = 7'h54; // T
//            4'h1: char_addr = 7'h69; // i
//            4'h2: char_addr = 7'h6d; // m
//            4'h3: char_addr = 7'h65; // e
//            4'h4: char_addr = 7'h3a; // :
//            4'h5: char_addr = {3'b011, dig_10s}; // d i g i t 10
//            4'h6: char_addr = {3'b011, dig_1s}; // d i g i t 1
//            4'h7: char_addr = 7'h2e; // .
//            4'h8: char_addr = {3'b011, dig_10th}; // d i g i t 10th
//            default: char_addr = 7'h00; // 
//        endcase
//    end

//    always @* begin
//        case (pix_x[7:4])
//            4'h0: char_addr = 7'h54; // T
//            4'h1: char_addr = 7'h69; // i
//            4'h2: char_addr = 7'h6d; // m
//            4'h3: char_addr = 7'h65; // e
//            4'h4: char_addr = 7'h3a; // :
//            4'h5: char_addr = {3'b011, dig_10s}; // d i g i t 10
//            4'h6: char_addr = {3'b011, dig_1s}; // d i g i t 1
//            4'h7: char_addr = 7'h2e; // .
//            4'h8: char_addr = {3'b011, dig_10th}; // d i g i t 10th
//            default: char_addr = 7'h00; // 
//        endcase
//    end
//endmodule
//above code was running previously

//module text(
//    input wire clk, reset, pause,
//    input wire refresh_tick,
//    input wire start_en, crash_en, finish_en,
//    input wire [9:0] pix_x, pix_y,
//    output wire text_on,
//    output reg [11:0] text_rgb);

//    // Signal declaration
//    wire [7:0] font_word;
//    wire font_bit, time_on, start_on, crash_on, finish_on, best_time_on;
//    wire [10:0] time_rom_addr, start_rom_addr, crash_rom_addr, finish_rom_addr;
//    wire [2:0] time_bit_addr, start_bit_addr, crash_bit_addr, finish_bit_addr;
//    reg [10:0] rom_addr;
//    reg [2:0] bit_addr;
//    reg [9:0] raceTime, bestTime; // Store race time and best time
//    reg [3:0] dig_10th, dig_1s, dig_10s;
//    reg [3:0] best_dig_10th, best_dig_1s, best_dig_10s;
//    reg best_time_flag;

//    // Output signals
//    assign font_bit = font_word[~bit_addr];
//    assign text_on = time_on | (start_on & font_bit) | (crash_on & font_bit) | (finish_on & font_bit) | best_time_on;

//    // Instantiate font ROM
//    font_rom font_unit (
//        .clk(clk),
//        .addr(rom_addr),
//        .data(font_word)
//    );

//    // Instantiate time_text module with best_time_on signal
//    time_text mytime (
//        .clk(clk),
//        .reset(reset),
//        .pause(pause),
//        .refresh_tick(refresh_tick),
//        .pix_x(pix_x),
//        .pix_y(pix_y),
//        .time_on(time_on),
//        .best_time_on(best_time_on),
//        .bit_addr(time_bit_addr),
//        .rom_addr(time_rom_addr)
//    );

//    // Instantiate start module
//    start mystart (
//        .clk(clk),
//        .start_en(start_en),
//        .pix_x(pix_x),
//        .pix_y(pix_y),
//        .start_on(start_on),
//        .start_bit_addr(start_bit_addr),
//        .start_rom_addr(start_rom_addr)
//    );

//    // Instantiate finish module
//    finish myfinish (
//        .clk(clk),
//        .finish_en(finish_en),
//        .pix_x(pix_x),
//        .pix_y(pix_y),
//        .finish_on(finish_on),
//        .finish_bit_addr(finish_bit_addr),
//        .finish_rom_addr(finish_rom_addr)
//    );

//    // Instantiate game_over module
//    game_over crash (
//        .clk(clk),
//        .crash_en(crash_en),
//        .pix_x(pix_x),
//        .pix_y(pix_y),
//        .crash_on(crash_on),
//        .crash_bit_addr(crash_bit_addr),
//        .crash_rom_addr(crash_rom_addr)
//    );

//    // Update race time and best time
//    always @(posedge clk) begin
//        if (reset) begin
//            raceTime <= 0;
//            bestTime <= 0;
//        end
//        else if (!pause && refresh_tick) begin
//            raceTime <= raceTime + 1;
//            if (raceTime < bestTime || bestTime == 0) begin
//                bestTime <= raceTime;
//                best_dig_10th <= dig_10th;
//                best_dig_1s <= dig_1s;
//                best_dig_10s <= dig_10s;
//            end
//        end
//    end

//    // Calculate decimal digits
//    always @(posedge clk) begin
//        if (refresh_tick) begin
//            dig_10th <= raceTime % 10;
//            dig_1s <= (raceTime % 100) / 10;
//            dig_10s <= (raceTime % 1000) / 100;
//        end
//    end

//    // Determine text_rgb based on conditions
//    always @* begin
//        if (time_on) begin
//            bit_addr <= time_bit_addr;
//            rom_addr <= time_rom_addr;
//            text_rgb <= 12'h110; // Background yellow
//            if (font_bit) text_rgb <= 12'h001; // Font color
//        end
//        else if (start_on) begin
//            bit_addr <= start_bit_addr;
//            rom_addr <= start_rom_addr;
//            text_rgb <= 12'h501; // Font color
//        end  
//        else if (crash_on) begin
//            bit_addr <= crash_bit_addr;
//            rom_addr <= crash_rom_addr;
//            text_rgb <= 12'h501; // Font color
//        end
//        else if (finish_on) begin
//            bit_addr <= finish_bit_addr;
//            rom_addr <= finish_rom_addr;
//            text_rgb <= 12'h501; // Font color
//        end
//    end
//endmodule


`timescale 1ns / 1ps

module time_text(
input wire clk, reset, pause,
input wire refresh_tick,
input wire [9:0] pix_x, pix_y,
output wire time_on,
output wire [2:0] bit_addr,
output wire [10:0] rom_addr);
    
//variables 
wire [3:0] row_addr;    
reg [6:0] char_addr;
//reg [6:0] char_addr2;
reg [23:0] time_tick;
reg [9:0] raceTime;
reg [3:0] dig_10th, dig_1s, dig_10s;

assign time_on = (pix_y [9: 5] ==0) && (pix_x [9: 4] <9) ;
assign row_addr = pix_y [4:1];
assign bit_addr = pix_x [3:1];
assign rom_addr = {char_addr, row_addr};
 
//measure time in miliseonds
always@(posedge clk)
begin
time_tick <= time_tick + 1;
if(reset)
    raceTime<=0;
else if(pause)
    raceTime <=raceTime;
else if(time_tick==10000000) //0.1 second
begin
    time_tick<=0;
    raceTime <= raceTime + 1;
end

//calculate decimal digits
if(refresh_tick)
    begin
    dig_10th <= raceTime%10;
    dig_1s <= (raceTime%100)/10;
    dig_10s <= (raceTime%1000)/100;
    end
end 


always @*
case (pix_x [7:4])
4'h0: char_addr = 7'h54; // T
4'h1: char_addr = 7'h69; // i
4'h2: char_addr = 7'h6d; // m
4'h3: char_addr = 7'h65; // e
4'h4: char_addr = 7'h3a; // :
4'h5: char_addr = {3'b011, dig_10s}; // d i g i t 10
4'h6: char_addr = {3'b011, dig_1s}; // d i g i t 1
4'h7: char_addr = 7'h2e; // .
4'h8: char_addr = {3'b011, dig_10th}; // d i g i t 10th
default: char_addr = 7'h00; // 
endcase


endmodule
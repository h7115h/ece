`timescale 1ns / 1ps
module traffic_tb;

reg clk, rst, cd1, cd2, clk10,clk100,clk200;
wire s_red, s_yellow, s_green, s_left, n_red, n_yellow, n_green, n_left, w_red, w_yellow, w_green, w_left, e_red, e_yellow, e_green, e_left, sw_red, sw_green, nw_red, nw_green, ww_red, ww_green, ew_red, ew_green;
reg [3:0] time_hr1;
reg [1:0] time_hr2;
wire [2:0] state;
integer cnt;

traffic uut (
  .clk(clk), .clk10(clk10), .clk100(clk100), .clk200(clk200), .rst(rst),
  .s_red(s_red), .s_yellow(s_yellow), .s_green(s_green), .s_left(s_left),
  .n_red(n_red), .n_yellow(n_yellow), .n_green(n_green), .n_left(n_left),
  .w_red(w_red), .w_yellow(w_yellow), .w_green(w_green), .w_left(w_left),
  .e_red(e_red), .e_yellow(e_yellow), .e_green(e_green), .e_left(e_left),
  .sw_red(sw_red), .sw_green(sw_green),
  .nw_red(nw_red), .nw_green(nw_green),
  .ww_red(ww_red), .ww_green(ww_green),
  .ew_red(ew_red), .ew_green(ew_green));

initial begin
    clk = 0;  
    rst = 0;
    clk10=0;
    clk100=0;
    clk200=0;
    time_hr1 = 4'b0011;
    time_hr2 = 2'b01;
    #10 rst = 1; 
    #100000 clk10=1;
    #100000 clk10=0; clk100=1;
    forever #5 clk = ~clk;
end

endmodule


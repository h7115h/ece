`timescale 1ns / 1ps
module final_tb();

reg extra, mode, emergency, clk, rst, cd1, cd2, clk10, clk100, clk200;
wire s_red, s_yellow, s_green, s_left, n_red, n_yellow, n_green, n_left, w_red, w_yellow, w_green, w_left, e_red, e_yellow, e_green, e_left, sw_red, sw_green, nw_red, nw_green, ww_red, ww_green, ew_red, ew_green;
wire [2:0] state, prev_state;

reg [7:0] lcd_state;
reg [7:0] night [4:0];
reg [3:0] time_sec1, time_sec2, time_min1, time_min2, time_hr1;
reg [1:0] time_hr2;
reg state_c, start;
reg flash, yellow, green, cd1, cd2;
wire extra_t;
integer cnt, CLK_SEC, CNT_c, CNT_EXTRA, CNT_MODE, CNT_EM;

final uut1(clk, rst, clk10, clk100, clk200, lcd_rs, lcd_rw, lcd_data, lcd_e, extra, mode, emergency,
s_red, s_yellow, s_green, s_left,
n_red, n_yellow, n_green, n_left,
w_red, w_yellow, w_green, w_left,
e_red, e_yellow, e_green, e_left,
sw_red, sw_green, nw_red, nw_green,
ww_red, ww_green, ew_red, ew_green);

initial begin
    clk=0;
    rst=0;
    clk10=0;
    clk100=0;
    clk200=0;
    extra=0;
    mode=0;
end

initial begin
    #10 rst=1;
    #1200000 emergency=1;
    #180000 emergency=0;
end

always #5 clk = ~clk;

endmodule

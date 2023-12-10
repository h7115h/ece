`timescale 1ns / 1ps
module CLOCK_tb;

  reg rst, clk, clk10, clk100, clk200;
  reg mode, extra;

  wire lcd_e;
  wire [7:0] lcd_data;
  wire lcd_rs, lcd_rw;

  CLOCK uut (
    .clk(clk), .rst(rst),
    .mode(mode),
    .extra(extra), .clk10(clk10), .clk100(clk100), .clk200(clk200), 
    .lcd_e(lcd_e),
    .lcd_data(lcd_data),
    .lcd_rs(lcd_rs),
    .lcd_rw(lcd_rw)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst=0;
    mode = 0;
    extra = 0;
    #10 rst=1;
    #10000000 clk10=1;
    end
    
endmodule

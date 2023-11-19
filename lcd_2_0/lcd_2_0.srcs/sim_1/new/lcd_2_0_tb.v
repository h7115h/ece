`timescale 1ms / 1ms

module lcd_2_0_tb;

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

lcd_2_0 uut (.rst(rst),.clk(clk),.LCD_E(LCD_E), .LCD_RS(LCD_RS),.LCD_RW(LCD_RW), .LCD_DATA(LCD_DATA), .LED_out(LED_out),.number_btn(number_btn),
    .control_btn(control_btn));

initial begin
    rst = 0;
    clk = 0;
    number_btn = 10'b0;
    control_btn = 2'b00;

    #0.001 rst = 1;
    #650 number_btn = 10'b0100_0000_00;
    #200 control_btn = 2'b01;
    #650 number_btn = 10'b0000_1000_00;
    #200 control_btn = 2'b10;
end

always #1 clk = ~clk;

endmodule


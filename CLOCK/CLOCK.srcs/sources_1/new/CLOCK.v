module CLOCK(clk, rst, clk10, clk100, clk200, lcd_rs, lcd_rw, lcd_data, lcd_e, extra, mode);
input mode, extra, rst, clk, clk10, clk100, clk200;
output lcd_e;
output reg [7:0] lcd_data;
output reg lcd_rs, lcd_rw;
reg [7:0] night [4:0];
reg [3:0] time_sec1, time_sec2, time_min1, time_min2, time_hr1;
reg [1:0] time_hr2;
reg state_c, start;
wire extra_t;
integer CLK_SEC, CNT_c, CNT_EXTRA, CNT_MODE;

initial begin
	time_hr2 = 2'b00;
	time_hr1 = 4'h0;
	time_min2 = 4'h0;
	time_min1 = 4'h0;
	time_sec2 = 4'h0;
	time_sec1 = 4'h0;
	state_c = 1'b0;
	start = 1'b1;
    CLK_SEC = 0;
    CNT_EXTRA =0; CNT_MODE=0;
end

oneshot_universal #(.WIDTH(1)) O1(clk, rst, extra, extra_t);

always@(posedge clk or negedge rst) begin
	if(!rst) begin 
	   CNT_EXTRA =0; 
	   CNT_MODE=0;
	end
	else begin
	   if(extra) CNT_EXTRA = CNT_EXTRA +1;
	   else if(mode) CNT_MODE = CNT_MODE +1;
       if(!extra) CNT_EXTRA = 0;
       if(!mode) CNT_MODE = 0;
    end
end

always@(posedge clk or negedge rst) begin
    if(!rst) begin
        CLK_SEC =0;
        time_sec1 = 0;
        time_sec2 = 0;
        time_min1 = 0;
        time_min2 = 0;
        time_hr1 = 0;
        time_hr2 = 0;
    end
    else begin
        CLK_SEC = CLK_SEC +1;
        if (mode == 1) begin //눌러서 시간 수정모드
	       state_c = 1'b1;
	       CLK_SEC=0;
	    end
        else if(state_c == 1'b0 || mode == 0) begin
            state_c = 1'b0;
            if(clk10) begin
                if(CLK_SEC ==100) begin
	               time_sec1 = time_sec1 +1;
	               CLK_SEC =0;
	           end
	       end
	       else if(clk100) begin 
	           if(CLK_SEC == 10) begin
	               time_sec1 = time_sec1 +1;
	               CLK_SEC =0;
	           end
	       end
	       else if(clk200) begin
	           if(CLK_SEC == 5) begin
	               time_sec1 = time_sec1 +1;
	               CLK_SEC =0;
	           end
	       end
	       else begin
	           if(CLK_SEC ==1000) begin
	               time_sec1 = time_sec1 +1;
	               CLK_SEC =0;
	           end 
	       end
	    end
        if(time_sec1 == 4'hA) begin
	       time_sec1 = 4'h0;
	       time_sec2 = time_sec2 +1;
        end
        if(time_sec2 == 4'h6) begin
	       time_sec2 = 4'h0;
	       time_min1 = time_min1 +1;
        end
        if(time_min1 == 4'hA) begin
	       time_min1 = 4'h0;
	       time_min2 = time_min2 +1;
        end
        if(time_min2 == 4'h6) begin
	       time_min2 = 4'h0;
	       time_hr1 = time_hr1 +1;
        end
        if(time_hr1 == 4'hA) begin
	       time_hr1 = 4'h0;
	       time_hr2 = time_hr2 +1;
        end
        else if(state_c == 1'b1) begin
	       if(CNT_EXTRA == 1) begin
		      time_hr1 = time_hr1 +1;
	       end
	       if(time_hr1 == 4'hA) begin
		      time_hr1 = 4'b0;
		      time_hr2 = time_hr2 +1;
	       end
        end
        if(time_hr2 == 2'b10 && time_hr1 == 4'h4) begin
	       time_hr1 = 4'h0;
	       time_hr2 = 2'b00;
        end
        if(time_hr2 == 2'b11) time_hr2 = 2'b00;
        if ((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin
            night[4] <= 8'b0010_0000;
            night[3] <= 8'b0110_0100; //d
            night[2] <= 8'b0110_0001; //a
            night[1] <= 8'b0111_1001; //y
            night[0] <= 8'b0010_0000;
        end
        else begin
            night[4] <= 8'b0110_1110;
            night[3] <= 8'b0110_1001;
            night[2] <= 8'b0110_0111;
            night[1] <= 8'b0110_1000;
            night[0] <= 8'b0111_0100;
        end
    end
end

always@(posedge clk or negedge rst) begin
	if(!rst) begin
	   CNT_c = 0;
	   {lcd_rs,lcd_rw,lcd_data} = 10'b00_0000_0001;//clear display
	   start = 1'b1;
	end
	else begin
	   if(start) begin
		  CNT_c= CNT_c+1;
		  case(CNT_c)
			 1:{lcd_rs,lcd_rw,lcd_data} = 10'b00_0011_1000; //function set
			 2:{lcd_rs,lcd_rw,lcd_data} = 10'b00_0000_1100; //display
			 3:{lcd_rs,lcd_rw,lcd_data} = 10'b00_0000_0110; //entry mode set
			 4:{lcd_rs,lcd_rw,lcd_data} = 10'b00_1000_0000; //line1
			 5: begin
			     start = 1'b0; CNT_c=0;
			     end
			 default : CNT_c =0;
		  endcase
	    end
        else begin
            if(state_c ==1'b0) begin
                CNT_c = CNT_c+1;
                case(CNT_c)
				    1:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000;
				    2:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0101_0100; //T
				    3:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_1001; //i
				    4:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_1101; //m
				    5:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_0101; //e
				    6:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //여백
				    7:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    8:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //여백
				    9:{lcd_rs,lcd_rw,lcd_data} = {8'b10_0011_00, time_hr2}; // h2
				    10:{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_hr1}; //h1
				    11:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    12:{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_min2}; //m2
				    13:{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_min1}; //m1
				    14:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    15:{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_sec2}; //s2
				    16:{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_sec1}; //s1
				    17:{lcd_rs,lcd_rw,lcd_data} = 10'b00_1100_0000;
				    18:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0101_0011; //S
				    19:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0111_0100; //t
				    20:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_0001; //a
				    21:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0111_0100; //t
				    22:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_0101; //e
				    23:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //여백
				    24:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    25:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //여백
				    26:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //state(ABCDEFGH)
				    27:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_1000; //(
				    28:{lcd_rs,lcd_rw,lcd_data} = {2'b10, night[4]}; //n
				    29:{lcd_rs,lcd_rw,lcd_data} = {2'b10, night[3]}; //i d
				    30:{lcd_rs,lcd_rw,lcd_data} = {2'b10, night[2]}; //g a
				    31:{lcd_rs,lcd_rw,lcd_data} = {2'b10, night[1]}; //h y
				    32:{lcd_rs,lcd_rw,lcd_data} = {2'b10, night[0]}; //t
				    33:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_1001; //)
				    34:{lcd_rs,lcd_rw,lcd_data} = 10'b00_0000_0010;
				    35:CNT_c=0;
				    default: CNT_c=0;
			    endcase
		    end
            else if(state_c == 1'b1) begin // mode=1 
                if(CNT_MODE == 1) begin
                    {lcd_rs,lcd_rw,lcd_data} = 10'b00_0000_1111;//cursor flash on
			        CNT_c = 35;
		        end
		        else begin
			         if(CNT_EXTRA==2) 	{lcd_rs,lcd_rw,lcd_data} = {6'b10_0011, time_hr1};
			         else if (CNT_EXTRA==3) {lcd_rs,lcd_rw,lcd_data} = 10'b00_1000_1000;
			         else if (CNT_EXTRA==4) {lcd_rs,lcd_rw,lcd_data} = {8'b10_0011_00, time_hr2};
			         else {lcd_rs,lcd_rw,lcd_data} = 10'b00_1000_1001;
		        end
	       end
        end
    end
end

assign lcd_e = clk;
endmodule

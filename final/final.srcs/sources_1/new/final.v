module final(clk, rst, clk10, clk100, clk200, lcd_rs, lcd_rw, lcd_data, lcd_e, extra, mode, emergency,
s_red, s_yellow, s_green, s_left,
n_red, n_yellow, n_green, n_left,
w_red, w_yellow, w_green, w_left,
e_red, e_yellow, e_green, e_left,
sw_red, sw_green, nw_red, nw_green,
ww_red, ww_green, ew_red, ew_green);

input mode, extra, emergency, rst, clk, clk10, clk100, clk200;
output lcd_e;
output reg [7:0] lcd_data;
output reg lcd_rs, lcd_rw;
output reg s_red, s_yellow, s_green, s_left,
n_red, n_yellow, n_green, n_left,
w_red, w_yellow, w_green, w_left,
e_red, e_yellow, e_green, e_left,
sw_red, sw_green, nw_red, nw_green,
ww_red, ww_green, ew_red, ew_green;

reg [7:0] lcd_state;
reg [3:0] state, prev_state;
reg [7:0] night [4:0];
reg [3:0] time_sec1, time_sec2, time_min1, time_min2, time_hr1;
reg [1:0] time_hr2;
reg state_c, start;
reg flash, yellow, green, cd1, cd2;
wire extra_t, emergency_t;
integer cnt, CLK_SEC, CNT_c, CNT_EXTRA, CNT_MODE, CNT_EM;

parameter A = 4'b0000; //8'b0100_0001;
parameter B = 4'b0001; //8'b0100_0010;
parameter C = 4'b0010; //8'b0100_0011;
parameter D = 4'b0011; //8'b0100_0100; 
parameter E = 4'b0100; //8'b0100_0101; 
parameter F = 4'b0101; //8'b0100_0110;
parameter G = 4'b0110; //8'b0100_0111;
parameter H = 4'b0111; //8'b0100_1000;
parameter AA = 4'b1000;

oneshot_universal #(.WIDTH(2)) O1(clk, rst, {extra, emergency}, {extra_t, emergency_t});

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
        state_c = 0;
    end
    else begin
        if (mode == 1) begin 
	       state_c = 1'b1;
	       CLK_SEC=0;
	    end
        else if(state_c == 1'b0 || mode == 0) begin
            state_c = 1'b0;
            if(clk10) begin
                if (CLK_SEC >= 100) begin
                    time_sec1 = time_sec1 + 1;
                    CLK_SEC = 0;
                end else begin
                    CLK_SEC = CLK_SEC + 1;
                end               
	        end
	        else if(clk100) begin 
	            if(CLK_SEC >= 10) begin
	                time_sec1 = time_sec1 +1;
	                CLK_SEC =0;
	            end else begin
                    CLK_SEC = CLK_SEC + 1;
                end
	        end
	        else if(clk200) begin
	            if(CLK_SEC >= 5) begin
	                time_sec1 = time_sec1 +1;
	                CLK_SEC =0;
	            end else begin
                    CLK_SEC = CLK_SEC + 1;
                end
	        end
	        else begin
	            if(CLK_SEC >= 1000) begin
	                time_sec1 = time_sec1 +1;
	                CLK_SEC =0;
	            end else begin
                    CLK_SEC = CLK_SEC + 1;
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
                if(state == 4'b0000) lcd_state = 8'b0100_0001;
                else if(state == 4'b0001) lcd_state = 8'b0100_0010;
                else if(state == 4'b0010) lcd_state = 8'b0100_0011;
                else if(state == 4'b0011) lcd_state = 8'b0100_0100;
                else if(state == 4'b0100) lcd_state = 8'b0100_0101;
                else if(state == 4'b0101) lcd_state = 8'b0100_0110;
                else if(state == 4'b0110) lcd_state = 8'b0100_0111;
                else if(state == 4'b0111) lcd_state = 8'b0100_1000;
                else if(state == 4'b1000) lcd_state = 8'b0100_0001;
                case(CNT_c)
				    1:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000;
				    2:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0101_0100; //T
				    3:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_1001; //i
				    4:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_1101; //m
				    5:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0110_0101; //e
				    6:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //space
				    7:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    8:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //space
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
				    23:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //space
				    24:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0011_1010; //:
				    25:{lcd_rs,lcd_rw,lcd_data} = 10'b10_0010_0000; //space
				    26:{lcd_rs,lcd_rw,lcd_data} = {2'b10, lcd_state}; //state(ABCDEFGH)
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

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        cnt <= 0;
        flash <= 0;
        if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) 
            state <= A;
        else state <= B; 
    end 
    else begin
        if(mode) cnt=0;
        else begin
        if(clk10) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin
                if (cnt >= 500) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                A, D, E, F, G: begin
                    if (cnt < 250) begin  
                        flash <= 1;
                        yellow <= 0;
                        green <= 1;
                    end else if (cnt < 300) begin  
                        flash <= 0;
                    end else if (cnt < 350) begin 
                        flash <= 1;
                    end else if (cnt < 400) begin  
                        flash <= 0;
                    end else if (cnt < 450) begin  
                        flash <= 1;
                        yellow <= 1;
                        green <= 0;
                    end
                end
                endcase
            end
            else begin
                if (cnt >= 1000) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 500) begin  
                            flash <= 1;
                            yellow <= 0;
                            green <= 1;
                        end else if (cnt < 600) begin 
                            flash <= 0;
  	                    end else if (cnt < 700) begin  
 	                        flash <= 1;
  	                    end else if (cnt < 800) begin 
  	                        flash <= 0;
   	                    end else if (cnt < 900) begin 
   	                        flash <= 1;
   	                        yellow <= 1;
   	                        green <= 0;
   	                    end
                    end
                endcase
            end
        end
        else if(clk100) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin 
                if (cnt >= 50) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                A, D, E, F, G: begin
                    if (cnt < 25) begin  
                        flash <= 1;
                        yellow <= 0;
                        green <= 1;
                    end else if (cnt < 30) begin  
                        flash <= 0;
                    end else if (cnt < 35) begin  
                        flash <= 1;
                    end else if (cnt < 40) begin  
                        flash <= 0;
                    end else if (cnt < 45) begin  
                        flash <= 1;
                        yellow <= 1;
                        green <= 0;
                    end
                end
                endcase
            end
            else begin
                if (cnt >= 100) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 50) begin  
                            flash <= 1;
                            yellow <= 0;
                            green <= 1;
                        end else if (cnt < 60) begin 
                            flash <= 0;
  	                    end else if (cnt < 70) begin 
 	                        flash <= 1;
  	                    end else if (cnt < 80) begin  
  	                        flash <= 0;
   	                    end else if (cnt < 90) begin  
   	                        flash <= 1;
   	                        yellow <= 1;
   	                        green <= 0;
   	                    end
                    end
                endcase
            end
        end
        else if(clk200) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin 
                if (cnt >= 25) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                A, D, E, F, G: begin
                    if (cnt < 13) begin  
                        flash <= 1;
                        yellow <= 0;
                        green <= 1;
                    end else if (cnt < 15) begin 
                        flash <= 0;
                    end else if (cnt < 18) begin  
                        flash <= 1;
                    end else if (cnt < 21) begin  
                        flash <= 0;
                    end else if (cnt < 23) begin  
                        flash <= 1;
                        yellow <= 1;
                        green <= 0;
                    end
                end
                endcase
            end
            else begin
                if (cnt >= 50) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 25) begin 
                            flash <= 1;
                            yellow <= 0;
                            green <= 1;
                        end else if (cnt < 30) begin  
                            flash <= 0;
  	                    end else if (cnt < 35) begin  
 	                        flash <= 1;
  	                    end else if (cnt < 40) begin  
  	                        flash <= 0;
   	                    end else if (cnt < 45) begin  
   	                        flash <= 1;
   	                        yellow <= 1;
   	                        green <= 0;
   	                    end
                    end
                endcase
            end
        end
        else begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin 
                if (cnt >= 5000) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                case (state)
                A, D, E, F, G: begin
                    if (cnt < 2500) begin  
                        flash <= 1;
                        yellow <= 0;
                        green <= 1;
                    end else if (cnt < 3000) begin  
                        flash <= 0;
                    end else if (cnt < 3500) begin  
                        flash <= 1;
                    end else if (cnt < 4000) begin  
                        flash <= 0;
                    end else if (cnt < 4500) begin  
                        flash <= 1;
                        yellow <= 1;
                        green <= 0;
                    end
                end
                endcase
            end
            else begin
                if(emergency) begin
                    cnt <= cnt + 1;
                end
                else if (cnt >= 10000) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                    case (state)
                    A, B, C, E, H: begin
                        if (cnt < 5000) begin  
                            flash <= 1;
                            yellow <= 0;
                            green <= 1;
                        end else if (cnt < 6000) begin  
                            flash <= 0;
  	                    end else if (cnt < 7000) begin  
 	                        flash <= 1;
  	                    end else if (cnt < 8000) begin  
  	                        flash <= 0;
   	                    end else if (cnt < 9000) begin  
   	                        flash <= 1;
   	                        yellow <= 1;
   	                        green <= 0;
   	                    end
                    end
                    endcase
            end     
        end
        
        if (emergency) begin
            CNT_EM <= 1'b1;
            cnt <= 0;
            prev_state <= state;
        end else if (CNT_EM && (cnt == 1000)) begin    
            cnt <= cnt + 1;
            state <= AA; 
        end else if (CNT_EM && (cnt < 15999)) begin
            cnt <= cnt + 1;
        end else if (CNT_EM && (cnt == 15999)) begin
            CNT_EM <= 1'b0;
            cnt <= 0;
            state <= prev_state;
        end 
        else begin if(clk10) begin
            if (emergency) begin
                CNT_EM <= 1'b1;
                cnt <= 0;
                prev_state <= state;
            end else if (CNT_EM && (cnt == 100)) begin    
                cnt <= cnt + 1;
                state <= AA; 
            end else if (CNT_EM && (cnt < 1599)) begin
                cnt <= cnt + 1;
            end else if (CNT_EM && (cnt == 1599)) begin
                CNT_EM <= 1'b0;
                cnt <= 0;
                state <= prev_state;
            end 
            else if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 500) begin 
            case (state)
                A: state <= D;
                D: state <= F;
                F: state <= E;
                E: state <= cd1 ? A : G;
                G: state <= E;
                default: state <= A;
            endcase
        end
        else begin
            if (cnt == 1000) begin 
                case (state)
                    B: state <= A;
                    A: state <= cd2 ? E : C;
                    C: state <= A;
                    E: state <= H;
                    default: state <= B;
                endcase
            end
        end
        end
        else if(clk100) begin
            if (emergency) begin
                CNT_EM <= 1'b1;
                cnt <= 0;
                prev_state <= state;
            end else if (CNT_EM && (cnt == 10)) begin    
                cnt <= cnt + 1;
                state <= AA; 
            end else if (CNT_EM && (cnt < 159)) begin
                cnt <= cnt + 1;
            end else if (CNT_EM && (cnt == 159)) begin
                CNT_EM <= 1'b0;
                cnt <= 0;
                state <= prev_state;
            end 
            else if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 50) begin 
            case (state)
                A: state <= D;
                D: state <= F;
                F: state <= E;
                E: state <= cd1 ? A : G;
                G: state <= E;
                default: state <= A;
            endcase
        end
        else begin
            if (cnt == 100) begin 
                case (state)
                    B: state <= A;
                    A: state <= cd2 ? E : C;
                    C: state <= A;
                    E: state <= H;
                    default: state <= B;
                endcase
            end
        end
        end
        else if(clk200) begin
            if (emergency) begin
                CNT_EM <= 1'b1;
                cnt <= 0;
                prev_state <= state;
            end else if (CNT_EM && (cnt == 5)) begin    
                cnt <= cnt + 1;
                state <= AA; 
            end else if (CNT_EM && (cnt < 79)) begin
                cnt <= cnt + 1;
            end else if (CNT_EM && (cnt == 79)) begin
                CNT_EM <= 1'b0;
                cnt <= 0;
                state <= prev_state;
            end 
            else if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 25) begin 
            case (state)
                A: state <= D;
                D: state <= F;
                F: state <= E;
                E: state <= cd1 ? A : G;
                G: state <= E;
                default: state <= A;
            endcase
        end
        else begin
            if (cnt == 50) begin 
                case (state)
                    B: state <= A;
                    A: state <= cd2 ? E : C;
                    C: state <= A;
                    E: state <= H;
                    default: state <= B;
                endcase
            end
        end
        end
        else begin
            if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 5000) begin 
                case (state)
                    A: state <= D;
                    D: state <= F;
                    F: state <= E;
                    E: state <= cd1 ? A : G;
                    G: state <= E;
                    default: state <= A;
                endcase
            end
            else begin
                if (cnt == 10000) begin
                case (state)
                    B: state <= A;
                    A: state <= cd2 ? E : C;
                    C: state <= A;
                    E: state <= H;
                    default: state <= B;
                endcase
                end
            end
        end
    end
end
end
end

always @(posedge clk or negedge rst) begin
  if (!rst) begin
    {s_red, s_yellow, s_green, s_left,
    n_red, n_yellow, n_green, n_left,
    w_red, w_yellow, w_green, w_left,
    e_red, e_yellow, e_green, e_left,
    sw_red, sw_green,
    nw_red, nw_green,
    ww_red, ww_green,
    ew_red, ew_green, cd1, cd2} = 0;
  end
  else begin
    case(state)
    AA : begin
		s_red= 0; s_yellow= 0; s_left= 0;
    	n_red= 0; n_yellow= 0; n_left= 0;
    	w_yellow= 0; w_green= 0; w_left= 0;
    	e_yellow= 0; e_green= 0; e_left=0;
    	sw_green= 0; nw_green= 0; ww_red= 0; ew_red= 0;
		e_red=1; w_red=1; s_green=1;  n_green=1;
		ew_green=1; ww_green=1; sw_red=1; nw_red=1;
	end
	A : begin
		s_red= 0; s_yellow= 0; s_left= 0;
    	n_red= 0; n_yellow= 0; n_left= 0;
    	w_yellow= 0; w_green= 0; w_left= 0;
    	e_yellow= 0; e_green= 0; e_left=0;
    	sw_green= 0; nw_green= 0; ww_red= 0; ew_red= 0;
		e_red=1; w_red=1; s_green=green; s_yellow=yellow; n_green=green; n_yellow=yellow;
		ew_green=flash; ww_green=flash; sw_red=1; nw_red=1;
	end

	B : begin
		{s_yellow, s_green, s_left, n_red, n_yellow, w_yellow, w_green, 
		w_left, e_yellow, e_green, e_left, sw_green, nw_green, ww_green, ew_red} = 0;
		e_red=1; w_red=1; s_red=1; n_green=green; n_yellow=yellow; n_left=green;
		ew_green=flash; ww_red=1; sw_red=1; nw_red=1;
	end

	C : begin
		{s_red, s_yellow, n_yellow, n_green, n_left, w_yellow, w_green, w_left, 
		e_yellow, e_green, e_left, sw_green, nw_green, ww_red, ew_green} = 0;
		e_red=1; w_red=1; s_green=green; s_yellow=yellow; s_left=green; n_red=1;
		ew_red=1; ww_green=flash; sw_red=1; nw_red=1; cd2=1;
	end

	D : begin
		{s_red, s_yellow, s_green, n_red, n_yellow, n_green, w_yellow, w_green, 
	    w_left, e_yellow, e_green, e_left, sw_green, nw_green, ww_green, ew_green} = 0;
		e_red=1; w_red=1; s_left=1; n_left=1;
		ew_red=1; ww_red=1; sw_red=1; nw_red=1;
	end

	E : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_red, w_yellow, w_left,
   		 e_red, e_yellow, e_left, sw_red, nw_red, ww_green, ew_green} = 0;
		e_green=green; e_yellow=yellow; w_green=green; w_yellow=yellow; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_green=flash; nw_green=flash; cd2=0;
	end

	F : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_red, w_yellow, 
		e_yellow, e_green, e_left, sw_green, nw_red, ww_green, ew_green} = 0;
		e_red=1; w_green=green; w_yellow=yellow; w_left=green; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_red=1; nw_green=flash; cd1=0;
	end

	G : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_yellow, w_green, 
		w_left, e_red, e_yellow, sw_red, nw_green, ww_green, ew_green} = 0;
		e_green=green; e_yellow=yellow; e_left=1; w_red=1; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_green=flash; nw_red=1; cd1=1;
	end
	
	H : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_red, w_yellow, 
	    w_green, e_red, e_yellow, e_green, sw_green, nw_green, ww_green, ew_green} = 0;
		e_left=1; w_left=1; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_red=1; nw_red=1;
	end
    endcase
  end
end

assign lcd_e = clk;  
  
  
endmodule

module traffic(
input rst, clk, clk10, clk100, clk200,
output reg s_red, s_yellow, s_green, s_left,
n_red, n_yellow, n_green, n_left,
w_red, w_yellow, w_green, w_left,
e_red, e_yellow, e_green, e_left,
sw_red, sw_green,
nw_red, nw_green,
ww_red, ww_green,
ew_red, ew_green);

reg [2:0] state;
reg [3:0] time_hr1;
reg [1:0] time_hr2;
reg flash, cd1, cd2;
integer cnt;

parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;
parameter G = 3'b110;
parameter H = 3'b111;

initial begin
    time_hr1 = 4'b0011;
    time_hr2 = 2'b01;
    cd1=0;
    cd2=0;
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        cnt <= 0;
        flash <= 0;
        if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) // 낮
            state <= A;
        else state <= B; 
    end 
    else begin
        if(clk10) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin //낮
            cnt <= (cnt == 500) ? 0 : cnt+1;
            case (state)
                A, D, E, F, G: begin
                    if (cnt < 250) begin  // 2.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 300) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 350) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 400) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 450) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end
                end
            endcase
            end
            else begin//밤
            cnt <= (cnt == 1000) ? 0 : cnt+1;
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 500) begin  // 2.5초 동안 켜져 있는 상태
                            flash <= 1;
                        end else if (cnt < 600) begin  // 0.5초 동안 꺼져 있는 상태
                            flash <= 0;
  	                    end else if (cnt < 700) begin  // 0.5초 동안 켜져 있는 상태
 	                        flash <= 1;
  	                    end else if (cnt < 800) begin  // 0.5초 동안 꺼져 있는 상태
  	                        flash <= 0;
   	                    end else if (cnt < 900) begin  // 0.5초 동안 켜져 있는 상태
   	                        flash <= 1;
   	                    end
                    end
                endcase
            end
        end
        else if(clk100) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin //낮
            cnt <= (cnt == 50) ? 0 : cnt+1;
            case (state)
                A, D, E, F, G: begin
                    if (cnt < 25) begin  // 2.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 30) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 35) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 40) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 45) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end
                end
            endcase
            end
            else begin//밤
            cnt <= (cnt == 100) ? 0 : cnt+1;
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 50) begin  // 2.5초 동안 켜져 있는 상태
                            flash <= 1;
                        end else if (cnt < 60) begin  // 0.5초 동안 꺼져 있는 상태
                            flash <= 0;
  	                    end else if (cnt < 70) begin  // 0.5초 동안 켜져 있는 상태
 	                        flash <= 1;
  	                    end else if (cnt < 80) begin  // 0.5초 동안 꺼져 있는 상태
  	                        flash <= 0;
   	                    end else if (cnt < 90) begin  // 0.5초 동안 켜져 있는 상태
   	                        flash <= 1;
   	                    end
                    end
                endcase
            end
        end
        else if(clk200) begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin //낮
            cnt <= (cnt == 25) ? 0 : cnt+1;
            case (state)
                A, D, E, F, G: begin
                    if (cnt < 13) begin  // 2.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 15) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 18) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 21) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 23) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end
                end
            endcase
            end
            else begin//밤
            cnt <= (cnt == 50) ? 0 : cnt+1;
                case (state)
                    A, B, C, E, H: begin
                        if (cnt < 25) begin  // 2.5초 동안 켜져 있는 상태
                            flash <= 1;
                        end else if (cnt < 30) begin  // 0.5초 동안 꺼져 있는 상태
                            flash <= 0;
  	                    end else if (cnt < 35) begin  // 0.5초 동안 켜져 있는 상태
 	                        flash <= 1;
  	                    end else if (cnt < 40) begin  // 0.5초 동안 꺼져 있는 상태
  	                        flash <= 0;
   	                    end else if (cnt < 45) begin  // 0.5초 동안 켜져 있는 상태
   	                        flash <= 1;
   	                    end
                    end
                endcase
            end
        end
        else begin
            if((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) begin //낮
                cnt <= (cnt == 5000) ? 0 : cnt+1;
                case (state)
                A, D, E, F, G: begin
                    if (cnt < 2500) begin  // 2.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 3000) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 3500) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end else if (cnt < 4000) begin  // 0.5초 동안 꺼져 있는 상태
                        flash <= 0;
                    end else if (cnt < 4500) begin  // 0.5초 동안 켜져 있는 상태
                        flash <= 1;
                    end
                end
                endcase
            end
            else begin//밤
                cnt <= (cnt == 10000) ? 0 : cnt+1;
                    case (state)
                    A, B, C, E, H: begin
                        if (cnt < 5000) begin  // 2.5초 동안 켜져 있는 상태
                            flash <= 1;
                        end else if (cnt < 6000) begin  // 0.5초 동안 꺼져 있는 상태
                            flash <= 0;
  	                    end else if (cnt < 7000) begin  // 0.5초 동안 켜져 있는 상태
 	                        flash <= 1;
  	                    end else if (cnt < 8000) begin  // 0.5초 동안 꺼져 있는 상태
  	                        flash <= 0;
   	                    end else if (cnt < 9000) begin  // 0.5초 동안 켜져 있는 상태
   	                        flash <= 1;
   	                    end
                    end
                    endcase
            end     
        end
        
        
        if(clk10) begin
            if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 500) begin // 카운터가 5초에 해당하는 값을 갖으면 상태를 전환
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
            if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 50) begin // 카운터가 5초에 해당하는 값을 갖으면 상태를 전환
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
            if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 25) begin // 카운터가 5초에 해당하는 값을 갖으면 상태를 전환
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
            if (((time_hr2 == 2'b01) || (time_hr2 == 2'b10 && time_hr1 < 4'b0011) || (time_hr2 == 2'b00 && time_hr1 > 4'b0111)) && cnt == 5000) begin // 카운터가 5초에 해당하는 값을 갖으면 상태를 전환
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

always @(posedge clk or negedge rst) begin
  if (!rst) begin
    {s_red, s_yellow, s_green, s_left,
    n_red, n_yellow, n_green, n_left,
    w_red, w_yellow, w_green, w_left,
    e_red, e_yellow, e_green, e_left,
    sw_red, sw_green,
    nw_red, nw_green,
    ww_red, ww_green,
    ew_red, ew_green} = 0;
  end
  else begin
    case(state)
	A : begin
		s_red= 0; s_yellow= 0; s_left= 0;
    	n_red= 0; n_yellow= 0; n_left= 0;
    	w_yellow= 0; w_green= 0; w_left= 0;
    	e_yellow= 0; e_green= 0; e_left=0;
    	sw_green= 0; nw_green= 0; ww_red= 0; ew_red= 0;
		e_red=1; w_red=1; s_green=1; n_green=1;
		ew_green=flash; ww_green=flash; sw_red=1; nw_red=1;
	end

	B : begin
		{s_yellow, s_green, s_left, n_red, n_yellow, w_yellow, w_green, 
		w_left, e_yellow, e_green, e_left, sw_green, nw_green, ww_green, ew_red} = 0;
		e_red=1; w_red=1; s_red=1; n_green=1; n_left=1;
		ew_green=flash; ww_red=1; sw_red=1; nw_red=1;
	end

	C : begin
		{s_red, s_yellow, n_yellow, n_green, n_left, w_yellow, w_green, w_left, 
		e_yellow, e_green, e_left, sw_green, nw_green, ww_red, ew_green} = 0;
		e_red=1; w_red=1; s_green=1; s_left=1; n_red=1;
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
		e_green=1; w_green=1; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_green=flash; nw_green=flash; cd2=0;
	end

	F : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_red, w_yellow, 
		e_yellow, e_green, e_left, sw_green, nw_red, ww_green, ew_green} = 0;
		e_red=1; w_green=1; w_left=1; s_red=1; n_red=1;
		ew_red=1; ww_red=1; sw_red=1; nw_green=flash; cd1=0;
	end

	G : begin
		{s_yellow, s_green, s_left, n_yellow, n_green, n_left, w_yellow, w_green, 
		w_left, e_red, e_yellow, sw_red, nw_green, ww_green, ew_green} = 0;
		e_green=1; e_left=1; w_red=1; s_red=1; n_red=1;
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
endmodule

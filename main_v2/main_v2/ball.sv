//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

module ball (
    input         Clk,                // 50 MHz clock
    input         Reset,              // Active-high reset signal
    input         frame_clk,          // The clock indicating a new frame (~60Hz)
    input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	 input [7:0]   space_trigger,
	 input [1:0] game_state,
	 output [9:0] Ball_X_Pos,Ball_Y_Pos,
    output logic  is_ball,             // Whether current pixel belongs to ball or backgroundou't'de
	 output logic  is_bottom,
	 output logic [18:0]   b_addr,
	 output logic eat_coin
	 
);

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_Y_step = 10'd3;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd10;       // Ball size
    parameter [9:0] Jump_Height = 10'd5;     // Height of jump
	 parameter [9:0] ground = 10'd40;          // ground height

//    logic [9:0] Ball_X_Pos, Ball_Y_Pos;
    logic [9:0] Ball_Y_Pos_in, Ball_Y_Motion_in, Ball_Y_Motion;
    logic frame_clk_delayed, frame_clk_rising_edge;
    logic [9:0] jump_counter, jump_counter_in;  // Counts how long the jump has been sustained
	 logic [4:0] wing_counter, wing_counter_in;
	 
	 logic [18:0] dynamic_addr;
	 
    initial begin
         Ball_Y_Pos = Ball_Y_Center;
			Ball_Y_Motion = 0;
			jump_counter = 0;
			wing_counter =0;
			dynamic_addr = 136;
    end

	 
    // Rising edge detection of frame_clk
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

	 

    // Update ball position and motion
    always_ff @ (posedge Clk) begin
        if (Reset) begin
				Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_Y_Motion <= 0;
            jump_counter <= 0;
				wing_counter <=0;
				is_bottom <= 1'b0;
				dynamic_addr <= 136;
        end else begin
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;         
				jump_counter <= jump_counter_in;
				wing_counter <= wing_counter_in;
				Ball_X_Pos <= Ball_X_Center;
				case(wing_counter)
					0:dynamic_addr <= 136;
					4:dynamic_addr <= 409;
					5:dynamic_addr <= 682;
				endcase
				if(Ball_Y_Pos >= Ball_Y_Max-6-ground) begin
					is_bottom <= 1'b1;
				end else begin
					is_bottom <= 1'b0;
				end
				
				
        end
    end
	 
	
	always_comb begin
		 Ball_Y_Pos_in = Ball_Y_Pos; // Default to no movement
		 Ball_Y_Motion_in = Ball_Y_Motion; // Default to current motion
		 jump_counter_in = jump_counter;
		 wing_counter_in = wing_counter;
		 
		 if (frame_clk_rising_edge ) begin
		 case(game_state)
				2'b01:begin
					  if(wing_counter == 8) begin
							wing_counter_in =0;
					  end else begin
							wing_counter_in=wing_counter+1;
					  end
					  
					  if (space_trigger == 8'hff) begin 
							jump_counter_in = Jump_Height;
					  end
					  if (jump_counter > 0) begin
							jump_counter_in = jump_counter - 1;  
							Ball_Y_Motion_in = -10'd10;
					  end else begin;
							Ball_Y_Motion_in = Ball_Y_step;
					  end
					  Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				end
				
				2'b10:begin
						jump_counter_in =0 ;
						Ball_Y_Motion_in =0;
						Ball_Y_Pos_in = Ball_Y_Pos; 
				end 
				
				2'b00: begin
						 jump_counter_in =0 ;
						 Ball_Y_Pos_in = Ball_Y_Center;
						 Ball_Y_Motion_in = 0;
				end
			endcase
		 end
	end


    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Center;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
	 
	 parameter [9:0] height = 21;
    parameter [9:0] width = 13;
	 int hfheight,hfwidth,dx,dy,mid_addr;
	 
    
	 
 
//	 assign hfheight = (height-1)/2;    //0-20, 21-41, 42-62...
//	 assign hfwidth = (width-1)/2;
//	 assign dx = DrawX - 10'd320;
//	 assign dy = DrawY - Ball_Y_Pos;
	 assign mid_addr = 136; //220  hfheight(10)*width(12)+hfwidth(6)
	  
 
    always_comb begin
        if (DistX<=10 && DistX>= -10 &&  DistY<=6 && DistY>= -6) begin
            is_ball = 1'b1;
				b_addr = dynamic_addr+DistY*21+DistX; //0-440
			end

        else begin
            is_ball = 1'b0;
				b_addr = 19'b0; //0-440
			end

    end

endmodule

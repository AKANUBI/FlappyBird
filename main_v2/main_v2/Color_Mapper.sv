//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_ball,            // Whether current pixel belongs to ball 
								input             is_bg,
								input   Clk,
                       input logic [18:0]        b_addr,                                       //   or background (computed in ball.sv)
							  input logic [18:0]        bg_addr,
							  input logic [18:0]        p_addr, p_e_addr,
							  input logic [18:0]        s1_addr, s2_addr,
							  input logic [18:0]        c_addr,
							  input is_pipe, is_pipe_edge, is_grd_y, is_grd_g_d, is_grd_g_l,
							  input is_score1, is_score2,
							  input is_coin,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	  logic[23:0] RGBbird;
	  logic[23:0] RGBbg;
	  logic[23:0] RGBp, RGBp_e;
	  logic[23:0] RGBdigit1,RGBdigit2;
	  logic[23:0] RGBcoin;
	  logic [3:0] b_palt;
	  logic [3:0] bg_palt;
	  logic [3:0] p_palt, p_e_palt;
	  logic [3:0] digit1_palt, digit2_palt;
	  logic [3:0] coin_palt;
    

    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

	 
    birdram bird0(.read_address(b_addr),.Clk(Clk),.data_Out(b_palt));
	 background_ram bg(.read_address(bg_addr),.Clk(Clk),.data_Out(bg_palt));
	 pipe_line_ram pipe(.read_address(p_addr),.Clk(Clk),.data_Out(p_palt));
	 pipe_edge_ram p_e(.read_address(p_e_addr),.Clk(Clk),.data_Out(p_e_palt));
	 score_ram score_digit1(.read_address(s1_addr),.Clk(Clk),.data_Out(digit1_palt));
	 score_ram score_digit2(.read_address(s2_addr),.Clk(Clk),.data_Out(digit2_palt));
	 coin_ram coin(.read_address(c_addr),.Clk(Clk),.data_Out(coin_palt));
	 
    // Assign color based on is_ball signal
    always_comb
    begin
		 if (DrawX <= 160 || DrawX >= 480)
		  begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
		  end
		  else if(is_grd_y == 1'b1)  begin
				Red = 8'hdb;
            Green = 8'hd8;
            Blue = 8'h9d; 
				

		  end
		  else if(is_grd_g_l == 1'b1)  begin
		  
				Red = 8'h87;
            Green = 8'hbd;
            Blue = 8'h48; 
		  end
		  else if(is_grd_g_d == 1'b1)  begin
		  
				Red = 8'hae;
            Green = 8'he4;
            Blue = 8'h6d; 
		  end
		  else if(is_score1 == 1'b1)  begin
				if(digit1_palt!=0 ) begin
					Red = RGBdigit1[23:16];
					Green = RGBdigit1[15:8];
					Blue = RGBdigit1[7:0];
				end
				else if(is_pipe==1)begin
					Red = RGBp[23:16];
					Green = RGBp[15:8];
					Blue = RGBp[7:0];
				end 
				else if (is_pipe_edge == 1'b1)
				begin
					Red = RGBp_e[23:16];
					Green = RGBp_e[15:8];
					Blue = RGBp_e[7:0];
				end
				else if(is_ball ==1)begin
					if(b_palt != 0)begin
						Red = RGBbird[23:16];
						Green = RGBbird[15:8];
						Blue = RGBbird[7:0];
					end else begin
						Red = RGBbg[23:16];
						Green = RGBbg[15:8];
						Blue = RGBbg[7:0];
					end
				end else begin
					Red = RGBbg[23:16];
					Green = RGBbg[15:8];
					Blue = RGBbg[7:0];
				end
		  end
		  else if(is_score2 == 1'b1)  begin
				if(digit2_palt!=0 ) begin
					Red = RGBdigit2[23:16];
					Green = RGBdigit2[15:8];
					Blue = RGBdigit2[7:0];
				end
				else if(is_pipe==1)begin
					Red = RGBp[23:16];
					Green = RGBp[15:8];
					Blue = RGBp[7:0];
				end 
				else if (is_pipe_edge == 1'b1)
				begin
					Red = RGBp_e[23:16];
					Green = RGBp_e[15:8];
					Blue = RGBp_e[7:0];
				end				
				else if(is_ball ==1)begin
					if(b_palt != 0)begin
						Red = RGBbird[23:16];
						Green = RGBbird[15:8];
						Blue = RGBbird[7:0];
					end else begin
						Red = RGBbg[23:16];
						Green = RGBbg[15:8];
						Blue = RGBbg[7:0];
					end
				end else begin
					Red = RGBbg[23:16];
					Green = RGBbg[15:8];
					Blue = RGBbg[7:0];
				end
		  end
		  else if (is_pipe == 1'b1) 
			  begin
					// green pipe
					Red = RGBp[23:16];
					Green = RGBp[15:8];
					Blue = RGBp[7:0];
				end
		  else if (is_pipe_edge == 1'b1) 
			  begin
					Red = RGBp_e[23:16];
					Green = RGBp_e[15:8];
					Blue = RGBp_e[7:0];
		
			  end
		  else if(is_coin == 1)
				begin
					if(coin_palt!=0) begin
						Red = RGBcoin[23:16];
						Green = RGBcoin[15:8];
						Blue = RGBcoin[7:0];
					end
					else begin
						Red = RGBbg[23:16];
						Green = RGBbg[15:8];
						Blue = RGBbg[7:0];
					end

				end 
        else if (is_ball == 1'b1) 
        begin
         
            if (b_palt != 0)
                    begin
                        Red = RGBbird[23:16];
                        Green = RGBbird[15:8];
                        Blue = RGBbird[7:0];
                    end 
				else begin
								Red = RGBbg[23:16];
								Green = RGBbg[15:8];
								Blue = RGBbg[7:0];
				end
				
        end
		  
	 else if(is_bg == 1'b1 )
        begin
            Red = RGBbg[23:16];
				Green = RGBbg[15:8];
				Blue = RGBbg[7:0];
        end 
		  else begin
				Red = 8'h3f; 
				Green =8'h00;
				Blue = 8'h7f;
		  end
		  
		  
   
    end 
	 
	 //'0x00FF00','0xF6EEEE', '0x2A2828', '0xF4160B', '0xB48A0E', '0xF8D80E'
    always_comb begin
		case(b_palt) 
				4'h0:RGBbird = 24'h00FF00;
				4'h1:RGBbird = 24'hF6EEEE;
				4'h2:RGBbird = 24'h2A2828;
				4'h3:RGBbird = 24'hF4160B;
				4'h4:RGBbird = 24'hB48A0E;
				4'h5:RGBbird = 24'hF8D80E;
				default:RGBbird = 24'h3f007f;
				
		endcase
	end
	
	always_comb begin
		case(bg_palt) 
				4'd0:RGBbg= 24'h73BFE6;
				4'd1:RGBbg = 24'hF2FFFD;
				4'd2:RGBbg = 24'hB1DFD1;
				4'd3:RGBbg = 24'h7AB1CC;
				4'd4:RGBbg = 24'h8AC9D0;
				4'd5:RGBbg = 24'hB0D7CA;
				4'd6:RGBbg = 24'h7CA197;
				4'd7:RGBbg = 24'h4F7754;
				4'd8:RGBbg = 24'h40603A;
				4'd9:RGBbg = 24'h37583B;
				4'd10:RGBbg = 24'h4F714E;
				4'd11:RGBbg = 24'h658C76;
				4'd12:RGBbg = 24'hA7CCC0;
				default:RGBbg = 24'h73BFE6;
				
		endcase
	end
	
	always_comb begin
		case(p_palt) 
				4'd0:RGBp = 24'h543847;
				4'd1:RGBp = 24'h84AA45;
				4'd2:RGBp = 24'hA5C65D;
				4'd3:RGBp = 24'hC4E173;
				4'd4:RGBp = 24'hDCF585;
				4'd5:RGBp = 24'hD1EC7D;
				4'd6:RGBp = 24'hB5D468;
				4'd7:RGBp = 24'h95B750;
				4'd8:RGBp = 24'h769C3A;
				4'd9:RGBp = 24'h5D8728;
				4'd10:RGBp = 24'h558022;
				default:RGBp = 24'h543847;
				
		endcase
		case(p_e_palt) 
				4'd0:RGBp_e = 24'h543847;
				4'd1:RGBp_e = 24'h84AA45;
				4'd2:RGBp_e = 24'hA5C65D;
				4'd3:RGBp_e = 24'hC4E173;
				4'd4:RGBp_e = 24'hDCF585;
				4'd5:RGBp_e = 24'hD1EC7D;
				4'd6:RGBp_e = 24'hB5D468;
				4'd7:RGBp_e = 24'h95B750;
				4'd8:RGBp_e = 24'h769C3A;
				4'd9:RGBp_e = 24'h5D8728;
				4'd10:RGBp_e = 24'h558022;
				default:RGBp_e = 24'h543847;
		endcase

	end
	
	always_comb begin
		case(digit1_palt) 
				4'h0:RGBdigit1 = 24'hFF0000;
				4'h1:RGBdigit1 = 24'h000000;
				4'h2:RGBdigit1 = 24'hFFFFFF;
				default:RGBdigit1 = 24'hFF0000;
				
		endcase
		
		case(digit2_palt) 
				4'h0:RGBdigit2 = 24'hFF0000;
				4'h1:RGBdigit2 = 24'h000000;
				4'h2:RGBdigit2 = 24'hFFFFFF;
				default:RGBdigit2 = 24'hFF0000;
				
		endcase
		
	end
	always_comb begin
		case(coin_palt) 
				4'h0:RGBcoin = 24'hFFFFFF;
				4'h1:RGBcoin = 24'hffc745;
				4'h2:RGBcoin = 24'hd89000;
				default:RGBcoin = 24'hFFFFFF;
				
		endcase
	end
endmodule

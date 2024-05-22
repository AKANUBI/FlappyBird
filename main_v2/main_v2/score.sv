module score(input Clk, Reset,             
             input [6:0] score1,
				 input [6:0] score2,
             input [9:0] DrawX, DrawY, 
             output logic is_score1,
             output logic is_score2,
             output logic [18:0] s1_addr,
             output logic [18:0] s2_addr
             );    

    parameter [9:0] s1_x = 10'd320;  
    parameter [9:0] s2_x = 10'd280;  
    parameter [9:0] s_y = 10'd40;   
    parameter [9:0] height = 10'd40; 
    parameter [9:0] width = 10'd30; 

    int digit1;
    int digit2;

    int DistX1, DistX2, DistY;
	 int score;
	 
	 assign score = score1+score2;
   always_comb begin
		 digit1 = score % 10;
		 digit2 = score / 10;

		 DistX1 = DrawX - s1_x;
		 DistX2 = DrawX - s2_x;
		 DistY = DrawY - s_y;
	 
		 if (DistX1 < width && DistX1 >= 0 && DistY < height && DistY >= 0) begin
			  is_score1 = 1;
			  s1_addr = digit1*1200 + (DistY * width) + DistX1;  
		 end else begin
			  is_score1 = 0;
			  s1_addr = 0;
		 end

		 if (digit2 > 0 && DistX2 < width && DistX2 >= 0 && DistY < height && DistY >= 0) begin
			  is_score2 = 1;
			  s2_addr = digit2 * 1200 + (DistY * width) + DistX2;  
		 end else begin
			  is_score2 = 0;
			  s2_addr = 0;
		 end
	end  
endmodule

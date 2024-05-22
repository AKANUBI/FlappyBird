//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
				 output logic [7:0]  LEDG,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
	 logic [7:0] space_trigger;
	 logic [19:0] random_num;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 // new middle valiables
	 logic [9:0] DrawX,DrawY;
	 logic [9:0] Ball_X_Pos,Ball_Y_Pos;
	 logic [9:0] coin1_X_Pos, coin1_Y_Pos, coin2_X_Pos,coin2_Y_Pos;
	 logic is_ball;
	 logic is_pipe, is_pipe_edge;
	 logic is_grd_y, is_grd_g_d, is_grd_g_l;
	 logic is_score1, is_score2;
	 logic is_bg;
	 logic is_coin;
	 logic eat;
	 logic [18:0] c_addr;
	 logic [18:0] bg_addr;
	 logic [18:0] p_addr, p_e_addr;
	 logic [18:0] s1_addr, s2_addr;
	 logic collision;
	 logic is_bottom;
	 logic game_active;
	 logic game_over;
	 logic [1:0] game_state;
	 logic [18:0]   b_addr;
	 logic [6:0] score1;
	 logic [6:0] score2;
	 logic [6:0] score;
	 logic coin1_collected, coin2_collected;
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
									  .random_export(random_num),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset),
									  .space_trigger_export(space_trigger)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk, .Reset(Reset_h),.*);
    
    // Which signal should be frame_clk?
	 ball ball_instance(
    .Clk(Clk),
    .Reset(Reset_h),
    .frame_clk(VGA_VS),
    .DrawX(DrawX),
    .DrawY(DrawY),
    .space_trigger(space_trigger),
    .game_state(game_state),
    .is_ball(is_ball),
    .is_bottom(is_bottom),
    .b_addr(b_addr),
	 .Ball_X_Pos(Ball_X_Pos),
	 .Ball_Y_Pos(Ball_Y_Pos)
	  );

	 pipe pipe_instance(
		 .Clk(Clk), 
		 .Reset(Reset_h), 
		 .frame_clk(VGA_VS), 
		 .random_num(random_num),
		 .DrawX(DrawX), 
		 .DrawY(DrawY), 
		 .game_state(game_state), 
		 .is_pipe(is_pipe),
		 .is_grd_y(is_grd_y), 
		 .is_grd_g_d(is_grd_g_d), 
		 .is_grd_g_l(is_grd_g_l),
		 .is_pipe_edge(is_pipe_edge), 
		 .p_addr(p_addr), 
		 .p_e_addr(p_e_addr),
		 .score1(score1)
	);

	score score_instance(
    .Clk(Clk),
    .Reset(Reset_h),
    .score1(score1),  // 假设你有一个7位的输入score
	 .score2(score2),
    .DrawX(DrawX),
    .DrawY(DrawY),
    .is_score1(is_score1),
    .is_score2(is_score2),
    .s1_addr(s1_addr),
    .s2_addr(s2_addr)
	);

	 background bg(.Clk, .Reset(Reset_h),.frame_clk(VGA_VS),.DrawX(DrawX),.DrawY(DrawY), .is_ball(is_ball),  .is_pipe(is_pipe), .is_bg(is_bg),.bg_addr(bg_addr));

	 collision collision_instance(
		 .Clk(Clk),
		 .Reset(Reset_h),
		 .is_ball(is_ball),
		 .is_pipe(is_pipe),
		 .is_pipe_edge(is_pipe_edge),
		 .collision(collision)  // Ensure to assign a signal for the collision output
	 );
	 	 
//		eat_coin eat_coin_instance(
//				.Clk(Clk),
//				.is_coin(is_coin), 
//				.is_ball(is_ball),
//				.eat(eat)       
//					  );	
	 
     coin coin_instance(
		  .Clk(Clk),
		  .Reset(Reset_h),
		  .frame_clk(VGA_VS),
		  .DrawX(DrawX),
		  .DrawY(DrawY),
		  .random_num(random_num),
		  .game_state(game_state),
		  .is_coin(is_coin),
		  .coin1_collected(coin1_collected),
		  .coin2_collected(coin2_collected),
		  .c_addr(c_addr),
		  .coin1_X_Pos(coin1_X_Pos),
		  .coin1_Y_Pos(coin1_Y_Pos),
		  .coin2_X_Pos(coin2_X_Pos),
		  .coin2_Y_Pos(coin2_Y_Pos)
	  
	  );
	 
	 eat_coin eat_coin_instance (
		  .Clk(Clk),
		  .Reset(Reset_h),
		  .frame_clk(VGA_VS),
			.Ball_X_Pos(Ball_X_Pos), 
			.Ball_Y_Pos(Ball_Y_Pos), 
         .coin1_X_Pos(coin1_X_Pos), 
			.coin1_Y_Pos(coin1_Y_Pos), 
			.coin2_X_Pos(coin2_X_Pos), 
			.coin2_Y_Pos(coin2_Y_Pos), 
			.game_state(game_state),
			.coin1_collected(coin1_collected),
		   .coin2_collected(coin2_collected),
			.score2(score2)
     );
	 
	 
	 
    GameFSM GameFSM_instance(
    .Clk(Clk),
    .Reset(Reset_h),
    .space_trigger(space_trigger),
    .collision(collision),
    .is_bottom(is_bottom),
	 .keycode(keycode),
    .game_state(game_state)
		);

	 
	 color_mapper color_instance(
    .is_ball(is_ball),
	 .Clk(Clk),
    .b_addr(b_addr),
	 .p_addr(p_addr),
	 .p_e_addr(p_e_addr),
    .is_pipe(is_pipe),
	 .is_coin(is_coin),
	 .is_pipe_edge(is_pipe_edge),
	 .is_grd_y(is_grd_y), 
	 .is_grd_g_d(is_grd_g_d), 
	 .is_grd_g_l(is_grd_g_l),
	 .is_score1(is_score1),
	 .is_score2(is_score2),
	 .s1_addr(s1_addr),
	 .s2_addr(s2_addr),
	 .c_addr(c_addr),
	 .is_bg(is_bg),
	 .bg_addr(bg_addr),
    .DrawX(DrawX),
    .DrawY(DrawY),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
);
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
	  always_comb
		 begin
		 // default case
		 LEDG = 8'b0000;
		  case(keycode)
			  8'h04: begin
				  LEDG = 8'b0010;
				 end
			  8'h07: begin
				  LEDG = 8'b0001;
				 end
			  8'h1a: begin
				  LEDG = 8'b1000;
				 end
			  8'h16: begin
				  LEDG = 8'b0100;
				 end
		  endcase
		 end
	 
	 
	 
	 
endmodule

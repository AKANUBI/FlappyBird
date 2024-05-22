module GameFSM (
    input         Clk,          
    input         Reset,        
    input  [7:0] space_trigger, 
    input         collision,    
	 input         is_bottom,
	 input   [7:0]  keycode,
    output logic[1:0]  game_state
//    output logic  game_over    
//    output logic  display_start 
);



    typedef enum logic [1:0] {
        STATE_START_PAGE = 2'b00,
        STATE_GAME_ACTIVE = 2'b01,
        STATE_GAME_OVER = 2'b10
    } state_t;


    state_t current_state, next_state;


    always_ff @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            current_state <= STATE_START_PAGE;
        end else begin
            current_state <= next_state;
        end
    end


    always_comb begin
        case (current_state)
            STATE_START_PAGE: begin
					 game_state = 2'b00;
                if (space_trigger)
                    next_state = STATE_GAME_ACTIVE;
                else
                    next_state = STATE_START_PAGE;
            end

            STATE_GAME_ACTIVE: begin
					 game_state = 2'b01;
                if (collision ||is_bottom)
                    next_state = STATE_GAME_OVER;
                else
                    next_state = STATE_GAME_ACTIVE;
            end

            STATE_GAME_OVER: begin
                game_state = 2'b10;
                if (keycode == 8'h28) begin
                    next_state = STATE_START_PAGE;
					 end
                else begin
                    next_state = STATE_GAME_OVER; 
					 end
            end
        endcase
    end

  


endmodule
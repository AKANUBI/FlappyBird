module LFSR(
    input logic Clk,
//    input logic reset,
    output logic [7:0] random_number
);
    // Define LFSR state
    logic [7:0] lfsr_state = 8'b11111111;

    // Declare tap as a reg type
    reg tap;

    // Update LFSR state on every clock cycle
    always @(posedge Clk) begin
//        if (reset) begin
//            lfsr_state <= 8'b11111111; // Reset state
//        end else begin
            // Calculate feedback tap
            tap <= lfsr_state[7] ^ lfsr_state[5];
            // Shift and update LFSR state
            lfsr_state <= {lfsr_state[6:0], tap}; 
        end
//    end

    // Scale and offset the LFSR output to fit within your desired range
    always_comb begin
        // Scale the 8-bit LFSR output to fit within the range 40 to 440
        random_number = lfsr_state + 8'b01100100;
    end
endmodule


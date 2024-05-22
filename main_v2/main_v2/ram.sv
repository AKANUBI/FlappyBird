/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  birdram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_bird [0:1000];

initial
begin
	 $readmemh("ocmtxt/Dynamic_Bird.txt", mem_bird);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem_bird[read_address];
end

endmodule

module  background_ram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_bg [0:159999];

initial
begin
	 $readmemh("ocmtxt/bg.txt", mem_bg);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem_bg[read_address];
end

endmodule

module  pipe_line_ram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_pipe_line [0:49];

initial
begin
	 $readmemh("ocmtxt/pipe_line.txt", mem_pipe_line);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem_pipe_line[read_address];
end

endmodule

module  pipe_edge_ram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_pipe_edge [0:119];

initial
begin
	 $readmemh("ocmtxt/edge.txt", mem_pipe_edge);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem_pipe_edge[read_address];
end

endmodule




module  score_ram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_score [0:11999];

initial
begin
	 $readmemh("ocmtxt/score.txt", mem_score);
end


always_ff @ (posedge Clk) begin
data_Out<= mem_score[read_address];
end

endmodule


module  coin_ram
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 800 addresses
logic [3:0] mem_coin [0:255];

initial
begin
	 $readmemh("ocmtxt/coin.txt", mem_coin);
end


always_ff @ (posedge Clk) begin
data_Out<= mem_coin[read_address];
end

endmodule
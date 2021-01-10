module PostSequenceMemory
(
	input wire Clock,
	input wire [7:0] Current,
	output reg [31:0][7:0] PostSequence,
	output reg [7:0] LastPostEntry,
	output reg Overflow
);

	initial begin
		Overflow <= 1'b0;
		LastPostEntry <= 8'd0;
	end
	
	always @(posedge Clock) begin
		if (PostSequence[LastPostEntry] != Current) begin
			if (LastPostEntry >= 8'd31) begin
				Overflow <= 1'b1;
				//LastPostEntry <= 5'd0;
			end
			else begin
				LastPostEntry = LastPostEntry + 5'd1;
				if (LastPostEntry <= 8'd31) PostSequence[LastPostEntry] = Current;
			end
		end
	end

endmodule

module Dummy
(
	input wire Clock,
	input wire [7:0] Current,
	output reg [7:0] DummyOut
);

	(* keep = 1 *) wire [31:0][7:0] TempMem /* synthesis keep = 1 */;
	(* keep = 1 *) wire [4:0] TempMemLen /* synthesis keep = 1 */;
	wire TempOverflow;
	reg [4:0] DummyFirstIndex;
	
	initial begin
		DummyFirstIndex <= 5'd0;
	end
	
	PostSequenceMemory mem(.Clock(Clock), .Current(Current), .PostSequence(TempMem), 
		.LastPostEntry(TempMemLen), .Overflow(TempOverflow));
		
	always @(posedge Clock) begin
		DummyOut = TempMem[DummyFirstIndex];
		if (DummyFirstIndex == 5'd31) DummyFirstIndex = 5'd0;
		else DummyFirstIndex = DummyFirstIndex + 5'd1;
	end

endmodule

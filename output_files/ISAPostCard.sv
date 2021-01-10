module ISAPostCard
(
	input wire IOW, //Falling edge = SD latch
	input wire AEN, //LOW (non-DMA transactions)
	input wire BALE, //Falling edge = SA latch
	input wire [19:0] SA,
	input wire [7:0] SD,
	input wire Button,
	input wire Clock,
	output wire [6:0] FirstDigit, //Common cathode
	output wire [6:0] SecondDigit,	//Common anode
	output wire AliveIndicator,
	output wire ActivityIndicator,
	output wire OKIndicator,
	output reg [255:0][7:0] PostSequence,
	output reg [7:0] LastPostEntry
);

	wire [7:0] CurrentData;
	wire [19:0] CurrentAddress;
	wire [6:0] FirstDigitCommonAnode;
	reg [7:0] OutputData;
	reg TempAlive;
	reg Overflow;
	
	initial begin
		TempAlive <= 1'b1;
		LastPostEntry <= 8'b0;
		Overflow <= 1'b0;
	end
	
	ISA_Port80h my_port(.IOW(IOW), .AEN(AEN), .BALE(BALE), .SA(SA), .SD(SD), .LastData(CurrentData),
		.LastAddr(CurrentAddress), .ActivityIndicator(ActivityIndicator), .OKIndicator(OKIndicator));
	BCD_Decoder my_decoder(.BCD(OutputData), .FirstDigit(FirstDigitCommonAnode), .SecondDigit(SecondDigit));
	
	assign FirstDigit = ~FirstDigitCommonAnode;
	assign AliveIndicator = TempAlive;
	
	always @(CurrentData) begin
		PostSequence[LastPostEntry] = CurrentData;
		if (LastPostEntry == 8'hFF) Overflow <= 1'b1;
		else LastPostEntry = LastPostEntry + 8'b1;
	end
	
	always @(CurrentData, Button) begin
		if (Button == 1'b1) begin
			OutputData <= CurrentData;
			TempAlive <= 1'b0;
			end
		else begin
			OutputData <= CurrentAddress[7:0];
			TempAlive <= 1'b1;
		end
	end

endmodule

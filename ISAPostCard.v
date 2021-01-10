module ISAPostCard
(
	input wire IOW, //Falling edge = SD latch
	input wire AEN, //LOW (non-DMA transactions)
	input wire BALE, //Falling edge = SA latch
	input wire [19:0] SA,
	input wire [7:0] SD,
	input wire Button,
	input wire Clock,
	input wire SBHE,
	output wire [6:0] FirstDigit, //Common cathode
	output wire [6:0] SecondDigit,	//Common anode
	output wire AliveIndicator,
	output wire ActivityIndicator,
	output wire OKIndicator,
	output wire [7:0] DummyOut
);

	wire DivClock;
	wire [7:0] CurrentData;
	wire [19:0] CurrentAddress;
	wire [6:0] FirstDigitCommonAnode;
	reg [7:0] OutputData;
	reg [3:0] DivReg;
	reg TempAlive;
	
	initial begin
		TempAlive <= 1'b1;
	end
	
	ISA_Port80h my_port(.SBHE(SBHE), .IOW(IOW), .AEN(AEN), .BALE(BALE), .SA(SA), .SD(SD), .LastData(CurrentData),
		.LastAddr(CurrentAddress), .ActivityIndicator(ActivityIndicator), .OKIndicator(OKIndicator));
	BCD_Decoder my_decoder(.BCD(OutputData), .FirstDigit(FirstDigitCommonAnode), .SecondDigit(SecondDigit));
	Dummy my_mem(.Current(CurrentData), .Clock(DivClock), .DummyOut(DummyOut));
	
	parameter Divisor = 4'd10;
	assign FirstDigit = ~FirstDigitCommonAnode;
	assign AliveIndicator = TempAlive;
	assign DivClock = (DivReg < Divisor / 2) ? 1'b0 : 1'b1;
	
	always @(posedge Clock) begin
		DivReg <= DivReg + 4'b0001;
		if (DivReg >= Divisor) DivReg <= 4'd0;
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

module ISA_Port80h
(
	input wire SBHE, //LOW = 16-bit transfer
	input wire IOW, //Falling edge = SD latch
	input wire AEN, //LOW (non-DMA transactions)
	input wire BALE, //Falling edge = SA latch
	input wire [19:0] SA,
	input wire [7:0] SD,
	output reg [7:0] LastData,
	output reg [19:0] LastAddr,
	output reg ActivityIndicator,
	output reg OKIndicator
);

reg [19:0] TempAddr;

initial begin
	ActivityIndicator <= 1'b1;
	OKIndicator <= 1'b1;
end

always @(negedge BALE) begin
	if (~AEN && SBHE) begin
		TempAddr <= SA;
	end
end

always @(negedge IOW) begin
	ActivityIndicator <= 1'b0;
	if (~AEN && SBHE) begin
		LastAddr <= TempAddr;
		if (LastAddr == 20'h80) begin
			LastData <= SD;
			if (LastData == 8'b00000000) OKIndicator <= 1'b0;
			else OKIndicator <= 1'b0;
		end
	end
end

endmodule

module BCD_Decoder //Common anode!!
(
	input wire [7:0] BCD,
	output reg [6:0] FirstDigit,
	output reg [6:0] SecondDigit
);

function [6:0] SevenSegTable(input [3:0] halfbyte);
	case(halfbyte)
		4'b0000: SevenSegTable = 7'b1000000; // "0"  
		4'b0001: SevenSegTable = 7'b1111100; // "1" 
		4'b0010: SevenSegTable = 7'b0100100; // "2" 
		4'b0011: SevenSegTable = 7'b0110000; // "3" 
		4'b0100: SevenSegTable = 7'b0011001; // "4" 
		4'b0101: SevenSegTable = 7'b0010010; // "5" 
		4'b0110: SevenSegTable = 7'b0000010; // "6" 
		4'b0111: SevenSegTable = 7'b1111000; // "7" 
		4'b1000: SevenSegTable = 7'b0000000; // "8"  
		4'b1001: SevenSegTable = 7'b0010000; // "9" 
		4'b1010: SevenSegTable = 7'b0001000; // "a"
		4'b1011: SevenSegTable = 7'b0000011; // "b"
		4'b1100: SevenSegTable = 7'b1000110; // "c"
		4'b1101: SevenSegTable = 7'b0100001; // "d"
		4'b1110: SevenSegTable = 7'b0000110; // "e"
		4'b1111: SevenSegTable = 7'b0001110; // "f"
		default: SevenSegTable = 7'b1111111; // nothing
	endcase
endfunction

always @(BCD) begin
	FirstDigit <= SevenSegTable(BCD[3:0]);
	SecondDigit <= SevenSegTable(BCD[7:4]);
end

endmodule

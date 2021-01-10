library verilog;
use verilog.vl_types.all;
entity BCD_Decoder is
    port(
        BCD             : in     vl_logic_vector(7 downto 0);
        FirstDigit      : out    vl_logic_vector(6 downto 0);
        SecondDigit     : out    vl_logic_vector(6 downto 0)
    );
end BCD_Decoder;

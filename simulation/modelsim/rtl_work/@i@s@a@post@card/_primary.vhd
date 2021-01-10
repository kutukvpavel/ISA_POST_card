library verilog;
use verilog.vl_types.all;
entity ISAPostCard is
    port(
        IOW             : in     vl_logic;
        AEN             : in     vl_logic;
        BALE            : in     vl_logic;
        SA              : in     vl_logic_vector(19 downto 0);
        SD              : in     vl_logic_vector(7 downto 0);
        Button          : in     vl_logic;
        Clock           : in     vl_logic;
        FirstDigit      : out    vl_logic_vector(6 downto 0);
        SecondDigit     : out    vl_logic_vector(6 downto 0);
        AliveIndicator  : out    vl_logic;
        ActivityIndicator: out    vl_logic;
        OKIndicator     : out    vl_logic
    );
end ISAPostCard;

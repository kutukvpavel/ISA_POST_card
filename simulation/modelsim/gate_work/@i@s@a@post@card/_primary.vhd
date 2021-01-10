library verilog;
use verilog.vl_types.all;
entity ISAPostCard is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        IOW             : in     vl_logic;
        AEN             : in     vl_logic;
        BALE            : in     vl_logic;
        SA              : in     vl_logic_vector(19 downto 0);
        SD              : in     vl_logic_vector(7 downto 0);
        Button          : in     vl_logic;
        Clock           : in     vl_logic;
        SBHE            : in     vl_logic;
        FirstDigit      : out    vl_logic_vector(6 downto 0);
        SecondDigit     : out    vl_logic_vector(6 downto 0);
        AliveIndicator  : out    vl_logic;
        ActivityIndicator: out    vl_logic;
        OKIndicator     : out    vl_logic;
        DummyOut        : out    vl_logic_vector(7 downto 0)
    );
end ISAPostCard;

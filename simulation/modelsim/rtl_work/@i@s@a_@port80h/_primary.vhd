library verilog;
use verilog.vl_types.all;
entity ISA_Port80h is
    port(
        IOW             : in     vl_logic;
        AEN             : in     vl_logic;
        BALE            : in     vl_logic;
        SA              : in     vl_logic_vector(19 downto 0);
        SD              : in     vl_logic_vector(7 downto 0);
        LastData        : out    vl_logic_vector(7 downto 0);
        LastAddr        : out    vl_logic_vector(19 downto 0);
        ActivityIndicator: out    vl_logic;
        OKIndicator     : out    vl_logic
    );
end ISA_Port80h;

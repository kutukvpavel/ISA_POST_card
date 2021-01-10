library verilog;
use verilog.vl_types.all;
entity PostSequenceMemory is
    port(
        Current         : in     vl_logic;
        PostSequence    : out    vl_logic_vector(63 downto 0);
        LastPostEntry   : out    vl_logic_vector(5 downto 0);
        Overflow        : out    vl_logic
    );
end PostSequenceMemory;

library verilog;
use verilog.vl_types.all;
entity top_module is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        i1              : in     vl_logic_vector(31 downto 0);
        i2              : in     vl_logic_vector(31 downto 0);
        i3              : in     vl_logic_vector(31 downto 0);
        i4              : in     vl_logic_vector(31 downto 0);
        i5              : in     vl_logic_vector(31 downto 0);
        i6              : in     vl_logic_vector(31 downto 0);
        i7              : in     vl_logic_vector(31 downto 0);
        i8              : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        done            : out    vl_logic
    );
end top_module;

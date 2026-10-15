library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        i1              : in     vl_logic_vector(31 downto 0);
        i2              : in     vl_logic_vector(31 downto 0);
        i3              : in     vl_logic_vector(31 downto 0);
        i4              : in     vl_logic_vector(31 downto 0);
        i5              : in     vl_logic_vector(31 downto 0);
        i6              : in     vl_logic_vector(31 downto 0);
        i7              : in     vl_logic_vector(31 downto 0);
        i8              : in     vl_logic_vector(31 downto 0);
        alu1_sel1       : in     vl_logic_vector(3 downto 0);
        alu1_sel2       : in     vl_logic_vector(3 downto 0);
        alu1_op         : in     vl_logic;
        mul1_sel1       : in     vl_logic_vector(3 downto 0);
        mul1_sel2       : in     vl_logic_vector(3 downto 0);
        mul1_op         : in     vl_logic;
        result_en       : in     vl_logic;
        done_next       : in     vl_logic;
        reg_mul2_en     : in     vl_logic;
        reg_mul4_en     : in     vl_logic;
        reg_mul6_en     : in     vl_logic;
        reg_mul9_en     : in     vl_logic;
        reg_mul11_en    : in     vl_logic;
        reg_mul13_en    : in     vl_logic;
        reg_alu14_en    : in     vl_logic;
        result          : out    vl_logic_vector(31 downto 0);
        done            : out    vl_logic
    );
end datapath;

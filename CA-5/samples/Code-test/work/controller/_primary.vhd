library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        op_ready        : out    vl_logic;
        done_next       : out    vl_logic;
        result_en       : out    vl_logic;
        alu1_sel1       : out    vl_logic_vector(3 downto 0);
        alu1_sel2       : out    vl_logic_vector(3 downto 0);
        alu1_op         : out    vl_logic;
        mul1_sel1       : out    vl_logic_vector(3 downto 0);
        mul1_sel2       : out    vl_logic_vector(3 downto 0);
        mul1_op         : out    vl_logic;
        reg_mul2_en     : out    vl_logic;
        reg_mul4_en     : out    vl_logic;
        reg_mul6_en     : out    vl_logic;
        reg_mul9_en     : out    vl_logic;
        reg_mul11_en    : out    vl_logic;
        reg_mul13_en    : out    vl_logic;
        reg_alu14_en    : out    vl_logic
    );
end controller;

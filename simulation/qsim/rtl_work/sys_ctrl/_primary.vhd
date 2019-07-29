library verilog;
use verilog.vl_types.all;
entity sys_ctrl is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sys_rst_n       : out    vl_logic;
        clk_20m         : out    vl_logic;
        clk_100m        : out    vl_logic;
        sdram_clk       : out    vl_logic
    );
end sys_ctrl;

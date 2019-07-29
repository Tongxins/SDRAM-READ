library verilog;
use verilog.vl_types.all;
entity sdram_wr_data is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sdram_data      : inout  vl_logic_vector(15 downto 0);
        sys_data_in     : in     vl_logic_vector(15 downto 0);
        sys_data_out    : out    vl_logic_vector(15 downto 0);
        work_state      : in     vl_logic_vector(3 downto 0);
        cnt_clk         : in     vl_logic_vector(8 downto 0)
    );
end sdram_wr_data;

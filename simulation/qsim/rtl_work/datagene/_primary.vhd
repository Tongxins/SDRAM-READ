library verilog;
use verilog.vl_types.all;
entity datagene is
    generic(
        addr_end        : vl_logic_vector(18 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0)
    );
    port(
        clk_20m         : in     vl_logic;
        clk_100m        : in     vl_logic;
        rst_n           : in     vl_logic;
        wrf_din         : out    vl_logic_vector(15 downto 0);
        wrf_wrreq       : out    vl_logic;
        moni_addr       : out    vl_logic_vector(21 downto 0);
        syswr_done      : out    vl_logic;
        sdram_rd_ack    : in     vl_logic;
        memaddress      : out    vl_logic_vector(7 downto 0);
        datain          : in     vl_logic_vector(15 downto 0);
        mem_read        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of addr_end : constant is 2;
end datagene;

library verilog;
use verilog.vl_types.all;
entity sdfifo_ctrl is
    port(
        clk_20m         : in     vl_logic;
        clk_100m        : in     vl_logic;
        wrf_din         : in     vl_logic_vector(15 downto 0);
        wrf_wrreq       : in     vl_logic;
        sdram_wr_ack    : in     vl_logic;
        sys_data_in     : out    vl_logic_vector(15 downto 0);
        sdram_wr_req    : out    vl_logic;
        sys_data_out    : in     vl_logic_vector(15 downto 0);
        rdf_rdreq       : in     vl_logic;
        sdram_rd_ack    : in     vl_logic;
        rdf_dout        : out    vl_logic_vector(15 downto 0);
        sdram_rd_req    : out    vl_logic;
        syswr_done      : in     vl_logic;
        tx_start        : out    vl_logic;
        wrf_use         : out    vl_logic_vector(8 downto 0);
        rdf_use         : out    vl_logic_vector(8 downto 0)
    );
end sdfifo_ctrl;

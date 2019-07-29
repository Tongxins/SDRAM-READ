library verilog;
use verilog.vl_types.all;
entity sdram_ctrl is
    generic(
        TRP_CLK         : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        TRFC_CLK        : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        TMRD_CLK        : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        TRCD_CLK        : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        TCL_CLK         : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        TREAD_CLK       : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        TWRITE_CLK      : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        TDAL_CLK        : vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sdram_wr_req    : in     vl_logic;
        sdram_rd_req    : in     vl_logic;
        sdram_wr_ack    : out    vl_logic;
        sdram_rd_ack    : out    vl_logic;
        init_state      : out    vl_logic_vector(4 downto 0);
        work_state      : out    vl_logic_vector(3 downto 0);
        cnt_clk         : out    vl_logic_vector(8 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TRP_CLK : constant is 1;
    attribute mti_svvh_generic_type of TRFC_CLK : constant is 1;
    attribute mti_svvh_generic_type of TMRD_CLK : constant is 1;
    attribute mti_svvh_generic_type of TRCD_CLK : constant is 1;
    attribute mti_svvh_generic_type of TCL_CLK : constant is 1;
    attribute mti_svvh_generic_type of TREAD_CLK : constant is 1;
    attribute mti_svvh_generic_type of TWRITE_CLK : constant is 1;
    attribute mti_svvh_generic_type of TDAL_CLK : constant is 1;
end sdram_ctrl;

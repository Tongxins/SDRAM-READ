library verilog;
use verilog.vl_types.all;
entity sdr_test is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        clk_100m        : out    vl_logic;
        sdram_clk       : out    vl_logic;
        sdram_cke       : out    vl_logic;
        sdram_cs_n      : out    vl_logic;
        sdram_ras_n     : out    vl_logic;
        sdram_cas_n     : out    vl_logic;
        sdram_we_n      : out    vl_logic;
        sdram_ba        : out    vl_logic_vector(1 downto 0);
        sdram_addr      : out    vl_logic_vector(12 downto 0);
        sdram_data      : out    vl_logic_vector(15 downto 0);
        sdram_udqm      : out    vl_logic;
        sdram_ldqm      : out    vl_logic;
        rs232_tx        : out    vl_logic;
        tx_start        : out    vl_logic;
        wrf_use         : out    vl_logic_vector(8 downto 0);
        rdf_use         : out    vl_logic_vector(8 downto 0)
    );
end sdr_test;

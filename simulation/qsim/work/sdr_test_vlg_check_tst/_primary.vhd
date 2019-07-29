library verilog;
use verilog.vl_types.all;
entity sdr_test_vlg_check_tst is
    port(
        clk_100m        : in     vl_logic;
        rdf_use         : in     vl_logic_vector(8 downto 0);
        rs232_tx        : in     vl_logic;
        sdram_addr      : in     vl_logic_vector(12 downto 0);
        sdram_ba        : in     vl_logic_vector(1 downto 0);
        sdram_cas_n     : in     vl_logic;
        sdram_cke       : in     vl_logic;
        sdram_clk       : in     vl_logic;
        sdram_cs_n      : in     vl_logic;
        sdram_data      : in     vl_logic_vector(15 downto 0);
        sdram_ldqm      : in     vl_logic;
        sdram_ras_n     : in     vl_logic;
        sdram_udqm      : in     vl_logic;
        sdram_we_n      : in     vl_logic;
        tx_start        : in     vl_logic;
        wrf_use         : in     vl_logic_vector(8 downto 0);
        sampler_rx      : in     vl_logic
    );
end sdr_test_vlg_check_tst;

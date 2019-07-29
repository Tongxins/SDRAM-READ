library verilog;
use verilog.vl_types.all;
entity sdr_test_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sdram_data      : in     vl_logic_vector(15 downto 0);
        sampler_tx      : out    vl_logic
    );
end sdr_test_vlg_sample_tst;

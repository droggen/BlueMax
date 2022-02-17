	component bluemax_platform is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			pio_export    : out std_logic_vector(7 downto 0);        -- export
			reset_reset_n : in  std_logic                    := 'X'  -- reset_n
		);
	end component bluemax_platform;

	u0 : component bluemax_platform
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			pio_export    => CONNECTED_TO_pio_export,    --   pio.export
			reset_reset_n => CONNECTED_TO_reset_reset_n  -- reset.reset_n
		);


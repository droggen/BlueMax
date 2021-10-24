-- bluemax_core: core file of the design
-- 
-- This example animates the 7-segment display.
--

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity bluemax_core is
	port
	(
		-- On-board peripherals
		LAn : out std_logic_vector(1 downto 0)
		;seg : out std_logic_vector(6 downto 0)
		;segp : out std_logic
		;LED : out std_logic_vector(3 downto 0)
		;LED_S : out std_logic_vector(1 downto 0)
		;BTN : in std_logic_vector(4 downto 0)
		;CLK_MAIN : in std_logic
	
		-- Samtec lateral expansion connectors (for plugging on top of BlueSense or BasePower)				
		-- Left connector
		;X_SAIA2_SCK : in std_logic
		;X_SAI2A_MCLK_MISO : in std_logic
		;X_SAI2A_SD_MOSI : in std_logic
		;X_AUD_DAT : in std_logic
		;X_AUD_CLK : in std_logic
		
		-- Right connector
		;X_0_ADC0 : in std_logic 	-- On BasePower: USB TX (output of FPGA). 
		;X_1_ADC1 : in std_logic 	-- On BasePower: USB RX (input to FPGA).
		-- Other pins set as input 
		;X_2_ADC2 : in std_logic
		;X_3_ADC3 : in std_logic
		;X_4_ADC_DAC : in std_logic
		;X_5 : in std_logic		
		;X_SAI2A_FS_NSS : in std_logic
		;S_SDA : in std_logic
		;S_SCL : in std_logic		
		
		-- XP connector
		;XP_1 : in std_logic
		;XP_2 : in std_logic
		;XP_3 : in std_logic	
		;XP_4 : in std_logic
		;XP_5 : in std_logic
		;XP_6 : in std_logic
		;XP_7 : in std_logic
		;XP_8 : in std_logic
		
		-- XF connector
		;XF_1 : in std_logic
		;XF_2 : in std_logic
		;XF_3 : in std_logic
		;XF_4 : in std_logic
		;XF_5 : in std_logic
		;XF_6 : in std_logic
		;XF_7 : in std_logic		
		;XF_8 : in std_logic
		;XF_9 : in std_logic
		;XF_10 : in std_logic
		;XF_11 : in std_logic
		;XF_12 : in std_logic
		;XF_13 : in std_logic
		;XF_14 : in std_logic
		;XF_15 : in std_logic
		;XF_16 : in std_logic
		;XF_17 : in std_logic
		;XF_18 : in std_logic
		;XF_19 : in std_logic
		;XF_20 : in std_logic
		;XF_21 : in std_logic
		;XF_22 : in std_logic
		;XF_23 : in std_logic
		;XF_24 : in std_logic
		;XF_25 : in std_logic
		;XF_26 : in std_logic
		;XF_27 : in std_logic
		;XF_28 : in std_logic
		;XF_ADC1IN6 : in std_logic
		;XF_ADC1IN7 : in std_logic
		;XF_ADC1IN8 : in std_logic
		;XF_PLL_CLK : in std_logic		
	);

end bluemax_core;

architecture main of bluemax_core is
	-- cntr for animation
	signal cntr: std_logic_vector(22 downto 0);		-- 25MHz / 2^23~= 350ms
	signal animctr: std_logic_vector(2 downto 0);		
	
begin


	-- Clock divider: divider wraps around every ~350ms
	proc_ckdiv: process(clk_main)
   begin
		if rising_edge(clk_main) then
			cntr<=cntr+1;
		end if;
   end process;
	
	-- Animation counter -- 8 steps for a complete animation 
	proc_anim: process(clk_main)
   begin
		if rising_edge(clk_main) then
			if cntr="11111111111111111111111" then
				animctr<=animctr+1;
			end if;
		end if;
   end process;
	
	
	-- Lookup table for the animation
	-- Sequence: A, B, G, E, D, C, G, F, ....
	with animctr select		
		seg <=   "1111110" when "000",
					"1111101" when "001",
					"0111111" when "010",
					"1101111" when "011",
					"1110111" when "100",
					"1111011" when "101",
					"0111111" when "110",
					"1011111" when others;
	
	-- Turn on the two digits	
	LAn <= "11";
	-- Turn off the dot
	segp <= '1';
	-- Other LEDs off
	LED <= (others=>'1');
	LED_S <= (others=>'1');


end;

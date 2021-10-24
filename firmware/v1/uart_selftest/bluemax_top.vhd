library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity bluemax_top is
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
		;X_0_ADC0 : out std_logic 	-- On BasePower: USB TX (output of FPGA). 
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
		
		-- Unused FPGA pins
		;user_reserve : in std_logic_vector(26 downto 0)
		;user_reserve_gnd: in std_logic_vector(11 downto 0)	
	);
end bluemax_top;

architecture dan of bluemax_top is
	
	-- Signals to wire the outputs of the self-test block or the bluemax core to the FPGA outputs.
	signal st_LAn : std_logic_vector(1 downto 0);
	signal r_LAn : std_logic_vector(1 downto 0);	
	signal st_seg : std_logic_vector(6 downto 0);
	signal r_seg : std_logic_vector(6 downto 0);
	signal st_segp : std_logic;
	signal r_segp : std_logic;
	signal st_LED : std_logic_vector(3 downto 0);
	signal r_LED : std_logic_vector(3 downto 0);
	signal st_LED_S : std_logic_vector(1 downto 0);
	signal r_LED_S : std_logic_vector(1 downto 0);
	
	-- Default: self test on
	signal selftest: std_logic := '0';
	signal selftestlatched: std_logic := '0';
	
	-- Timer and counter for self test
	signal self_divider: std_logic_vector(19 downto 0);		-- 24MHz / 2^20~= 43ms
begin
	
	-- Multiplexer to chose self-test or real circuit output
	LAn <= st_LAn when selftest='1' else r_LAn;
	seg <= st_seg when selftest='1' else r_seg;
	segp <= st_segp when selftest='1' else r_segp;
	LED <= st_LED when selftest='1' else r_LED;
	LED_s <= st_LED_s when selftest='1' else r_LED_s;

	
	-- Check status of center button after ~43ms and enter self-test if pressed.
	proc_ckdiv: process(clk_main)
   begin
		if rising_edge(clk_main) then
			if selftestlatched='0' and self_divider="11111111111111111111" then
				selftestlatched<='1';
				if btn(3)='1' then 
					selftest<='0';
				else
					selftest<='1';
				end if;
			else			
				self_divider<=self_divider+1;
			end if;
		end if;
   end process;

	
	-- Instantiate self-tester
	comp_selftest: entity work.bluemax_selftest port map(LAn=>st_LAn,seg=>st_seg,segp=>st_segp,LED=>st_LED,LED_S=>st_LED_S,BTN=>BTN,CLK_MAIN=>CLK_MAIN);
		
	
	-- Map core
	comp_core: entity work.bluemax_core port map(
		LAn=>r_LAn, seg=>r_seg, segp=>r_segp, LED=>r_LED, LED_S=>r_LED_S, BTN=>BTN, CLK_MAIN=>CLK_MAIN,
		X_SAIA2_SCK=>X_SAIA2_SCK,
		X_SAI2A_MCLK_MISO=>X_SAI2A_MCLK_MISO,
		X_SAI2A_SD_MOSI=>X_SAI2A_SD_MOSI,
		X_AUD_DAT=>X_AUD_DAT,
		X_AUD_CLK=>X_AUD_CLK,		
		X_0_ADC0=>X_0_ADC0,
		X_1_ADC1=>X_1_ADC1,
		X_2_ADC2=>X_2_ADC2,
		X_3_ADC3=>X_3_ADC3,
		X_4_ADC_DAC=>X_4_ADC_DAC,
		X_5=>X_5,
		X_SAI2A_FS_NSS=>X_SAI2A_FS_NSS,
		S_SDA=>S_SDA,
		S_SCL=>S_SCL,
		XP_1=>XP_1,
		XP_2=>XP_2,
		XP_3=>XP_3,
		XP_4=>XP_4,
		XP_5=>XP_5,
		XP_6=>XP_6,
		XP_7=>XP_7,
		XP_8=>XP_8,		
		XF_1=>XF_1,
		XF_2=>XF_2,
		XF_3=>XF_3,
		XF_4=>XF_4,
		XF_5=>XF_5,
		XF_6=>XF_6,
		XF_7=>XF_7,		
		XF_8=>XF_8,
		XF_9=>XF_9,
		XF_10=>XF_10,
		XF_11=>XF_11,
		XF_12=>XF_12,
		XF_13=>XF_13,
		XF_14=>XF_14,
		XF_15=>XF_15,
		XF_16=>XF_16,
		XF_17=>XF_17,
		XF_18=>XF_18,
		XF_19=>XF_19,
		XF_20=>XF_20,
		XF_21=>XF_21,
		XF_22=>XF_22,
		XF_23=>XF_23,
		XF_24=>XF_24,
		XF_25=>XF_25,
		XF_26=>XF_26,
		XF_27=>XF_27,
		XF_28=>XF_28,
		XF_ADC1IN6=>XF_ADC1IN6,
		XF_ADC1IN7=>XF_ADC1IN7,
		XF_ADC1IN8=>XF_ADC1IN8,
		XF_PLL_CLK=>XF_PLL_CLK
	);

end;


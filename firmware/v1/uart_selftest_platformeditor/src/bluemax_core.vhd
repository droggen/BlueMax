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
		;clk : in std_logic
	
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
	);

end bluemax_core;

architecture main of bluemax_core is
	-- cntr for animation
	signal cntr: std_logic_vector(22 downto 0);		-- 25MHz / 2^23~= 350ms
	signal animctr: std_logic_vector(2 downto 0);		
	
	-- UART interface
	signal UART_TXD,UART_RXD: STD_LOGIC;
	signal data_out: STD_LOGIC_VECTOR(7 downto 0); -- received data
	signal data_in: STD_LOGIC_VECTOR(7 downto 0); -- data to send
	signal data_vld, data_fe, data_send, data_busy: STD_LOGIC;
	
	-- 7 segment interface
	signal digit : std_logic_vector(7 downto 0);
	signal dot : std_logic_vector(1 downto 0);
	signal data: std_logic_vector(7 downto 0);
	-- LED
	signal ledall : std_logic_vector(5 downto 0);
	
	
	--------------------------------------------------------------------------------
	-- RS232 UART from University Program instantiated via the Platform Editor


	component dan2 is
		port (
			clk_clk                                  : in  std_logic                    := 'X';             -- clk
			reset_reset_n                            : in  std_logic                    := 'X';             -- reset_n
			rs232_0_avalon_data_receive_source_ready : in  std_logic                    := 'X';             -- ready
			rs232_0_avalon_data_receive_source_data  : out std_logic_vector(7 downto 0);                    -- data
			rs232_0_avalon_data_receive_source_error : out std_logic;                                       -- error
			rs232_0_avalon_data_receive_source_valid : out std_logic;                                       -- valid
			rs232_0_avalon_data_transmit_sink_data   : in  std_logic_vector(7 downto 0) := (others => 'X'); -- data
			rs232_0_avalon_data_transmit_sink_error  : in  std_logic                    := 'X';             -- error
			rs232_0_avalon_data_transmit_sink_valid  : in  std_logic                    := 'X';             -- valid
			rs232_0_avalon_data_transmit_sink_ready  : out std_logic;                                       -- ready
			rs232_0_external_interface_RXD           : in  std_logic                    := 'X';             -- RXD
			rs232_0_external_interface_TXD           : out std_logic                                        -- TXD
		);
	end component dan2;
	
	--------------------------------------------------------------------------------
	signal CONNECTED_TO_rs232_0_avalon_data_receive_source_ready : STD_LOGIC;
	signal CONNECTED_TO_rs232_0_avalon_data_receive_source_data : std_logic_vector(7 downto 0);
	signal CONNECTED_TO_rs232_0_avalon_data_receive_source_error: STD_LOGIC;
	signal CONNECTED_TO_rs232_0_avalon_data_receive_source_valid: STD_LOGIC;
	signal CONNECTED_TO_rs232_0_avalon_data_transmit_sink_data : std_logic_vector(7 downto 0);
	signal CONNECTED_TO_rs232_0_avalon_data_transmit_sink_error: STD_LOGIC;
	signal CONNECTED_TO_rs232_0_avalon_data_transmit_sink_valid: STD_LOGIC;
	signal CONNECTED_TO_rs232_0_avalon_data_transmit_sink_ready: STD_LOGIC;
	
	
begin

	-- Instantiate the 7-segment display
  comp_7s: entity work.hexto7seg generic map (divn => 24)
		port map(clk=>clk,
			d1=>digit(7 downto 4),
			d0=>digit(3 downto 0),
			p1=>dot(1),
			p0=>dot(0),
			blink=>"00",
			q=>seg,
			p=>segp,
			active=>LAn);
			
	dot<="00";
			
	-- Clock divider: divider wraps around every ~350ms
	proc_ckdiv: process(clk)
   begin
		if rising_edge(clk) then
			cntr<=cntr+1;
		end if;
   end process;
	
	-- Animation counter -- 8 steps for a complete animation 
	proc_anim: process(clk)
   begin
		if rising_edge(clk) then
			if cntr="11111111111111111111111" then
				animctr<=animctr+1;
			end if;
		end if;
   end process;
	
	
	-- Lookup table for the LED animation
	with animctr select		
		ledall <=   "000000" when "000",
						"100001" when "001",
						"110011" when "010",
						"111111" when "011",
						"011110" when "100",
						"001100" when "101",
						"011110" when "110",
						"111111" when others;
	
	LED<=ledall(5 downto 2);
	LED_S<=ledall(1 downto 0);
	
	

	
	-- Map the UART RX/TX to the transceiver on BasePower
	X_0_ADC0 <= uart_txd;					
	uart_rxd <= X_1_ADC1;					
	 
	-- Always send a sequence A-H ASCII
	data <= "00000"&animctr;
	data_in <= data+x"41";
	
	-- Send not too quickly
	data_send <= '1' when cntr(18 downto 0)="0000000000000000000" else
						'0';

	-- Received data on 7-segment display
	pproc_dl: process(clk)
   begin
		if rising_edge(clk) then
			if  data_vld='1' then
				digit<=data_out;
			end if;
		end if;
   end process;	
	
	
	--------------------------------------------------------------------------------	
	-- RS232 UART from University Program instantiated via the Platform Editor

	u0 : component dan2
		port map (
			clk_clk                                  => clk,
			reset_reset_n                            => btn(0),
			rs232_0_avalon_data_receive_source_ready => '1',			-- Indicate we're always ready to get more data
			rs232_0_avalon_data_receive_source_data  => data_out,  	-- Received data to show on 7-seg
			rs232_0_avalon_data_receive_source_error => CONNECTED_TO_rs232_0_avalon_data_receive_source_error, -- Receive error
			rs232_0_avalon_data_receive_source_valid => data_vld, 	-- Valid data received
			
			rs232_0_avalon_data_transmit_sink_data   => data_in,   	--  Data to send out of the FPGA
			rs232_0_avalon_data_transmit_sink_error  => CONNECTED_TO_rs232_0_avalon_data_transmit_sink_error,  	-- Error
			--rs232_0_avalon_data_transmit_sink_valid  => CONNECTED_TO_rs232_0_avalon_data_transmit_sink_valid,  	-- Valid data to send
			rs232_0_avalon_data_transmit_sink_valid  => data_send,  --                                   			-- Data to send
			rs232_0_avalon_data_transmit_sink_ready  => CONNECTED_TO_rs232_0_avalon_data_transmit_sink_ready, 		-- Ready to send again?
			
			
			rs232_0_external_interface_RXD           => UART_RXD,           --         rs232_0_external_interface.RXD
			rs232_0_external_interface_TXD           => UART_TXD            --                                   .TXD
		);
		
		--------------------------------------------------------------------------------

end;

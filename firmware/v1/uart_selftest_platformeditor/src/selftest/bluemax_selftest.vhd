library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Self-testing
-- Up/down counter on the 7-segment display
-- Left/right LED scroll
-- Push button change up/down or left/right direction. Center button to blink 7-segments. 

entity bluemax_selftest is
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
	);
end bluemax_selftest;

architecture dan of bluemax_selftest is	
	-- Digit, dot and LED
	signal digit : std_logic_vector(7 downto 0);
	signal dot : std_logic_vector(1 downto 0);
	signal ledall : std_logic_vector(5 downto 0) := "111110";
	
	-- Debounced buttons
	signal btnd : std_logic_vector(4 downto 0);
	-- Edge detect buttons
	signal btnde : std_logic_vector(4 downto 0);
	
	-- Timer and counter for self test
	signal self_divider: std_logic_vector(21 downto 0);		-- 25MHz / 2^22~= 170ms
	
	-- Up/down, left/right or blink (button status)
	signal leftright : std_logic := '0';
	signal updown : std_logic := '0';
	signal doblink: std_logic := '1';
begin

	-- Push button debouncing
	-- btn(0): left
	comp_deb0 : entity work.debounce port map(clk=>clk,button=>btn(0),result=>btnd(0));
	comp_deb1 : entity work.debounce port map(clk=>clk,button=>btn(1),result=>btnd(1));
	comp_deb2 : entity work.debounce port map(clk=>clk,button=>btn(2),result=>btnd(2));
	comp_deb3 : entity work.debounce port map(clk=>clk,button=>btn(3),result=>btnd(3));
	comp_deb4 : entity work.debounce port map(clk=>clk,button=>btn(4),result=>btnd(4));
	
	-- Edge detectors on some buttons (for RAM editor)
	comp_edg0 : entity work.edgedetect port map(clk=>clk,din=>btnd(0),dout=>btnde(0),rst=>'0');
	comp_edg1 : entity work.edgedetect port map(clk=>clk,din=>btnd(1),dout=>btnde(1),rst=>'0');
	comp_edg2 : entity work.edgedetect port map(clk=>clk,din=>btnd(2),dout=>btnde(2),rst=>'0');
	comp_edg3 : entity work.edgedetect port map(clk=>clk,din=>btnd(3),dout=>btnde(3),rst=>'0');
	comp_edg4 : entity work.edgedetect port map(clk=>clk,din=>btnd(4),dout=>btnde(4),rst=>'0');
	
	-- Toggle directions/blinking
	proc_toggle: process(clk)
	begin
		if rising_edge(clk) then
			-- Ordering so that on reset it counts up and scrolls left
			if btnde(1)='1' then
				leftright <= '1';
			end if;		
			if btnde(0)='1' then
				leftright <= '0';
			end if;	
			if btnde(4)='1' then
				updown <= '1';
			end if;
			if btnde(2)='1' then
				updown <= '0';
			end if;
			if btnde(3)='1' then
				doblink <= not doblink;
			end if;
		end if;
	end process;
	
	

	-- Instantiate the 7-segment display
  comp_7s: entity work.hexto7seg generic map (divn => 24)
		port map(clk=>clk,
			d1=>digit(7 downto 4),
			d0=>digit(3 downto 0),
			p1=>dot(1),
			p0=>dot(0),
			blink=>doblink&doblink,
			q=>seg,
			p=>segp,
			active=>LAn);

	-- Turn on the dot with the left-right buttons
	dot<=(not btnd(0))&(not btnd(1));
	
	
	-- Clock divider: divider wraps around every ~170ms
	proc_ckdiv: process(clk)
   begin
		if rising_edge(clk) then
			self_divider<=self_divider+1;
		end if;
   end process;
	
	-- Digit counter: count up/down every time self_divider wraps around
	proc_ctr: process(clk)
   begin
		if rising_edge(clk) then
			if  self_divider="1111111111111111111111"  then 
				if updown='0' then
					digit<=digit+1;		-- up
				else
					digit<=digit-1;		-- down
				end if;
			end if;
		end if;
   end process;
	
	-- Scroll LED left or right every time self_divider wraps around
	proc_led: process(clk)
   begin
		if rising_edge(clk) then
			if  self_divider="1111111111111111111111"  then 
				if leftright='0' then
					ledall <= ledall(4 downto 0)&ledall(5);	-- left
				else
					ledall <= ledall(0)&ledall(5 downto 1);	-- right
				end if;	
				
			end if;
		end if;
   end process;
	
	
	
--	-- Toggle self-test to user
--	pproc_p3: process(clk)
--   begin
--			if rising_edge(clk) then
--				if  self_ctr = "10000" then
--					self<='1';
--				end if;
--			end if;
--   end process;
	

	-- Self-test signals
	--LAn <= "10";
	--seg <= "0000000";				
	--segp <= '0';
	--LED <= BTN(3 downto 0);				
	--LED_S <= BTN(4)&BTN(4);	
	
	LED<=ledall(5 downto 2);
	LED_S<=ledall(1 downto 0);

end;


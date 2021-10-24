-- Dan 2014-2021

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;



-- Clk: clock (e.g. 25MHZ, 100MHZ)
-- divn: divides clock by 2^(divn+1). With 25MHz clock use divn=24
-- d1: left digit 4-bit number
-- d0: left digit 4-bit number
-- p1: left digit decimal point
-- p0: right digit decimal point
-- blink: "lr" indicates whether left digit blinks when l=1; right digit blinks when r=1
-- q: 7-segment output of driver
-- p: decimal point output of driver
-- active : anode to activate 

entity hexto7seg is
	generic(divn : integer);
	port(	
		clk: in std_logic;
		d1: in std_logic_vector(3 downto 0);
		d0: in std_logic_vector(3 downto 0);
		p1: in std_logic;
		p0: in std_logic;
		blink: in std_logic_vector(1 downto 0);
		q: out std_logic_vector(6 downto 0);
		p: out std_logic;
		active : out std_logic_vector(1 downto 0)
		);
end hexto7seg;

architecture Behavioral of hexto7seg is
	signal a: std_logic;
	signal b: std_logic;
	signal c: std_logic;
	signal d: std_logic;
	signal qp: std_logic;
	signal qt: std_logic_vector(6 downto 0);
	-- ctr as vector to enable more than 2 digits
	signal ctr: std_logic_vector(0 downto 0);
	signal divider: std_logic_vector(divn downto 0);
begin



	pproc_1: process(clk)
   begin
			if rising_edge(clk) then
				divider<=divider+1;
			end if;
   end process;
	pproc_p2: process(clk)
   begin
			if rising_edge(clk) then
				if  divider(9 downto 0)="0000000000"  then 
					ctr<=ctr+1;
				end if;
			end if;
   end process;

	-- input mux
	with ctr select
	a <= 	d0(3) when "0",
			d1(3) when others;
	with ctr select
	b <= 	d0(2) when "0",
			d1(2) when others;
	with ctr select
	c <= 	d0(1) when "0",
			d1(1) when others;
	with ctr select
	d <= 	d0(0) when "0",
			d1(0) when others;

	with ctr select
	qp <= not p0 when "0",
			not p1 when others;
			
	-- Output mux
	with ctr select
	active <= 	"10" when "0",
					"01" when others;

	-- Blinking
	q(0) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(0);
	q(1) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(1);
	q(2) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(2);
	q(3) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(3);
	q(4) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(4);
	q(5) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(5);
	q(6) <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qt(6);
	p    <= (blink(to_integer(unsigned(ctr))) and divider(divn)) or qp;



	qt(0) <= not ( (not a and not b and not c and not d )
				or (not a and not b and c and not d)
				or (not a and not b and c and d)
				or (not a and b and not c and d)
				or (not a and b and c and not d)
				or (not a and b and c and d)
				or (a and not b and not c and not d)
				or (a and not b and not c and d)
				or (a and not b and c and not d)
				or (a and b and not c and not d)
				or (a and b and c and not d)
				or (a and b and c and d) );
				
	qt(1) <= not ( (not a and not b and not c and not d) 
				or (not a and not b and not c and d)
				or (not a and not b and c and not d)
				or (not a and not b and c and c)
				or (not a and b and not c and not d)
				or (not a and b and c and d)
				or (a and not b and not c and not d)
				or (a and not b and not c and d)
				or (a and not b and c and not d)
				or (a and b and not c and d) );
				
	qt(2) <=	not ( (not a and not b and not c and not d)
				or (not a and not b and not c and d)
				or (not a and not b and c and d)
				or (not a and b and not c and not d)
				or (not a and b and not c and d)
				or (not a and b and c and not d)
				or (not a and b and c and d)
				or (a and not b and not c and not d)
				or (a and not b and not c and d)
				or (a and not b and c and not d)
				or (a and not b and c and d)
				or (a and b and not c and d) );
	qt(3) <=	not ((not a and not b and not c and not d)
				or (not a and not b and c and not d)
				or (not a and not b and c and d)
				or (not a and b and not c and d)
				or (not a and b and c and not d)
				or (a and not b and not c and not d)
				or (a and not b and c and d)
				or (a and b and not c and not d)
				or (a and b and not c and d)
				or (a and b and c and not d) );

	--qt(4) <=	not ((not a and not b and not c and not d)
	--			or (not a and not b and c and not d)
	--			or (not a and b and c and not d)
	--			or (a and not b and not c and not d)
	--			or (a and not b and c and not d)
	--			or (a and not b and c and d)
	--			or (a and b and not c and not d)
	--			or (a and b and not c and d)
	--			or (a and b and c and not d)
	--			or (a and b and c and d) );

	
				
	--qt(5) <= 	not ((not a and not b and not c and not d)
	--			or (not a and b and not c and not d)
	--			or (not a and b and not c and d)
	--			or (not a and b and c and not d)
	--			or (a and not b and not c and not d)
	--			or (a and not b and not c and d)
	--			or (a and not b and c and not d)
	--			or (a and not b and c and d)
	--			or (a and b and not c and not d)
	--			or	(a and b and c and not d)
	--			or (a and b and c and d) );

				
	--qt(6) <=	not ((not a and not b and c and not d)
	--			or (not a and not b and c and d)
	--			or (not a and b and not c and not d)
	--			or (not a and b and not c and d)
	--			or (not a and b and c and not d)
	--			or (a and not b and not c and not d)
	--			or (a and not b and not c and d)
	--			or (a and not b and c and not d)
	--			or (a and not b and c and d)
	--			or (a and b and not c and d)
	--			or (a and b and c and not d)
	--			or (a and b and c and d) );

	-- Minimized expression:

	qt(4) <= not( (a and b) or (a and c) or (c and not d) or (not b and not d) );
	qt(5) <= not( (b and not d) or (not a and b and not c) or (a and not b) or (a and c) or (not c and not d) );
	qt(6) <= not( (not a and b and not c) or (a and not b) or (a and d) or (not b and c and d) or (c and not d) );


end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:28:53 09/30/2016 
-- Design Name: 
-- Module Name:    SDRAM-IDE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SDRAM_IDE is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           D : inout  STD_LOGIC_VECTOR (3 downto 0);
           SIZ : in  STD_LOGIC_VECTOR (1 downto 0);
           nDSACK : out  STD_LOGIC_VECTOR (1 downto 0);
           ARAM : out  STD_LOGIC_VECTOR (12 downto 0);
           UDQ0 : out  STD_LOGIC;
           LDQ0 : out  STD_LOGIC;
           UDQ1 : out  STD_LOGIC;
           LDQ1 : out  STD_LOGIC;
           RAS : out  STD_LOGIC;
           CAS : out  STD_LOGIC;
           MEM_WE : out  STD_LOGIC;
           CLK_RAM : out  STD_LOGIC;
           CLK_EN : out  STD_LOGIC;
           BA : out  STD_LOGIC_VECTOR (1 downto 0);
           RW : in  STD_LOGIC;
           nRAM_SEL : out  STD_LOGIC;
           LE_30_RAM : out  STD_LOGIC;
           OE_30_RAM : out  STD_LOGIC;
           LE_RAM_30 : out  STD_LOGIC;
           OE_RAM_30 : out  STD_LOGIC;
           CBREQ : in  STD_LOGIC;
           CBACK : out  STD_LOGIC;
           CIIN : out  STD_LOGIC;
           IDE_CS : out  STD_LOGIC_VECTOR (1 downto 0);
           IDE_A : out  STD_LOGIC_VECTOR (2 downto 0);
           IDE_R : out  STD_LOGIC;
           IDE_W : out  STD_LOGIC;
           IDE_WAIT : in  STD_LOGIC;
           IDE_RESET : out  STD_LOGIC;
			  IDE_BUFFER_DIR : out  STD_LOGIC;
           PLL_C_HALF : in  STD_LOGIC;
           PLL_C : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (1 downto 0);
           ROM_B : out  STD_LOGIC_VECTOR (1 downto 0);
           ROM_EN : out  STD_LOGIC;
           ROM_OE : out  STD_LOGIC;
           ROM_WE : out  STD_LOGIC;
           STERM : out  STD_LOGIC;
           CLK : in  STD_LOGIC;
           nAS : in  STD_LOGIC;
           nDS : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ECS : in  STD_LOGIC);
end SDRAM_IDE;

architecture Behavioral of SDRAM_IDE is

Function to_std_logic(X: in Boolean) return Std_Logic is
   variable ret : std_logic;
	begin
		if x then 
			ret := '1';  
		else 
			ret := '0'; 
		end if;
   return ret;
end to_std_logic;
	
function MAX(LEFT, RIGHT: INTEGER) return INTEGER is
begin
	if LEFT > RIGHT then 
		return LEFT;
	else 
		return RIGHT;
	end if;
end;


--constant CLOCK_SAMPLE : integer := 3; --cl3
constant CLOCK_SAMPLE : integer := 3; --cl2
--constant NQ_TIMEOUT : integer := 9; --cl3
constant NQ_TIMEOUT : integer := 6; --cl2
constant IDE_WAITS : integer := 2;
constant ROM_WAITS : integer := 4;
constant IDE_DELAY : integer := MAX(IDE_WAITS,ROM_WAITS);
	--wait this number of cycles for a refresh
	--should be 60ns minus one cycle, because the refresh command counts too 150mhz= 6,66ns *9 =60ns
	--puls one cycle for safety :(

constant RQ_TIMEOUT : integer := 255;
	--8192 refreshes in 64ms ->8192 refreshes in 3200000 50MHz ticks
	-- -> Refresh after 390 tics -> 255 is a safe place to be!


	TYPE sdram_state_machine_type IS (
				powerup, 					
				init_precharge,			
				init_precharge_commit,  
				init_opcode,				
				init_opcode_wait,			
				init_refresh,				
				init_wait,					
				start_state,				
				refresh_start,				
				refresh_wait,				
				start_ras,			
				commit_ras,			
				start_cas,			
				commit_cas,			
				commit_cas2,		
				data_wait,			
				data_wait2,			
				data_wait3,			
				precharge,			
				precharge_wait			
				);

signal	MY_CYCLE: STD_LOGIC;
signal   IDE_SPACE:STD_LOGIC;
signal   RAM_SPACE:STD_LOGIC;
signal   RANGER_SPACE:STD_LOGIC;
signal	AUTO_CONFIG:STD_LOGIC;
signal	AUTO_CONFIG_DONE:STD_LOGIC_VECTOR(1 downto 0);
signal	AUTO_CONFIG_PAUSE:STD_LOGIC;
signal	AUTO_CONFIG_DONE_CYCLE:STD_LOGIC_VECTOR(1 downto 0);
signal	SHUT_UP:STD_LOGIC_VECTOR(1 downto 0);
signal	IDE_BASEADR:STD_LOGIC_VECTOR(7 downto 0);
--signal	Dout1:STD_LOGIC_VECTOR(3 downto 0);
signal	Dout2:STD_LOGIC_VECTOR(3 downto 0);
signal	IDE_DSACK_D:STD_LOGIC_VECTOR(IDE_DELAY downto 0);
signal	DSACK_16BIT:STD_LOGIC;
signal	IDE_ENABLE:STD_LOGIC;
signal	ROM_OE_S:STD_LOGIC;
signal	IDE_R_S:STD_LOGIC;
signal	IDE_W_S:STD_LOGIC;
signal	IDE_BUF_S:STD_LOGIC;
--signal	AUTO_CONFIG_D0:STD_LOGIC;
signal	nAS_D0:STD_LOGIC;
signal	AUTO_CONFIG_FINISH:STD_LOGIC;
signal TRANSFER_IN_PROGRES:STD_LOGIC:= '1';
signal REFRESH: std_logic:= '1';
signal TRANSFER: std_logic:= '1';
signal NQ :  STD_LOGIC_VECTOR (3 downto 0);
signal RQ :  STD_LOGIC_VECTOR (7 downto 0);
signal CQ :  sdram_state_machine_type;
constant ARAM_PRECHARGE: STD_LOGIC_VECTOR (12 downto 0) := "0010000000000";   
--constant ARAM_OPTCODE: STD_LOGIC_VECTOR (12 downto 0) := "0001000110010"; --cl3   
constant ARAM_OPTCODE: STD_LOGIC_VECTOR (12 downto 0) := "0001000100010"; --cl2
signal ENACLK_PRE : STD_LOGIC;
signal CLK_D : STD_LOGIC;
signal CLK_PE : STD_LOGIC_VECTOR(CLOCK_SAMPLE downto 0);
signal STERM_S : STD_LOGIC;
signal CBACK_S : STD_LOGIC;
signal TRANSFER_CLK :  STD_LOGIC;
signal TRANSFER_RESET :  STD_LOGIC;
signal burst_counter : STD_LOGIC_VECTOR(1 downto 0);
signal RAM_BANK_ACTIVATE  :  STD_LOGIC;
begin


	--internal signals	
	--output
	MY_CYCLE		<= nAS 	when (IDE_SPACE='1' or AUTO_CONFIG ='1' or TRANSFER = '1' or TRANSFER_IN_PROGRES = '1') else '1';
	nRAM_SEL 	<= MY_CYCLE; 

	--map DSACK signal
	nDSACK		<= "ZZ" when MY_CYCLE ='1' ELSE
						"01" when DSACK_16BIT	 ='0' else 						
						"01" when AUTO_CONFIG='1' else 
						"11";
	STERM		<= STERM_S when TRANSFER_IN_PROGRES = '1' else 'Z';

	--enable caching for RAM
	CIIN	<= '1' when TRANSFER_IN_PROGRES = '1' else 
				'0' when ((IDE_SPACE='1' or AUTO_CONFIG ='1') and nAS='0') else
				'Z';
	CBACK <= CBACK_S;
	
	--PLL control
	
	--very tricky: a 5V device thinks 3,3v = 1 is floating! 
	--So if the pll is a 570A (5V) all 1 must be replaced with Z and all Ms with 1.
	--A 570B (3.3V) behaves as descrived in the datasheet!
		
	--FB CLK/2: SJ2: left
	--FB CLK  : SJ2: right
	
	
	--values for the 570A
	S<="ZZ"; --double the clock - FB is CLK 
	--S<="0Z"; --Quarduple the clock - FB is CLK 
	--S<="01"; --triple the clock - FB is CLK 
	--S<="00"; --disable
	--S<="Z0"; --recover the clock (1x

	--SD-RAM clock-stuff
	CLK_RAM 	<= not PLL_C;
	CLK_EN 	<= ENACLK_PRE;

	--map signals
	--ide stuff
	IDE_CS(0)<= not(A(12));			
	IDE_CS(1)<= not(A(13));
	IDE_A(0)	<= A(9);
	IDE_A(1)	<= A(10);
	IDE_A(2)	<= A(11);
	IDE_BUFFER_DIR	<= IDE_BUF_S when nAS='0' or nAS_D0 ='0' else '1';
	IDE_R		<= IDE_R_S when nAS='0' or nAS_D0 ='0'  else '1';
	IDE_W		<= IDE_W_S when nAS='0' or nAS_D0 ='0'  else '1';
	IDE_RESET<= RESET;
	ROM_EN	<= IDE_ENABLE;
	ROM_WE	<= '1';
	ROM_OE	<= ROM_OE_S;
	ROM_B		<= "00";
	
	--data out for autoconfig(tm)
	D	<=	"ZZZZ" when RW='0' or AUTO_CONFIG ='0' or nAS='1' else
			--Dout1	when 	AUTO_CONFIG_DONE(0)='0' else
			Dout2;	
	
	--transparent latch for writes
	LE_30_RAM <= '0';
	
	BA <= "00" when RAM_BANK_ACTIVATE='0' else A(19 downto 18);

	--32bit ram and rangermem adress decode
	RAM_SPACE    <= '1' when A(27) = '1'  
										and A(25 downto 20) /="111111" 
										else '0'; 
	RANGER_SPACE <= '1' when 
									A(27) = '0' 
									and A(23 downto 20) =x"2" --evil hack but cpld is full!
									and SHUT_UP(0)='0' 
								else '0'; 

	--transfer start detectioon via latch
  	TRANSFER_CLK <= '1' when (RAM_SPACE ='1' or RANGER_SPACE  ='1') and nAS ='0' else '0';
	TRANSFER_RESET <= '1' when CQ=commit_cas or RESET ='0' else '0';
	
	transfer_latch:process(TRANSFER_RESET,TRANSFER_CLK) begin
		if(TRANSFER_RESET ='1') then
			TRANSFER <= '0';
		elsif(rising_edge(TRANSFER_CLK))then
			TRANSFER <= '1';			
		end if;
	end process transfer_latch;

	--all signals, which need to be clocked on the negative edge
	neg_edge_ctrl:process(PLL_C)
	begin
		if(falling_edge(PLL_C))then
			
			--latch control for reads
			if(CQ=commit_ras or CQ=data_wait2)then --cl2
			--if(CQ=start_ras or CQ=data_wait2)then --cl3
				LE_RAM_30<= not RW;
			elsif(CQ=data_wait or RESET ='0')then
			--elsif(CQ=data_wait2 or CQ=precharge)then
				LE_RAM_30<= '1';
			end if;
			
			--sterm control
			if(CQ=commit_cas)then --cl3
			--if(CQ=start_cas)then --cl2
				STERM_S <= '0' ;
			elsif(CQ=precharge or nAS = '1' or RESET='0')then
				STERM_S <= '1';
			end if;

		end if;
	end process neg_edge_ctrl;
 
	--all signals, which need to be clocked on the positive edge
	pos_edge_ctrl:process (PLL_C) begin
      if rising_edge(PLL_C) then		

			
			--clock edge detection
			CLK_D	<= CLK;
			CLK_PE(0) <= CLK and not CLK_D; --the edge!			
			CLK_PE(CLOCK_SAMPLE downto 1) <= CLK_PE((CLOCK_SAMPLE-1) downto 0);
			
			--nAS delay
			nAS_D0	<=nAS;
								
			--bussizing decode
--			if(RESET = '0')then
--				LDQ0	<= '1';
--				UDQ0	<= '1';
--				LDQ1	<= '1';
--				UDQ1	<= '1';
--			else--if(nAS = '0' and nAS_PLL_C_N='1')then			
				--now decode the adresslines A[0..1] and SIZ[0..1] to determine the ram bank to write				
				-- bits 0-7
				if(RW='1' or ( SIZ="00" or 
									(A(0)='1' and A(1)='1') or 
									(A(1)='1' and SIZ(1)='1') or
									(A(0)='1' and SIZ="11" )))then
					LDQ0	<= '0';
				else
					LDQ0	<= '1';
				end if;
					
				-- bits 8-15
				if(RW='1' or (	(A(0)='0' and A(1)='1') or
									(A(0)='1' and A(1)='0' and SIZ(0)='0') or
									(A(1)='0' and SIZ="11") or 
									(A(1)='0' and SIZ="00")))then
					UDQ0	<= '0';
				else
					UDQ0	<= '1';
				end if;				
				
				--bits 16-23
				if(RW='1' or (	(A(0)='1' and A(1)='0') or
									(A(1)='0' and SIZ(0)='0') or 
									(A(1)='0' and SIZ(1)='1')))then
					LDQ1	<= '0';
				else
					LDQ1	<= '1';
				end if;									
				
				--bits 24--31
				if(RW='1' or ( 	A(0)='0' and A(1)='0' ))then
					UDQ1	<= '0';
				else
					UDQ1	<= '1';
				end if;
--			end if;
			
			--output buffer control
			if( CQ=commit_ras
				) then
				OE_30_RAM <= RW;
				OE_RAM_30 <= not RW;
			elsif(nAS = '1' 
					--and nAS_D0='1'
					)then -- delay the output a bit
				OE_30_RAM <= '1';
				OE_RAM_30 <= '1';
			end if;

			--transfer detection, cacheburst length and cacheburst acknowledge
			if ((TRANSFER ='1' or TRANSFER_IN_PROGRES = '1') and nAS='0')then
				TRANSFER_IN_PROGRES <= '1';

				--cache burst logic
				if(CBREQ = '0' and (CQ=commit_ras) 
					--and (RAM_ACCESS = '1') 
					and A(3 downto 2) < "11")then
					CBACK_S <='0';
					burst_counter <= A(3 downto 2);
				elsif(burst_counter = "11" and CQ=data_wait)then
					CBACK_S <= '1';
				end if;
				
				--burst increment
				if(CQ=data_wait and burst_counter < "11")then
					burst_counter <= burst_counter+1;
				end if;								
			else
				TRANSFER_IN_PROGRES <= '0';
				CBACK_S <= '1';
				burst_counter <= "11";
			end if;
--			CBACK_S <= '1';
--			burst_counter <= "11";

			--refresh flag
			if(CQ = init_refresh or 
				CQ = refresh_start)then
				REFRESH <= '0';
			elsif(RQ >= RQ_TIMEOUT) then 
				REFRESH <= '1';
			end if;

			--refresh counter
			if CQ = init_refresh or 
				CQ = refresh_start then
				RQ<=	x"00";
			elsif(CLK = '1' and CLK_D = '0' and RQ <RQ_TIMEOUT) then --count on edges
				RQ <= RQ + 1;
			end if;
			
			--wait counter stuff
			if(
				CQ = init_precharge_commit or
				CQ = init_wait or	
				CQ = init_opcode_wait or
				CQ = refresh_wait)
			then
				if(NQ < x"F")then
					NQ <= NQ +1;
				end if;
			else 
				NQ  <= x"0";
			end if;
			
			--bank activate decoder
			if(reset ='0') then
				RAM_BANK_ACTIVATE <='0';
			elsif(CQ= init_wait)then --now its save to switch on the bank decode
				RAM_BANK_ACTIVATE <='1';
			end if;
		
			-- ram state machine decoder
	      if reset='0' then
				CQ	<= powerup;
				RAS <= '1';
				CAS <= '1';
				MEM_WE <= '1';
  			   ARAM <= (others => '0');
			else
				case CQ is

				when powerup =>
				 ENACLK_PRE <= '1';		 
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 ARAM <= ARAM_PRECHARGE;
				 CQ <= init_precharge;
				
				when init_precharge =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '1';
				 MEM_WE <= '0';
				 --ARAM <= ARAM_PRECHARGE;
				 CQ <= init_precharge_commit;
				
				when init_precharge_commit =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 ARAM <= ARAM_OPTCODE;			
				 if (NQ >= x"3") then
				 	 CQ <= init_opcode;  
				 else
					 CQ <= init_precharge_commit;
				 end if;

				when init_opcode =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '0';
				 MEM_WE <= '0';
				 --ARAM <= ARAM_OPTCODE;			
				 CQ <= init_opcode_wait;

				when init_opcode_wait =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 if (NQ >= x"1") then
					 CQ <= init_refresh;   --1st refresh
				 else
					 CQ <= init_opcode_wait;
				 end if;

				when init_refresh =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '0';
				 MEM_WE <= '1';
				 CQ <= init_wait;

				when init_wait =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 if (	NQ >= NQ_TIMEOUT) then    --wait 60ns here
					CQ <= refresh_start; --last refresh completes initialzation
				 else
					 CQ <= init_wait;
				 end if;

				when start_state =>		 
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 ARAM <= A(17 downto 5);
				 if (REFRESH = '1') then
					 CQ <= refresh_start;
				 elsif (TRANSFER = '1'
							 and CLK_PE(CLOCK_SAMPLE)='1'
							) then
					--RAS <= '0';
					CQ <= start_ras;
				 else
					CQ <= start_state;
					--RAS <= '1';
				 end if;
				 
				when refresh_start =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '0';
				 MEM_WE <= '1';
				 CQ <= refresh_wait;

				when refresh_wait =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 ARAM <= A(17 downto 5);
				 if (NQ >= NQ_TIMEOUT) then			--wait 60ns here				 
					 CQ <= start_state;
				 else
					 CQ <= refresh_wait;
				 end if;

				when start_ras =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '1';
				 MEM_WE <= '1';
				 --ARAM <= A(17 downto 5);
				 CQ <= commit_ras;

			  when commit_ras =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 --mux for ranger mem			
				 if(A(27)='1')then
					ARAM <= "0000" & A(25 downto 20) & A(4 downto 2);
				 else
				 	ARAM <= "0000111111" & A(4 downto 2);
				 end if;
				 CQ <= start_cas;

				when start_cas =>
				 ENACLK_PRE <= '1'; --cl3
				 RAS <= '1';
				 CAS <= '0';
				 MEM_WE <= RW;
				 --mux for ranger mem
				 --if(A(27)='1')then
				 --	ARAM <= "0000" & A(25 downto 20) & A(4 downto 2);
				 --else
				 --	ARAM <= "0000111111" & A(4 downto 2);
				 --end if;
				 CQ <= commit_cas;

				when commit_cas =>
				 --ENACLK_PRE <= '1'; 
				 ENACLK_PRE <= '1'; --cl2
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 --CQ <= commit_cas2; --cl3
				 CQ <= data_wait; --cl2

				when commit_cas2 =>
				 ENACLK_PRE <= CBACK_S; --delay comes one clock later!
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 CQ <= data_wait;

				when data_wait => 
				 ENACLK_PRE <= CBACK_S;
				 RAS <= '1';
				 CAS <= '1';
 				 MEM_WE <= '1';
				 ARAM <= ARAM_PRECHARGE;
				 if(CBACK_S = '1')then
					CQ <= precharge;
				 else
					CQ <= data_wait2;
				 end if;

				when data_wait2 =>
				 ENACLK_PRE <= '1';				 
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 --CQ <= data_wait3; --cl3
				 CQ <= data_wait;	--cl2		

				when data_wait3 =>
				 ENACLK_PRE <= '0'; 
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 CQ <= data_wait;			
				 				 
				when precharge =>
				 ENACLK_PRE <= '1';
				 RAS <= '0';
				 CAS <= '1';
				 MEM_WE <= '0';
				 --ARAM <= ARAM_PRECHARGE;
				 CQ <= precharge_wait;

				when precharge_wait =>
				 ENACLK_PRE <= '1';
				 RAS <= '1';
				 CAS <= '1';
				 MEM_WE <= '1';
				 CQ <= start_state; 
				 
				end case;
			end if;
			
			--IDE address decode section 
			if(A(31 downto 16) = (x"00" & IDE_BASEADR) AND SHUT_UP(1) ='0') then
				IDE_SPACE <= '1';
			else
				IDE_SPACE <= '0';
			end if;			
			
			--Autoconfig(tm) address decode section 
			if(A(31 downto 16) =x"00E8" AND AUTO_CONFIG_DONE /="11") then
				AUTO_CONFIG <= '1';
			else
				AUTO_CONFIG <= '0';
			end if;

			--Autoconfig(tm) data-encoding
			if	reset = '0' then
				-- reset active ...
				AUTO_CONFIG_PAUSE <= '0';
				AUTO_CONFIG_DONE_CYCLE	<= "00";
				AUTO_CONFIG_DONE	<= "00";
				
				--use these presets for CDTV: This makes the DMAC config first!
				--AUTO_CONFIG_PAUSE <='1';
				--AUTO_CONFIG_DONE_CYCLE	<='1';
				--AUTO_CONFIG_DONE	<='1';
				--Dout1 <= "1111";
				Dout2 <= "1111";
				SHUT_UP	<= "11";
				IDE_BASEADR <= x"FF";
				--AUTO_CONFIG_D0 <= '0';
			else
--				if( 	A(31 downto 16) = x"00E8" 
--						and A (6 downto 1)= "100100"
--						and RW='0' and nAS_D0='0')  then
--					AUTO_CONFIG_FINISH <= '1';
--				else
--					AUTO_CONFIG_FINISH <= '0';
--				end if;
				
--				-- wait one autoconfig-strobe for CDTV!
--				if(AUTO_CONFIG_FINISH = '1'
--					and nAS_D0='1' and AUTO_CONFIG_PAUSE ='1') then
--					AUTO_CONFIG_PAUSE <= '0';
--					AUTO_CONFIG_DONE_CYCLE	<= "00";
--					AUTO_CONFIG_DONE <= "00";
--				els
				if(nAS= '1' and nAS_D0= '0' )then
					AUTO_CONFIG_DONE <= AUTO_CONFIG_DONE_CYCLE;
				end if;
			
				if(AUTO_CONFIG = '1' and nAS = '0') then
					--AUTO_CONFIG_D0 <= '1';
					case A(6 downto 1) is
						when "000000"	=> 
							--Dout1 <= "1110" ; --ZII, Memory,  no ROM
							--Dout2 <= "1101" ; --ZII, no Memory,  ROM
							if(AUTO_CONFIG_DONE(0)='0') then
								Dout2(0) <=	'0' ;
								Dout2(1) <=	'0' ;
							else
								Dout2(1) <=	'0' ;
							end if;
						when "000001"	=> 
							--Dout1 <=	"0101" ; --one Card, 1MB =  101
							--Dout2 <=	"0001" ; --one Card, 64kb = 001
							Dout2(1) <=	'0' ;
							if(AUTO_CONFIG_DONE(0)='1') then
								Dout2(2) <=	'0' ;
							end if;
							Dout2(3) <=	'0' ;
						--when "000010"	=> 
						--	Dout1 <=	"1111" ; --ProductID high nibble : F->0000=0
						--	Dout2 <=	"1111" ; --ProductID high nibble : F->0000=0
						when "000011"	=> 
							--Dout1 <=	"1001" ;
							--Dout2 <=	"1001" ; --ProductID low nibble: 9->0110=6
							Dout2(1) <=	'0' ;
							Dout2(2) <=	'0' ;
						--when "000100"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --Z3 Config HIGH                                                                                                                                                                                                                                                                                                                      Dout <=	"1111" ; --Config HIGH: 0x20 and no shut down
						--when "000101"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --Z3 Config LOW
						--when "000110"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --reserved
						--when "000111"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --reserved
						--when "001000"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --Ventor ID 0
						when "001001"	=> 
							--Dout1 <=	"0101" ;
							if(AUTO_CONFIG_DONE(0)='0') then
								Dout2(1) <=	'0' ;
							end if;
							--Dout2 <=	"0111" ; --Ventor ID 1
							Dout2(3) <=	'0' ;
						when "001010"	=> 
							--Dout1 <=	"1110" ;
							--Dout2 <=	"1101" ; --Ventor ID 2
							if(AUTO_CONFIG_DONE(0)='0') then
								Dout2(0) <=	'0' ;
							else
								Dout2(1) <=	'0' ;
							end if;
							
						when "001011"	=> 
							--Dout1 <=	"0011" ; --Ventor ID 3 : $0A1C: A1k.org
							--Dout1(2) <=	'0' ;
							--Dout1(3) <=	'0' ;
							--Dout2 <=	"0011" ; --Ventor ID 3 : $082C: BSC
							Dout2(2) <=	'0' ;
							Dout2(3) <=	'0' ;
						when "001100"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"0100" ; --Serial byte 0 (msb) high nibble
							Dout2(0) <=	'0' ;
							Dout2(1) <=	'0' ;
							Dout2(3) <=	'0' ;
						when "001101"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1110" ; --Serial byte 0 (msb) low  nibble
							Dout2(0) <=	'0' ;
						when "001110"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1001" ; --Serial byte 1       high nibble
							Dout2(1) <=	'0' ;							
							Dout2(2) <=	'0' ;
						when "001111"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"0100" ; --Serial byte 1       low  nibble
							Dout2(0) <=	'0' ;
							Dout2(1) <=	'0' ;
							Dout2(3) <=	'0' ;

						--when "010000"	=> 
						--	Dout1 <=	"1111" ;
						--	Dout2 <=	"1111" ; --Serial byte 2       high nibble
						--when "010001"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Serial byte 2       low  nibble
						when "010010"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"0100" ; --Serial byte 3 (lsb) high nibble
							Dout2(0) <=	'0' ;
							Dout2(1) <=	'0' ;
							Dout2(3) <=	'0' ;
						when "010011"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1010" ; --Serial byte 3 (lsb) low  nibble: B16B00B5
							Dout2(0) <=	'0' ;
							Dout2(2) <=	'0' ;
						--when "010100"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Rom vector high byte high nibble 
						--when "010101"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Rom vector high byte low  nibble 
						--when "010110"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Rom vector low byte high nibble
						when "010111"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1110" ; --Rom vector low byte low  nibble
							Dout2(0) <=	'0' ; --Rom vector low byte low  nibble
						--when "100000"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Interrupt config: all zero
						--when "100001"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ; --Interrupt config: all zero
						when "100100"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ;
							if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = "00")then 
								SHUT_UP(0) <= '0'; --enable board
								AUTO_CONFIG_DONE_CYCLE	<= "01"; --done here
							end if;
							if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = "01")then 
								IDE_BASEADR(7 downto 4)	<= D(3 downto 0); --Base adress
								SHUT_UP(1) <= '0'; --enable board
								AUTO_CONFIG_DONE_CYCLE	<= "11"; --done here
							end if;
						when "100101"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ;
							if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = "01")then 
								IDE_BASEADR(3 downto 0)	<= D(3 downto 0); --Base adress
							end if;
						when "100110"	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ;
							if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = "00")then 
								AUTO_CONFIG_DONE_CYCLE	<= "01"; --done here
							end if;
							if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = "01")then 
								AUTO_CONFIG_DONE_CYCLE	<= "11"; --done here
							end if;
						when others	=> 
							--Dout1 <=	"1111" ;
							--Dout2 <=	"1111" ;
					end case;	
				else
					--Dout1 <=	"1111" ;
					Dout2 <=	"1111" ;
				end if;
			end if;
		end if;
   end process pos_edge_ctrl;	

--	IDE_CTRL: process(clk) begin
--	if(rising_edge(clk)) then
--				--ide enable generation
--			if	(reset = '0') then
--				IDE_ENABLE			<='0';
--			elsif(IDE_SPACE = '1' and nAS = '0' and RW = '0')then
--				--enable IDE on the first write on this IO-space!
--				IDE_ENABLE <= '1';
--			end if;							
--			
--			--ide control signals
--			if(IDE_SPACE = '1' and nAS = '0')then
--				IDE_BUF_S <= not RW;
--
--				if(RW = '0' and IDE_WAIT = '1')then
--					IDE_DSACK_D(0)		<=	'0';
--					--the write goes to the hdd!
--					IDE_W_S		<= '0';
--					IDE_R_S		<= '1';
--					ROM_OE_S		<=	'1';
--					if(IDE_WAIT = '1')then --IDE I/O
--						DSACK_16BIT		<=	IDE_DSACK_D(IDE_WAITS);
--					end if;
--				elsif(RW = '1' and IDE_ENABLE = '1' and IDE_WAIT = '1')then
--					IDE_DSACK_D(0)		<=	'0';
--					--read from IDE instead from ROM
--					IDE_W_S		<= '1';
--					IDE_R_S		<= '0';
--					ROM_OE_S		<=	'1';
--					if(IDE_WAIT = '1')then --IDE I/O
--						DSACK_16BIT		<=	IDE_DSACK_D(IDE_WAITS);
--					end if;
--				elsif(RW = '1' and IDE_ENABLE = '0')then
--					IDE_DSACK_D(0)	<=	'0';
--					DSACK_16BIT		<= IDE_DSACK_D(ROM_WAITS);
--					IDE_W_S		<= '1';
--					IDE_R_S		<= '1';
--					ROM_OE_S		<=	'0';	
--				end if;
--				--generate IO-delay
--				IDE_DSACK_D(IDE_DELAY downto 1) <= IDE_DSACK_D((IDE_DELAY-1) downto 0);
--			else
--				IDE_BUF_S <= '1';
--				IDE_R_S		<= '1';
--				IDE_W_S		<= '1';
--				ROM_OE_S	<= '1';
--				--ROM_EN_S	<= '1';
--				IDE_DSACK_D		<= (others => '1');
--				DSACK_16BIT			<= '1';		
--			end if;				
--
--	end if;
--	end process IDE_CTRL;

	
	-- this is the clocked process
	ide_rw_gen: process (clk)
	begin
	
		if rising_edge(clk) then
		
			if	(reset = '0') then
				-- reset
				IDE_ENABLE			<='0';
			elsif(IDE_SPACE = '1' and nAS = '0' and RW = '0')then
				--enable IDE on the first write on this IO-space!
				IDE_ENABLE <= '1';
			end if;							
		
			if(IDE_SPACE = '1' and nAS = '0')then
				IDE_BUF_S <= not RW;

				if(RW = '0')then
					--the write goes to the hdd!
					IDE_W_S		<= '0';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D(0);
					end if;
				elsif(RW = '1' and IDE_ENABLE = '1')then
						--read from IDE instead from ROM
					IDE_W_S		<= '1';
					IDE_R_S		<= '0';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D(IDE_WAITS);
					end if;
				elsif(RW = '1' and IDE_ENABLE = '0')then
					DSACK_16BIT		<= IDE_DSACK_D(ROM_WAITS);
					--ROM_EN_S			<=	'0';						
					IDE_W_S		<= '1';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'0';						
				end if;

				--generate IO-delay
				IDE_DSACK_D(0)		<=	'0';
				IDE_DSACK_D(IDE_DELAY downto 1) <= IDE_DSACK_D((IDE_DELAY-1) downto 0);
			else
				IDE_BUF_S <= '1';
				IDE_R_S		<= '1';
				IDE_W_S		<= '1';
				ROM_OE_S	<= '1';
				--ROM_EN_S	<= '1';
				IDE_DSACK_D		<= (others => '1');
				DSACK_16BIT			<= '1';		
			end if;				
		end if;
	end process ide_rw_gen;

end Behavioral;

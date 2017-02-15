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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
   if x then ret := '1';  else ret := '0'; end if;
   return ret;
   end to_std_logic;
	
function MAX(LEFT, RIGHT: INTEGER) return INTEGER is
begin
  if LEFT > RIGHT then return LEFT;
  else return RIGHT;
    end if;
  end;


constant CLOCK_SAMPLE : integer := 2; --cl3
--constant CLOCK_SAMPLE : integer := 1; --cl2
constant NQ_TIMEOUT : integer := 9; --cl3
--constant NQ_TIMEOUT : integer := 6; --cl2
constant IDE_WAITS : integer := 1;
constant ROM_WAITS : integer := 4;
constant IDE_DELAY : integer := MAX(IDE_WAITS,ROM_WAITS);
	--wait this number of cycles for a refresh
	--should be 60ns minus one cycle, because the refresh command counts too 150mhz= 6,66ns *9 =60ns
	--puls one cycle for safety :(

constant RQ_TIMEOUT : integer := 255;
	--8192 refreshes in 64ms ->8192 refreshes in 3200000 50MHz ticks
	-- -> Refresh after 390 tics -> 255 is a safe place to be!


	TYPE sdram_state_machine_type IS (
				powerup, 					--000000
				init_precharge,			--000001 
				init_precharge_commit,  --000011
				init_opcode,				--000111
				init_opcode_wait,			--000111
				init_refresh,				--000010
				init_wait,					--000110
				start_state,				--000100
				refresh_start,				--001100
				refresh_wait,				--001101
				start_ras,			--001111
				commit_ras,			--001110
				start_cas,			--001010
				commit_cas,			--001011
				commit_cas2,			--001001
				data_wait,			--001001
				data_wait2,			--001001
				data_wait3,			--001001
				--pre_precharge,		--110011
				precharge,			--110011
				precharge_wait			--001001
				);
	TYPE sdram_control IS (
				c_nop,
				c_ras,
				c_cas,
				c_precharge,
				c_refresh,
				c_opt_code,
				c_burst_stop
	);

signal	MY_CYCLE: STD_LOGIC;
signal   IDE_SPACE:STD_LOGIC;
signal   RAM_SPACE:STD_LOGIC;
signal   RANGER_SPACE:STD_LOGIC;
signal	AUTO_CONFIG:STD_LOGIC;
signal	AUTO_CONFIG_DONE:STD_LOGIC;
signal	AUTO_CONFIG_PAUSE:STD_LOGIC;
signal	AUTO_CONFIG_DONE_CYCLE:STD_LOGIC;
signal	SHUT_UP:STD_LOGIC;
signal	IDE_BASEADR:STD_LOGIC_VECTOR(7 downto 0);
signal	Dout2:STD_LOGIC_VECTOR(3 downto 0);
signal	IDE_DSACK_D:STD_LOGIC_VECTOR(IDE_DELAY downto 0);
signal	DSACK_16BIT:STD_LOGIC;
signal	IDE_ENABLE:STD_LOGIC;
signal	ROM_OE_S:STD_LOGIC;
signal	IDE_R_S:STD_LOGIC;
signal	IDE_W_S:STD_LOGIC;
signal	IDE_BUF_S:STD_LOGIC;
signal	AUTO_CONFIG_D0:STD_LOGIC;
signal	nAS_D0:STD_LOGIC;
signal	nAS_PLL_C_N:STD_LOGIC;
signal	AUTO_CONFIG_FINISH:STD_LOGIC;
signal	IDE_CYCLE:STD_LOGIC;
signal TRANSFER_IN_PROGRES:STD_LOGIC:= '1';
signal REFRESH: std_logic:= '1';
signal TRANSFER: std_logic:= '1';
signal NQ :  STD_LOGIC_VECTOR (3 downto 0);
signal RQ :  STD_LOGIC_VECTOR (7 downto 0);
signal CQ :  sdram_state_machine_type;
signal CQ_D :  sdram_state_machine_type;
signal SDRAM_OP :  sdram_control;
signal ARAM_LOW: STD_LOGIC_VECTOR (8 downto 0);      
signal ARAM_HIGH: STD_LOGIC_VECTOR (12 downto 0);      
constant ARAM_PRECHARGE: STD_LOGIC_VECTOR (12 downto 0) := "0010000000000";   
--constant ARAM_OPTCODE: STD_LOGIC_VECTOR (12 downto 0) := "0001000110010"; --cl3   
constant ARAM_OPTCODE: STD_LOGIC_VECTOR (12 downto 0) := "0001000100010"; --cl2
signal ENACLK_PRE : STD_LOGIC;
signal CLK_D : STD_LOGIC;
signal CLK_PE : STD_LOGIC_VECTOR(CLOCK_SAMPLE downto 0);
signal STERM_S : STD_LOGIC;
signal CBACK_S : STD_LOGIC;
signal RAM_ACCESS : STD_LOGIC;
signal RANGER_ACCESS : STD_LOGIC;
signal TRANSFER_CLK :  STD_LOGIC;
signal TRANSFER_RESET :  STD_LOGIC;
signal ADR_AC_HIT :  STD_LOGIC;
signal ADR_IDE_HIT :  STD_LOGIC;
signal burst_counter : STD_LOGIC_VECTOR(1 downto 0);
signal LATCH_RAM_030 :  STD_LOGIC;
signal LATCH_RAM_030_D0 :  STD_LOGIC;
signal OE_30_RAM_S : STD_LOGIC;
signal OE_RAM_30_S : STD_LOGIC;

begin


	--internal signals	
	--output
	MY_CYCLE		<= '0' 	when (AUTO_CONFIG_D0='1' or IDE_CYCLE ='0' or TRANSFER = '1' or TRANSFER_IN_PROGRES = '1') else '1';
	nRAM_SEL 	<= MY_CYCLE; 

	--map DSACK signal
	nDSACK		<= "ZZ" when MY_CYCLE ='1' ELSE
						"01" when DSACK_16BIT	 ='0' else 						
						"01" when AUTO_CONFIG_D0='1' else 
						"11";
	STERM		<= STERM_S when TRANSFER_IN_PROGRES = '1' else 'Z';

	--enable caching for RAM
	CIIN	<= '1' when RAM_ACCESS = '1' else 
				'0' when AUTO_CONFIG_D0='1' or IDE_CYCLE ='0' or RANGER_ACCESS = '1' else
				'Z';
	CBACK <= CBACK_S;
	
	--very tricky: a 5V device thinks 3,3v = 1 is floating! 
	--So if the pll is a 570A (5V) all 1 must be replaced with Z and all Ms with 1.
	--A 570B (3.3V) behaves as descrived in the datasheet!
		
	--FB CLK/2: SJ2: left
	--FB CLK  : SJ2: right
	
	
	--values for the 570A
	S<="ZZ"; --double the clock - FB is CLK 
	--S<="0Z"; --Quarduple the clock - FB is CLK 
	--S<="01"; --triple the clock - FB is CLK 


	IDE_SPACE 	<= ADR_IDE_HIT;	
	AUTO_CONFIG <= ADR_AC_HIT;
	RAM_SPACE    <= '1' when A(27 downto 26) = "10" and A(25 downto 20) /="111111" else '0'; 
	RANGER_SPACE <= '0';--'1' when A(27) = '0' and A(23 downto 20) =x"C" else '0'; 

                
--  ADR_AC_HIT <= '1' when A(31 downto 16) =x"00E8" AND AUTO_CONFIG_DONE ='0' else '0'; 
--  ADR_IDE_HIT   <= '1' when A(31 downto 16) = (x"00" & IDE_BASEADR) AND SHUT_UP ='0'  else '0';
   adr_decode:process (PLL_C) begin
		if rising_edge(PLL_C) then
--			--nAS_PLL_C_N	<= nAS;
		
			if(A(31 downto 16) =x"00E8" AND AUTO_CONFIG_DONE ='0') then
				ADR_AC_HIT <= '1';
			else
				ADR_AC_HIT <= '0';
			end if;

			if(A(31 downto 16) = (x"00" & IDE_BASEADR) AND SHUT_UP ='0') then
				ADR_IDE_HIT <= '1';
			else
				ADR_IDE_HIT <= '0';
			end if;			
		end if;
	end process adr_decode;


	--SD-RAM stuff
	CLK_RAM 	<= not PLL_C;
	CLK_EN 	<= ENACLK_PRE;

	LE_RAM_30 <= LATCH_RAM_030;
	LE_30_RAM <= '0';

	latch_states: process(RESET,PLL_C)
	begin 
		if(RESET ='0')then
			LATCH_RAM_030 <='1';
			LATCH_RAM_030_D0 <='1';
		elsif(rising_edge(PLL_C))then
			LATCH_RAM_030_D0 <= LATCH_RAM_030;
			if(CQ=start_ras or CQ=data_wait2)then --cl2
			--if(CQ=start_ras or CQ=data_wait2)then --cl3
				LATCH_RAM_030<= not RW;
			elsif(CQ=data_wait)then
			--elsif(CQ=data_wait2 or CQ=precharge)then
				LATCH_RAM_030<= '1';
			end if;
		end if;			
	end process latch_states;



	buffer_oe: process(CLK) begin
		if(rising_edge(clk))then
			if((TRANSFER_IN_PROGRES ='1' 
					--or TRANSFER_IN_PROGRES_D0 ='1' 
					--or TRANSFER_IN_PROGRES_D1 ='1'
				) 
				--and nAS = '0'
				) then
				OE_30_RAM_S <= RW;
				OE_RAM_30_S <= not RW;
			else
				OE_30_RAM_S <= '1';
				OE_RAM_30_S <= '1';
			end if;
		end if;
	end process buffer_oe;
 
	OE_30_RAM <= OE_30_RAM_S;-- when nAS_PLL_C_N='0' else '1';
	OE_RAM_30 <= OE_RAM_30_S;-- when nAS_PLL_C_N='0' else '1';
 
 	TRANSFER_CLK <= '1' when (RAM_SPACE ='1' or RANGER_SPACE  ='1') and nAS ='0' else '0';
	TRANSFER_RESET <= '1' when CQ=commit_ras or RESET ='0' else '0';
	
	transfer_latch:process(TRANSFER_RESET,TRANSFER_CLK) begin
		if(TRANSFER_RESET ='1') then
			TRANSFER <= '0';
		elsif(rising_edge(TRANSFER_CLK))then
			TRANSFER <= '1';			
		end if;
	end process transfer_latch;
	
	sterm_gen:process(PLL_C)
	begin
		if(falling_edge(PLL_C))then
			if(CQ=commit_cas)then --cl3
			--if(CQ=commit_cas)then --cl2
				STERM_S <= '0' ;
			elsif(CQ=precharge or nAS = '1' or RESET='0')then
				STERM_S <= '1';
			end if;
		end if;
	end process sterm_gen;
 
	--decoder signals


	ARAM_HIGH <= A(17 downto 5);

	-- ram register Section   
	ram_ctrl:process (PLL_C) begin
      if rising_edge(PLL_C) then		
			CLK_D	<= CLK;
			CLK_PE(0) <= CLK and not CLK_D; --the edge!			
			CLK_PE(CLOCK_SAMPLE downto 1) <= CLK_PE((CLOCK_SAMPLE-1) downto 0);

			--transfer detection and cacheburst acknowledge
			nAS_PLL_C_N	<= nAS;
			
			
			if(RESET = '0')then
				LDQ0	<= '1';
				UDQ0	<= '1';
				LDQ1	<= '1';
				UDQ1	<= '1';
			elsif(nAS = '0' and nAS_PLL_C_N='1')then			
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
			end if;
			
			
			
			if(nAS = '1' or RESET = '0')then
				--TRANSFER <= '0';
				RANGER_ACCESS <= '0';
				RAM_ACCESS <= '0';
			elsif(nAS = '0' and nAS_PLL_C_N='1')then			
				if(A(27 downto 26) = "10" and
				   A(25 downto 20) <"111111")then
					RAM_ACCESS <= '1';
					RANGER_ACCESS <= '0';
				elsif(A(27) = '0' and A(23 downto 20) = x"C")then
					RANGER_ACCESS <= '1';
					RAM_ACCESS <= '0';
				end if;
			end if;

			if ((TRANSFER ='1' or TRANSFER_IN_PROGRES = '1') and nAS='0')then
				TRANSFER_IN_PROGRES <= '1';

				--cache burst logic
				if(CBREQ = '0' and (CQ=start_ras) 
					and (RAM_ACCESS = '1') 
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

			--refresh struff
			if(CQ = init_refresh or 
				CQ = refresh_start)then
				REFRESH <= '0';
			elsif(RQ >= RQ_TIMEOUT) then 
				REFRESH <= '1';
			end if;

			if CQ = init_refresh or 
				CQ = refresh_start then
				RQ<=	x"00";
			elsif(CLK_PE(0)='1' and RQ <RQ_TIMEOUT) then --count on edges
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
					
			--mux for ranger mem
			if(A(27) = '1') then
				ARAM_LOW  <=  A(25 downto 20) & A(4 downto 2);
			else
				ARAM_LOW  <=  "111111" & A(4 downto 2);
			end if;
			
					
			--sdram command decode
			case SDRAM_OP is
			when c_nop=>
				RAS <= '1';
				CAS <= '1';
				MEM_WE <= '1';
				--ARAM <= "0000000000000";
				BA <= A(19 downto 18);
			when c_ras=>
				RAS <= '0';
				CAS <= '1';
				MEM_WE <= '1';
				ARAM <= ARAM_HIGH;
				BA <= A(19 downto 18);
			when c_cas=>
				RAS <= '1';
				CAS <= '0';
				MEM_WE <= RW;
				ARAM <= "0000" & ARAM_LOW;
				BA <= A(19 downto 18);
			when c_precharge=>
				RAS <= '0';
				CAS <= '1';
				MEM_WE <= '0';
				ARAM <= ARAM_PRECHARGE;
				BA <= A(19 downto 18);
			when c_refresh=>
				RAS <= '0';
				CAS <= '0';
				MEM_WE <= '1';
				--ARAM <= "0000000000000";								
				BA <= A(19 downto 18);
			when c_opt_code=>
				RAS <= '0';
				CAS <= '0';
				MEM_WE <= '0';
				ARAM <= ARAM_OPTCODE;			
				BA <= "00";
			when c_burst_stop=>
				RAS <= '1';
				CAS <= '1';
				MEM_WE <= '0';
				--ARAM <= "0000000000000";								
				BA <= A(19 downto 18);
			end case;
									
			--statemachine transit
	      if reset='0' then
				CQ	<= powerup;
			else
				CQ	<= CQ_D;
			end if;
		end if;
   end process ram_ctrl;
	

	-- ram state machine decoder
   process (nDS, CQ, REFRESH, TRANSFER, NQ, RW,CLK_PE,CBACK_S)
   begin
      
      case CQ is

      when powerup =>
		 ENACLK_PRE <= '1';		 
		 SDRAM_OP <= c_nop;
 	 	 CQ_D <= init_precharge;
      
		when init_precharge =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_precharge;
		 CQ_D <= init_precharge_commit;
      
		when init_precharge_commit =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;
		 if (NQ >= x"3") then
		    CQ_D <= init_opcode;  
		 else
		    CQ_D <= init_precharge_commit;
		 end if;

      when init_opcode =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_opt_code;
		 CQ_D <= init_opcode_wait;

      when init_opcode_wait =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;
		 if (NQ >= x"1") then
		    CQ_D <= init_refresh;   --1st refresh
		 else
		    CQ_D <= init_opcode_wait;
		 end if;

      when init_refresh =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_refresh;
		 CQ_D <= init_wait;

      when init_wait =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;
		 if (	NQ >= NQ_TIMEOUT) then    --wait 60ns here
			CQ_D <= refresh_start; --last refresh completes initialzation
		 else
		    CQ_D <= init_wait;
		 end if;

      when start_state =>		 
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;		 
		 if (REFRESH = '1') then
		    CQ_D <= refresh_start;
		 elsif (TRANSFER = '1'
					 and CLK_PE(CLOCK_SAMPLE)='1'
					) then
		    CQ_D <= start_ras;
		 else
		    CQ_D <= start_state;
		 end if;
		 
      when refresh_start =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_refresh;
		 CQ_D <= refresh_wait;

      when refresh_wait =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;
		 if (NQ >= NQ_TIMEOUT) then			--wait 60ns here
			 if (TRANSFER = '1'  
					and CLK_PE(CLOCK_SAMPLE)='1'
					) then
			 	CQ_D <= start_ras;
			 else
		      CQ_D <= start_state;
			 end if;
		 else
		    CQ_D <= refresh_wait;
		 end if;

      when start_ras =>
		 ENACLK_PRE <= '1';
 		 SDRAM_OP<= c_ras;
		 CQ_D <= commit_ras;

	  when commit_ras =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP<= c_nop;
		 CQ_D <= start_cas;

      when start_cas =>
 		 ENACLK_PRE <= '1'; --cl3
		 SDRAM_OP <= c_cas;
		 CQ_D <= commit_cas;

      when commit_cas =>
		 ENACLK_PRE <= CBACK_S; --delay comes two clocks later!
		 SDRAM_OP <= c_nop;
 		 --CQ_D <= commit_cas2; --cl3
		 CQ_D <= data_wait; --cl2

      when commit_cas2 =>
		 ENACLK_PRE <= '1'; --delay comes one clock later!
		 SDRAM_OP <= c_nop;
 		 CQ_D <= data_wait;

      when data_wait => 
		 ENACLK_PRE <= CBACK_S;
		 if(CBACK_S = '1')then
			--CQ_D <= pre_precharge;
			CQ_D <= precharge;
		 else
			CQ_D <= data_wait3;	--cl2		
			--CQ_D <= data_wait2;	--cl3		
		 end if;
		 SDRAM_OP<= c_nop;

      when data_wait2 =>
 		 ENACLK_PRE <= '1'; 
		 SDRAM_OP<= c_nop;
		 CQ_D <= data_wait3;

      when data_wait3 =>
 		 ENACLK_PRE <= '0'; 
		 SDRAM_OP<= c_nop;
		 CQ_D <= data_wait;			
		 
		 
--      when pre_precharge =>
--		 ENACLK_PRE <= '1';
--		 SDRAM_OP <= c_nop;
--		 CQ_D <= precharge; 		 
		 
      when precharge =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_precharge;
 		 CQ_D <= precharge_wait;

      when precharge_wait =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_nop;
		 CQ_D <= start_state; 		 
		end case;
   end process;

	
	--IDE STUFF
	-- this is the clocked process
	ide_en_gen: process (reset, clk)
	begin
	
		if	(reset = '0') then
			-- reset
			IDE_ENABLE			<='0';
		elsif rising_edge(clk) then
			if(IDE_SPACE = '1' and nAS = '0')then
				if(RW = '0')then
					--enable IDE on the first write on this IO-space!
					IDE_ENABLE <= '1';
				end if;
			end if;							
		end if;
	end process ide_en_gen;

	
	-- this is the clocked process
	ide_rw_gen: process (clk)
	begin
	
		if rising_edge(clk) then
			if(IDE_SPACE = '1' and nAS = '0')then
				IDE_CYCLE <= '0';
				IDE_BUF_S <= not RW;

				if(RW = '0' and IDE_WAIT = '1')then
					IDE_DSACK_D(0)		<=	'0';
					--the write goes to the hdd!
					IDE_W_S		<= '0';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D(IDE_WAITS);
					end if;
				elsif(RW = '1' and IDE_ENABLE = '1' and IDE_WAIT = '1')then
					IDE_DSACK_D(0)		<=	'0';
					--read from IDE instead from ROM
					IDE_W_S		<= '1';
					IDE_R_S		<= '0';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D(IDE_WAITS);
					end if;
				elsif(RW = '1' and IDE_ENABLE = '0')then
					IDE_DSACK_D(0)		<=	'0';
					DSACK_16BIT		<= IDE_DSACK_D(ROM_WAITS);
					--ROM_EN_S			<=	'0';						
					IDE_W_S		<= '1';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'0';						
				end if;

				--generate IO-delay
				IDE_DSACK_D(IDE_DELAY downto 1) <= IDE_DSACK_D((IDE_DELAY-1) downto 0);
			else
				IDE_BUF_S <= '1';
				IDE_CYCLE <= '1';
				IDE_R_S		<= '1';
				IDE_W_S		<= '1';
				ROM_OE_S	<= '1';
				--ROM_EN_S	<= '1';
				IDE_DSACK_D		<= (others => '1');
				DSACK_16BIT			<= '1';		
			end if;				
		end if;
	end process ide_rw_gen;


	--map signals
	IDE_CS(0)<= not(A(12));			
	IDE_CS(1)<= not(A(13));
	IDE_A(0)	<= A(9);
	IDE_A(1)	<= A(10);
	IDE_A(2)	<= A(11);
	IDE_BUFFER_DIR	<= IDE_BUF_S when nAS_PLL_C_N ='0' else '1';
	IDE_R		<= IDE_R_S when nAS='0' or nAS_PLL_C_N ='0' else '1';
	IDE_W		<= IDE_W_S when nAS='0' else '1';--or nAS_PLL_C_N ='0' else '1';
	IDE_RESET<= RESET;
	ROM_EN	<= IDE_ENABLE;
	ROM_WE	<= '1';
	ROM_OE	<= ROM_OE_S;
	ROM_B		<= "00";
	
	--Autoconfig(tm) stuff
	D	<=	"ZZZZ" when RW='0' or AUTO_CONFIG ='0' or nAS='1' else
			Dout2;	
	
	autoconfig: process (reset, clk)
	begin
		if	reset = '0' then
			-- reset active ...
			AUTO_CONFIG_PAUSE <= '0';
			AUTO_CONFIG_DONE_CYCLE	<= '0';
			AUTO_CONFIG_DONE	<= '0';
			
			--use these presets for CDTV: This makes the DMAC config first!
			--AUTO_CONFIG_PAUSE <='1';
			--AUTO_CONFIG_DONE_CYCLE	<='1';
			--AUTO_CONFIG_DONE	<='1';
			Dout2 <= "1111";
			SHUT_UP	<= '1';
			IDE_BASEADR <= x"FF";
			AUTO_CONFIG_D0 <= '0';
		elsif rising_edge(clk) then -- no reset, so wait for rising edge of the clock		
			--nDS_D0				<=nDS;
			--nDS_D1				<=nDS_D0;
			nAS_D0				<=nAS;
			if( 	A(31 downto 16) = x"00E8" 
					and A (6 downto 1)= "100100"
					and RW='0' and nAS_D0='0')  then
				AUTO_CONFIG_FINISH <= '1';
			else
				AUTO_CONFIG_FINISH <= '0';
			end if;
			
			-- wait one autoconfig-strobe for CDTV!
			if(AUTO_CONFIG_FINISH = '1'
				and nAS_D0='1' and AUTO_CONFIG_PAUSE ='1') then
				AUTO_CONFIG_PAUSE <= '0';
				AUTO_CONFIG_DONE_CYCLE	<= '0';
				AUTO_CONFIG_DONE <= '0';
			elsif(nAS= '1' and nAS_D0= '0' )then
				AUTO_CONFIG_DONE <= AUTO_CONFIG_DONE_CYCLE;
			end if;
		
			if(AUTO_CONFIG = '1' and nAS = '0') then
				AUTO_CONFIG_D0 <= '1';
				case A(6 downto 1) is
					when "000000"	=> Dout2 <= 	"1101" ; --ZII, no Memory,  ROM
					when "000001"	=> Dout2 <=	"0001" ; --one Card, 64kb = 001
					--when "0000100"	=> Dout2 <=	"1111" ; --ProductID high nibble : F->0000=0
					when "000011"	=> Dout2 <=	"1001" ; --ProductID low nibble: 9->0110=6
					--when "0001000"	=>                                                                                                                                                                                                                                                                                                                        Dout <=	"1111" ; --Config HIGH: 0x20 and no shut down
					--when "0001010"	=> Dout2 <=	"1111" ; --Config LOW
					--when "0010000"	=> Dout2 <=	"1111" ; --Ventor ID 0
					when "001001"	=> Dout2 <=	"0111" ; --Ventor ID 1
					when "001010"	=> Dout2 <=	"1101" ; --Ventor ID 2
					when "001011"	=> Dout2 <=	"0011" ; --Ventor ID 3 : $082C: BSC
					when "001100"	=> Dout2 <=	"0100" ; --Serial byte 0 (msb) high nibble
					when "001101"	=> Dout2 <=	"1110" ; --Serial byte 0 (msb) low  nibble
					when "001110"	=> Dout2 <=	"1001" ; --Serial byte 1       high nibble
					when "001111"	=> Dout2 <=	"0100" ; --Serial byte 1       low  nibble
					--when "0100000"	=> Dout2 <=	"1111" ; --Serial byte 2       high nibble
					--when "0100010"	=> Dout2 <=	"1111" ; --Serial byte 2       low  nibble
					when "010010"	=> Dout2 <=	"0100" ; --Serial byte 3 (lsb) high nibble
					when "010011"	=> Dout2 <=	"1010" ; --Serial byte 3 (lsb) low  nibble: B16B00B5
					--when "0101000"	=> Dout2 <=	"1111" ; --Rom vector high byte high nibble 
					--when "0101010"	=> Dout2 <=	"1111" ; --Rom vector high byte low  nibble 
					--when "0101100"	=> Dout2 <=	"1111" ; --Rom vector low byte high nibble
					when "010111"	=> Dout2 <=	"1110" ; --Rom vector low byte low  nibble
					when "100000"	=> Dout2 <=	"0000" ; --Interrupt config: all zero
					when "100001"	=> Dout2 <=	"0000" ; --Interrupt config: all zero
					when "100100"	=> Dout2 <=	"1111" ;
						if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = '0')then 
							IDE_BASEADR(7 downto 4)	<= D(3 downto 0); --Base adress
							SHUT_UP <= '0'; --enable board
							AUTO_CONFIG_DONE_CYCLE	<= '1'; --done here
						end if;
					when "100101"	=> Dout2 <=	"1111" ;
						if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = '0')then 
							IDE_BASEADR(3 downto 0)	<= D(3 downto 0); --Base adress
						end if;
					when "100110"	=> Dout2 <=	"1111" ;
						if(nDS = '0' and RW='0' and AUTO_CONFIG_DONE = '0')then 
							AUTO_CONFIG_DONE_CYCLE	<= '1'; --done here
						end if;
					when others	=> Dout2 <=	"1111" ;
				end case;	
			else
				AUTO_CONFIG_D0 <= '0';
			end if;
		end if;

	end process autoconfig; --- that's all
end Behavioral;

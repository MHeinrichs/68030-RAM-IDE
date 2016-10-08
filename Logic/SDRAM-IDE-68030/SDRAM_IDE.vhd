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
				data_wait,			--001001
				data_wait2,			--001001
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
signal	IDE_DSACK_D0:STD_LOGIC;
signal	IDE_DSACK_D1:STD_LOGIC;
signal	IDE_DSACK_D2:STD_LOGIC;
signal	IDE_DSACK_D3:STD_LOGIC;
signal	DSACK_16BIT:STD_LOGIC;
signal	IDE_ENABLE:STD_LOGIC;
signal	ROM_OE_S:STD_LOGIC;
signal	IDE_R_S:STD_LOGIC;
signal	IDE_W_S:STD_LOGIC;
signal	IDE_BUF_S:STD_LOGIC;
signal	AUTO_CONFIG_D0:STD_LOGIC;
signal	nAS_D0:STD_LOGIC;
signal	AUTO_CONFIG_FINISH:STD_LOGIC;
signal	AUTO_CONFIG_CYCLE:STD_LOGIC;
signal	IDE_CYCLE:STD_LOGIC;
signal TRANSFER_IN_PROGRES:STD_LOGIC:= '1';
signal TRANSFER_CLK:STD_LOGIC:= '1';
signal REFRESH: std_logic:= '1';
signal CLRREFC: std_logic:= '1';
signal TRANSFER: std_logic:= '1';
signal NQ :  STD_LOGIC_VECTOR (3 downto 0);
signal NQ_TIMEOUT :  STD_LOGIC_VECTOR (3 downto 0);
signal RQ :  STD_LOGIC_VECTOR (7 downto 0);
signal RQ_TIMEOUT :  STD_LOGIC_VECTOR (7 downto 0);
signal CQ :  sdram_state_machine_type;
signal CQ_D :  sdram_state_machine_type;
signal SDRAM_OP :  sdram_control;
signal ARAM_LOW: STD_LOGIC_VECTOR (12 downto 0);      
signal ARAM_HIGH: STD_LOGIC_VECTOR (12 downto 0);      
signal ARAM_PRECHARGE: STD_LOGIC_VECTOR (12 downto 0);   
signal ARAM_OPTCODE: STD_LOGIC_VECTOR (12 downto 0);   
signal ENACLK_PRE : STD_LOGIC;
signal CLK_D0 : STD_LOGIC;
signal CLK_D1 : STD_LOGIC;
signal BYTE :  STD_LOGIC_VECTOR (3 downto 0);
signal STERM_S : STD_LOGIC;
signal STERM_CLK : STD_LOGIC;
signal LATCH_CLK : STD_LOGIC;
signal RAM_ACCESS : STD_LOGIC;
signal RANGER_ACCESS : STD_LOGIC;
signal LE_30_RAM_S : STD_LOGIC;   
signal LE_RAM_30_S : STD_LOGIC;   
	
	

   Function to_std_logic(X: in Boolean) return Std_Logic is
   variable ret : std_logic;
   begin
   if x then ret := '1';  else ret := '0'; end if;
   return ret;
   end to_std_logic;
	


begin


	--internal signals	
	--output
	MY_CYCLE		<= '0' 	when (AUTO_CONFIG='1' or IDE_SPACE ='1' or RAM_SPACE = '1' or RANGER_SPACE = '1') else '1';
	nRAM_SEL 	<= MY_CYCLE; 

	--map DSACK signal
	nDSACK		<= "ZZ" when MY_CYCLE ='1' ELSE
						"01" when DSACK_16BIT	 ='0' else 						
						"01" when AUTO_CONFIG_D0='1' else 
						"11";
	STERM		<= STERM_S when TRANSFER_IN_PROGRES = '1' else 'Z';

	--enable caching for RAM
	CIIN	<= '1' when TRANSFER_IN_PROGRES = '1' else 
				'0' when AUTO_CONFIG_CYCLE='0' or IDE_CYCLE ='0' else
				'Z';
	CBACK <= '1';
	
	--very tricky: a 5V device thinks 3,3v = 1 is floating! 
	--So if the pll is a 570A (5V) all 1 must be replaced with Z and all Ms with 1.
	--A 570B (3.3V) behaves as descrived in the datasheet!
		
	--FB CLK/2: SJ2: left
	--FB CLK  : SJ2: right
	
	
	--values for the 570A
	--S<="ZZ"; --double the clock - FB is CLK 
	--S<="0Z"; --Quarduple the clock - FB is CLK 
	S<="01"; --triple the clock - FB is CLK 

	--RAM_SPACE   <= '0';
	RAM_SPACE   <= '1'	when 
									A(31 downto 24) >= x"08"  
									--AND A(31 downto 20) < (x"0BF")  
									AND A(31 downto 24) <= x"0B"  
						else '0'; -- Access to RAM-Space
	RANGER_SPACE   <= '1'	when 
									A(31 downto 20) = (x"00C")  
						else '0'; -- Access to RANGER-Space
	--RANGER_SPACE   <= '0';

	IDE_SPACE   <= '1'	when 
									A(31 downto 16) = (x"00" & IDE_BASEADR)  
									AND SHUT_UP = '0' 
						else '0'; -- Access to IDE-Space
	AUTO_CONFIG	<= '1'	when 
									A(31 downto 16) = x"00E8"
									AND AUTO_CONFIG_DONE ='0'
						else '0'; -- Access to Autoconfig space and internal autoconfig not complete

--	adr_decode: process(PLL_C) --only for the "slow" adresses
--	begin 
--		if(rising_edge(PLL_C))then		
--			if(	A(31 downto 16) = (x"00" & IDE_BASEADR)  
--					AND SHUT_UP = '0')then
--				IDE_SPACE   <= '1';
--			else
--				IDE_SPACE   <= '0';
--			end if;
--			
--			if(	A(31 downto 16) = x"00E8"
--					AND AUTO_CONFIG_DONE ='0')then
--				AUTO_CONFIG	<= '1';
--			else
--				AUTO_CONFIG	<= '0';
--			end if;
--		end if;
--	end process adr_decode;


	--SD-RAM stuff
	CLK_RAM 	<= not PLL_C;
	CLK_EN 	<= ENACLK_PRE;

	LATCH_CLK <= '1' when (RAM_SPACE ='1' or RANGER_SPACE = '1') and nDS='0' else '0';


	latch_states: process(CQ,PLL_C,RESET, LATCH_CLK)
	begin 
		if((CQ=data_wait and PLL_C = '0') or RESET = '0')then
			LE_30_RAM<= '1';
			LE_RAM_30<= '1';
		elsif(rising_edge(LATCH_CLK))then
			LE_30_RAM<= RW;
			LE_RAM_30<= not RW;
		end if;			
	end process latch_states;


	--latch_states: process(PLL_C,RESET)
	--begin 
	--	if(RESET = '0')then
	--		LE_30_RAM_S<= '1';
	--		LE_RAM_30_S<= '1';
	--	elsif(falling_edge(PLL_C))then
	--		if(CQ=start_ras)then
	--			LE_30_RAM_S<= RW;
	--			LE_RAM_30_S<= not RW;
	--		elsif(CQ=data_wait)then
	--			LE_30_RAM_S<= '1';
	--			LE_RAM_30_S<= '1';				
	--		end if;
	--	end if;			
	--end process latch_states;
	--
	--LE_30_RAM <= '1' when nDS = '1' else LE_30_RAM_S;
	--LE_RAM_30 <= '1' when nDS = '1' else LE_RAM_30_S;

	--latch_states: process(PLL_C,nAS)
	--begin 
	--	if( nAS = '1')then
	--		LE_30_RAM<= '1';
	--		LE_RAM_30<= '1';
	--	elsif(falling_edge(PLL_C))then
	--		if(CQ=data_wait and RW='0') then
	--			LE_30_RAM<= '1';
	--		elsif(CQ=data_wait and RW='1') then
	--			LE_RAM_30<= '1';
	--		elsif(CQ=start_ras )then
	--			LE_30_RAM<= RW;
	--			LE_RAM_30<= not RW;
	--		end if;
	--	end if;			
	--end process latch_states;


	buffer_oe: process(CLK, nAS) begin
		if(nAS = '1')then
				OE_30_RAM <= '1';
				OE_RAM_30 <= '1';			
		elsif(rising_edge(clk))then
			if((RAM_SPACE = '1' or RANGER_SPACE = '1') 
				--and nAS = '0'
				) then
				OE_30_RAM <= RW;
				OE_RAM_30 <= not RW;
			else
				OE_30_RAM <= '1';
				OE_RAM_30 <= '1';
			end if;
		end if;
	end process buffer_oe;


   process (CQ,RESET,TRANSFER_CLK) begin
		if(CQ = precharge_wait or RESET = '0')then
			--TRANSFER <= '0';
			RANGER_ACCESS <= '0';
			RAM_ACCESS <= '0';
		elsif falling_edge(nAS) then
			--if (RAM_SPACE ='1' or RANGER_SPACE = '1')then
			--	TRANSFER <= '1';
			--end if;
			if(RAM_SPACE = '1')then
					RAM_ACCESS <= '1';
			end if;
			if(RANGER_SPACE = '1')then
				RANGER_ACCESS <= '1';
			end if;
		end if;
	end process;
 
 	TRANSFER <= RAM_ACCESS or RANGER_ACCESS;
 
	STERM_CLK <= '1' when CQ=data_wait else '0';
 
	sterm_gen:process(nAS, PLL_C)
	begin
		if(nAS = '1')then
			STERM_S <= '1';
		elsif(rising_edge(STERM_CLK))then
			STERM_S <= '0' ;
		end if;
	end process sterm_gen; 
 
 
	--sterm_gen:process(nAS, PLL_C)
	--begin
	--	if(nAS = '1')then
	--		STERM_S <= '1';
	--	elsif(rising_edge(PLL_C))then
	--		if(CQ=data_wait)then
	--			STERM_S <= '0' ;
	--		end if;
	--	end if;
	--end process sterm_gen;
 
	--decoder signals
	CLRREFC <= '1' when 	CQ = init_refresh or 
								CQ = refresh_start 								
						else '0';

	ARAM_HIGH <= A(17 downto 5);
	ARAM_PRECHARGE <= "0010000000000";
	ARAM_OPTCODE <= "0001000100000";

	ram_sizing: process(nAS,PLL_C) begin
		if(nAS= '1')then
			TRANSFER_IN_PROGRES <= '0';
			BYTE	<= "1111";
		elsif(rising_edge(PLL_C)) then
			if (TRANSFER ='1' or TRANSFER_IN_PROGRES = '1')then
				TRANSFER_IN_PROGRES <= '1';
				if(RAM_ACCESS = '1') then--mux for ranger
					ARAM_LOW  <=  "0000" & A(25 downto 20) & A(4 downto 2);
				else
					ARAM_LOW  <=  "0000111111" & A(4 downto 2);
				end if;
				--now decode the adresslines A[0..1] and SIZ[0..1] to determine the ram bank to write
				
				-- bits 0-7
				if(RW='1' or ( SIZ="00" or 
									(A(0)='1' and A(1)='1') or 
									(A(1)='1' and SIZ(1)='1') or
									(A(0)='1' and SIZ="11" )))then
					BYTE(0)	<= '0';
				else
					BYTE(0)	<= '1';
				end if;
				
				-- bits 8-15
				if(RW='1' or (	(A(0)='0' and A(1)='1') or
									(A(0)='1' and A(1)='0' and SIZ(0)='0') or
									(A(1)='0' and SIZ="11") or 
									(A(1)='0' and SIZ="00")))then
					BYTE(1)	<= '0';
				else
					BYTE(1)	<= '1';
				end if;				
				
				--bits 16-23
				if(RW='1' or (	(A(0)='1' and A(1)='0') or
									(A(1)='0' and SIZ(0)='0') or 
									(A(1)='0' and SIZ(1)='1')))then
					BYTE(2)	<= '0';
				else
					BYTE(2)	<= '1';
				end if;									
				--bits 24--31
				if(RW='1' or ( 	A(0)='0' and A(1)='0' ))then
					BYTE(3)	<= '0';
				else
					BYTE(3)	<= '1';
				end if;									
			end if;
		end if;
	end process ram_sizing;

	-- ram register Section
	
	RQ_TIMEOUT <= x"FF"; 
	--8192 refreshes in 64ms ->8192 refreshes in 3200000 50MHz ticks
	-- -> Refresh after 390 tics -> 256 is a safe place to be!
	NQ_TIMEOUT <= x"9"; 
	--wait this number of cycles for a refresh
	--should be 60ns minus one cycle, because the refresh command counts too 150mhz= 6,66ns *9 =60ns
	--puls one cycle for safety :(
   process (PLL_C) begin
      if rising_edge(PLL_C) then
			CLK_D0 <= CLK;
			CLK_D1 <= CLK_D0;
			--if(CLRREFC ='1')then
			if(CQ = init_refresh or 
				CQ = refresh_start)then
				REFRESH <= '0';
			elsif(RQ >= RQ_TIMEOUT) then 
				REFRESH <= '1';
			end if;

			--if(CLRREFC ='1')then
			if CQ = init_refresh or 
				CQ = refresh_start then
				RQ<=	x"00";
			elsif(CLK_D1='1' and CLK_D0 ='0' and RQ <RQ_TIMEOUT) then --count on falling edges
				RQ <= RQ + 1;
			end if;
			
						
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
					
			
			if(	CQ_D = start_cas or
					CQ_D = commit_cas or
					CQ_D = data_wait 
				)then
				UDQ1 <= BYTE(3);
				LDQ1 <= BYTE(2);
				UDQ0 <= BYTE(1);
				LDQ0 <= BYTE(0);
			else
				UDQ1 <= '1';
				LDQ1 <= '1';
				UDQ0 <= '1';
				LDQ0 <= '1';
			end if;
			
			
			case SDRAM_OP is
			when c_nop=>
				RAS <= '1';
				CAS <= '1';
				MEM_WE <= '1';
				ARAM <= "0000000000000";
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
				ARAM <= ARAM_LOW;
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
				ARAM <= "0000000000000";								
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
				ARAM <= "0000000000000";								
				BA <= A(19 downto 18);
			end case;
									
	      if reset='0' then
				CQ	<= powerup;
			else
				CQ	<= CQ_D;
			end if;
		end if;
   end process;
	
	-- ram state machine decoder
   process (nDS, CQ, REFRESH, TRANSFER, NQ, RW)
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
		 elsif (TRANSFER = '1') then
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
			 if (TRANSFER = '1') then
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
		 if(nDS = '0')then  --wait here for a valid datastrobe on writes
			CQ_D <= start_cas;
		 else
			CQ_D <= commit_ras;
		 end if;

      when start_cas =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_cas;
		 CQ_D <= commit_cas;

      when commit_cas =>
		 ENACLK_PRE <= '1';
		 SDRAM_OP <= c_nop;
 		 CQ_D <= data_wait;

      when data_wait =>
		 ENACLK_PRE <= '1'; 
		 SDRAM_OP<= c_nop;
		 --if(RW = '1')then
		 --	CQ_D <= data_wait2;
		 --else
			CQ_D <= precharge;
		 --end if;
      
		when data_wait2 =>
		 ENACLK_PRE <= '1'; 
		 SDRAM_OP <= c_nop;
		 CQ_D <= precharge;
		 
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

				if(RW = '0')then
					--the write goes to the hdd!
					IDE_W_S		<= '0';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D0;
					end if;
				elsif(RW = '1' and IDE_ENABLE = '1')then
						--read from IDE instead from ROM
					IDE_W_S		<= '1';
					IDE_R_S		<= '0';
					ROM_OE_S		<=	'1';
					if(IDE_WAIT = '1')then --IDE I/O
						DSACK_16BIT		<=	IDE_DSACK_D0;
					end if;
				elsif(RW = '1' and IDE_ENABLE = '0')then
					DSACK_16BIT		<= IDE_DSACK_D3;
					--ROM_EN_S			<=	'0';						
					IDE_W_S		<= '1';
					IDE_R_S		<= '1';
					ROM_OE_S		<=	'0';						
				end if;

				--generate IO-delay
				IDE_DSACK_D0		<=	'0';
				IDE_DSACK_D1		<= IDE_DSACK_D0;
				IDE_DSACK_D2		<= IDE_DSACK_D1;
				IDE_DSACK_D3		<= IDE_DSACK_D2;
			else
				IDE_R_S		<= '1';
				IDE_W_S		<= '1';
				ROM_OE_S	<= '1';
				--ROM_EN_S	<= '1';
				IDE_DSACK_D0		<= '1';
				IDE_DSACK_D1		<= '1';
				IDE_DSACK_D2		<= '1';
				IDE_DSACK_D3		<= '1';
				DSACK_16BIT			<= '1';		
			end if;				
		end if;
	end process ide_rw_gen;

	ide_dsack_gen: process (nAS, clk)
	begin
		if	nAS = '1' then
			IDE_CYCLE <= '1';
			IDE_BUF_S <= '1';
		elsif rising_edge(clk) then -- no reset, so wait for rising edge of the clock, Attention: The memory is triggered at the falling edge, so i can save one register!
			if(IDE_SPACE = '1')then
				IDE_CYCLE <= '0';
				IDE_BUF_S <= not RW;
			end if;
		end if;
	end process ide_dsack_gen;


	--map signals
	IDE_CS(0)<= not(A(12));			
	IDE_CS(1)<= not(A(13));
	IDE_A(0)	<= A(9);
	IDE_A(1)	<= A(10);
	IDE_A(2)	<= A(11);
	IDE_BUFFER_DIR	<= IDE_BUF_S;
	IDE_R		<= IDE_R_S;
	IDE_W		<= IDE_W_S;
	IDE_RESET<= RESET;
	ROM_EN	<= IDE_ENABLE;
	ROM_WE	<= '1';
	ROM_OE	<= ROM_OE_S;
	ROM_B		<= "00";
	
	--Autoconfig(tm) stuff
	D	<=	"ZZZZ" when RW='0' or AUTO_CONFIG ='0' or nAS='1' else
			Dout2;	
	acack_gen: process (nAS, clk)
	begin
		if	nAS = '1' then
			AUTO_CONFIG_CYCLE <= '1';
		elsif rising_edge(clk) then -- no reset, so wait for rising edge of the clock, Attention: The memory is triggered at the falling edge, so i can save one register!
			if(AUTO_CONFIG = '1')then
				AUTO_CONFIG_CYCLE <= '0';				
			end if;
		end if;
	end process acack_gen;

	
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
				if(RW = '1') then
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
						when others	=> Dout2 <=	"1111" ;
					end case;	
				else --write
					if( nDS = '0')then
						if(AUTO_CONFIG_DONE = '0')then
							if(A (6 downto 1) = "100100")then
								IDE_BASEADR(7 downto 4)	<= D(3 downto 0); --Base adress
								SHUT_UP <= '0'; --enable board
								AUTO_CONFIG_DONE_CYCLE	<= '1'; --done here
							elsif(A (6 downto 1) = "100101")then
								IDE_BASEADR(3 downto 0)	<= D(3 downto 0); --Base adress
							elsif(A (6 downto 1) = "100110")then
								AUTO_CONFIG_DONE_CYCLE	<= '1'; --done here
							end if;
						end if;
					end if;
				end if;
			else
				AUTO_CONFIG_D0 <= '0';
			end if;
		end if;

	end process autoconfig; --- that's all
end Behavioral;

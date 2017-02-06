--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:21:25 01/28/2017
-- Design Name:   
-- Module Name:   C:/Users/Matze/Amiga/Hardwarehacks/68030-RAM-IDE/Logic/SDRAM-IDE-68030/SDRAM_IDE-TB.vhd
-- Project Name:  SDRAM-IDE-68030
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SDRAM_IDE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SDRAM_IDE_TB IS
END SDRAM_IDE_TB;
 
ARCHITECTURE behavior OF SDRAM_IDE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SDRAM_IDE
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         D : INOUT  std_logic_vector(3 downto 0);
         SIZ : IN  std_logic_vector(1 downto 0);
         nDSACK : OUT  std_logic_vector(1 downto 0);
         ARAM : OUT  std_logic_vector(12 downto 0);
         UDQ0 : OUT  std_logic;
         LDQ0 : OUT  std_logic;
         UDQ1 : OUT  std_logic;
         LDQ1 : OUT  std_logic;
         RAS : OUT  std_logic;
         CAS : OUT  std_logic;
         MEM_WE : OUT  std_logic;
         CLK_RAM : OUT  std_logic;
         CLK_EN : OUT  std_logic;
         BA : OUT  std_logic_vector(1 downto 0);
         RW : IN  std_logic;
         nRAM_SEL : OUT  std_logic;
         LE_30_RAM : OUT  std_logic;
         OE_30_RAM : OUT  std_logic;
         LE_RAM_30 : OUT  std_logic;
         OE_RAM_30 : OUT  std_logic;
         CBREQ : IN  std_logic;
         CBACK : OUT  std_logic;
         CIIN : OUT  std_logic;
         IDE_CS : OUT  std_logic_vector(1 downto 0);
         IDE_A : OUT  std_logic_vector(2 downto 0);
         IDE_R : OUT  std_logic;
         IDE_W : OUT  std_logic;
         IDE_WAIT : IN  std_logic;
         IDE_RESET : OUT  std_logic;
         IDE_BUFFER_DIR : OUT  std_logic;
         PLL_C_HALF : IN  std_logic;
         PLL_C : IN  std_logic;
         S : OUT  std_logic_vector(1 downto 0);
         ROM_B : OUT  std_logic_vector(1 downto 0);
         ROM_EN : OUT  std_logic;
         ROM_OE : OUT  std_logic;
         ROM_WE : OUT  std_logic;
         STERM : OUT  std_logic;
         CLK : IN  std_logic;
         nAS : IN  std_logic;
         nDS : IN  std_logic;
         RESET : IN  std_logic;
         ECS : IN  std_logic
        );
    END COMPONENT;
	 
     COMPONENT mt48lc16m16a2
    PORT (
        BA0             : IN    std_logic := 'U';
        BA1             : IN    std_logic := 'U';
        DQMH            : IN    std_logic := 'U';
        DQML            : IN    std_logic := 'U';
        DQ0             : INOUT std_logic := 'U';
        DQ1             : INOUT std_logic := 'U';
        DQ2             : INOUT std_logic := 'U';
        DQ3             : INOUT std_logic := 'U';
        DQ4             : INOUT std_logic := 'U';
        DQ5             : INOUT std_logic := 'U';
        DQ6             : INOUT std_logic := 'U';
        DQ7             : INOUT std_logic := 'U';
        DQ8             : INOUT std_logic := 'U';
        DQ9             : INOUT std_logic := 'U';
        DQ10            : INOUT std_logic := 'U';
        DQ11            : INOUT std_logic := 'U';
        DQ12            : INOUT std_logic := 'U';
        DQ13            : INOUT std_logic := 'U';
        DQ14            : INOUT std_logic := 'U';
        DQ15            : INOUT std_logic := 'U';
        CLK             : IN    std_logic := 'U';
        CKE             : IN    std_logic := 'U';
        A0              : IN    std_logic := 'U';
        A1              : IN    std_logic := 'U';
        A2              : IN    std_logic := 'U';
        A3              : IN    std_logic := 'U';
        A4              : IN    std_logic := 'U';
        A5              : IN    std_logic := 'U';
        A6              : IN    std_logic := 'U';
        A7              : IN    std_logic := 'U';
        A8              : IN    std_logic := 'U';
        A9              : IN    std_logic := 'U';
        A10             : IN    std_logic := 'U';
        A11             : IN    std_logic := 'U';
        A12             : IN    std_logic := 'U';
        WENeg           : IN    std_logic := 'U';
        RASNeg          : IN    std_logic := 'U';
        CSNeg           : IN    std_logic := 'U';
        CASNeg          : IN    std_logic := 'U'
    );
	 END COMPONENT;   
	 
	 COMPONENT std543
	 PORT (
        A                : INOUT std_logic := 'U';
        B                : INOUT std_logic := 'U';
        OEBANeg          : IN    std_logic := 'U';
        CEBANeg          : IN    std_logic := 'U';
        LEBANeg          : IN    std_logic := 'U';
        OEABNeg          : IN    std_logic := 'U';
        CEABNeg          : IN    std_logic := 'U';
        LEABNeg          : IN    std_logic := 'U'
    );
	 END COMPONENT;   

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal SIZ : std_logic_vector(1 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal CBREQ : std_logic := '0';
   signal IDE_WAIT : std_logic := '0';
   signal PLL_C_HALF : std_logic := '0';
   signal PLL_C : std_logic := '0';
   signal CLK : std_logic := '0';
   signal nAS : std_logic := '0';
   signal nDS : std_logic := '0';
   signal RESET : std_logic := '0';
   signal ECS : std_logic := '0';

	--BiDirs
   signal D : std_logic_vector(31 downto 0);
   signal DRAM : std_logic_vector(31 downto 0);

 	--Outputs
   signal nDSACK : std_logic_vector(1 downto 0);
   signal ARAM : std_logic_vector(12 downto 0);
   signal UDQ0 : std_logic;
   signal LDQ0 : std_logic;
   signal UDQ1 : std_logic;
   signal LDQ1 : std_logic;
   signal RAS : std_logic;
   signal CAS : std_logic;
   signal MEM_WE : std_logic;
   signal CLK_RAM : std_logic;
   signal CLK_EN : std_logic;
   signal BA : std_logic_vector(1 downto 0);
   signal nRAM_SEL : std_logic;
   signal LE_30_RAM : std_logic;
   signal OE_30_RAM : std_logic;
   signal LE_RAM_30 : std_logic;
   signal OE_RAM_30 : std_logic;
   signal CBACK : std_logic;
   signal CIIN : std_logic;
   signal IDE_CS : std_logic_vector(1 downto 0);
   signal IDE_A : std_logic_vector(2 downto 0);
   signal IDE_R : std_logic;
   signal IDE_W : std_logic;
   signal IDE_RESET : std_logic;
   signal IDE_BUFFER_DIR : std_logic;
   signal S : std_logic_vector(1 downto 0);
   signal ROM_B : std_logic_vector(1 downto 0);
   signal ROM_EN : std_logic;
   signal ROM_OE : std_logic;
   signal ROM_WE : std_logic;
   signal STERM : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SDRAM_IDE PORT MAP (
          A => A,
          D => D(31 downto 28),
          SIZ => SIZ,
          nDSACK => nDSACK,
          ARAM => ARAM,
          UDQ0 => UDQ0,
          LDQ0 => LDQ0,
          UDQ1 => UDQ1,
          LDQ1 => LDQ1,
          RAS => RAS,
          CAS => CAS,
          MEM_WE => MEM_WE,
          CLK_RAM => CLK_RAM,
          CLK_EN => CLK_EN,
          BA => BA,
          RW => RW,
          nRAM_SEL => nRAM_SEL,
          LE_30_RAM => LE_30_RAM,
          OE_30_RAM => OE_30_RAM,
          LE_RAM_30 => LE_RAM_30,
          OE_RAM_30 => OE_RAM_30,
          CBREQ => CBREQ,
          CBACK => CBACK,
          CIIN => CIIN,
          IDE_CS => IDE_CS,
          IDE_A => IDE_A,
          IDE_R => IDE_R,
          IDE_W => IDE_W,
          IDE_WAIT => IDE_WAIT,
          IDE_RESET => IDE_RESET,
          IDE_BUFFER_DIR => IDE_BUFFER_DIR,
          PLL_C_HALF => PLL_C_HALF,
          PLL_C => PLL_C,
          S => S,
          ROM_B => ROM_B,
          ROM_EN => ROM_EN,
          ROM_OE => ROM_OE,
          ROM_WE => ROM_WE,
          STERM => STERM,
          CLK => CLK,
          nAS => nAS,
          nDS => nDS,
          RESET => RESET,
          ECS => ECS
        );
		  
	Latch0: std543	PORT MAP(
        A	=>D(0),
        B   =>DRAM(0),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch1: std543	PORT MAP(
        A	=>D(1),
        B   =>DRAM(1),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch2: std543	PORT MAP(
        A	=>D(2),
        B   =>DRAM(2),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch3: std543	PORT MAP(
        A	=>D(3),
        B   =>DRAM(3),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch4: std543	PORT MAP(
        A	=>D(4),
        B   =>DRAM(4),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch5: std543	PORT MAP(
        A	=>D(5),
        B   =>DRAM(5),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch6: std543	PORT MAP(
        A	=>D(6),
        B   =>DRAM(6),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch7: std543	PORT MAP(
        A	=>D(7),
        B   =>DRAM(7),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch8: std543	PORT MAP(
        A	=>D(8),
        B   =>DRAM(8),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch9: std543	PORT MAP(
        A	=>D(9),
        B   =>DRAM(9),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch10: std543	PORT MAP(
        A	=>D(10),
        B   =>DRAM(10),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch11: std543	PORT MAP(
        A	=>D(11),
        B   =>DRAM(11),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch12: std543	PORT MAP(
        A	=>D(12),
        B   =>DRAM(12),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch13: std543	PORT MAP(
        A	=>D(13),
        B   =>DRAM(13),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch14: std543	PORT MAP(
        A	=>D(14),
        B   =>DRAM(14),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch15: std543	PORT MAP(
        A	=>D(15),
        B   =>DRAM(15),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch16: std543	PORT MAP(
        A	=>D(16),
        B   =>DRAM(16),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch17: std543	PORT MAP(
        A	=>D(17),
        B   =>DRAM(17),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch18: std543	PORT MAP(
        A	=>D(18),
        B   =>DRAM(18),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch19: std543	PORT MAP(
        A	=>D(19),
        B   =>DRAM(19),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch20: std543	PORT MAP(
        A	=>D(20),
        B   =>DRAM(20),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch21: std543	PORT MAP(
        A	=>D(21),
        B   =>DRAM(21),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch22: std543	PORT MAP(
        A	=>D(22),
        B   =>DRAM(22),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch23: std543	PORT MAP(
        A	=>D(23),
        B   =>DRAM(23),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch24: std543	PORT MAP(
        A	=>D(24),
        B   =>DRAM(24),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch25: std543	PORT MAP(
        A	=>D(25),
        B   =>DRAM(25),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch26: std543	PORT MAP(
        A	=>D(26),
        B   =>DRAM(26),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch27: std543	PORT MAP(
        A	=>D(27),
        B   =>DRAM(27),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch28: std543	PORT MAP(
        A	=>D(28),
        B   =>DRAM(28),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch29: std543	PORT MAP(
        A	=>D(29),
        B   =>DRAM(29),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch30: std543	PORT MAP(
        A	=>D(30),
        B   =>DRAM(30),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );
	Latch31: std543	PORT MAP(
        A	=>D(31),
        B   =>DRAM(31),
        OEBANeg => OE_RAM_30,
        CEBANeg => '0',
        LEBANeg => LE_RAM_30,
        OEABNeg => OE_30_RAM,
        CEABNeg => '0',
        LEABNeg => LE_30_RAM
    );


	SDRAM_LOW: mt48lc16m16a2 PORT MAP(
        BA0 	=> BA(0),
        BA1    => BA(1),
        DQMH   => LDQ0,
        DQML   => UDQ0,
        DQ0    => DRAM(8),
        DQ1    => DRAM(9),
        DQ2    => DRAM(10),
        DQ3    => DRAM(11),
        DQ4    => DRAM(12),
        DQ5    => DRAM(13),
        DQ6    => DRAM(14),
        DQ7    => DRAM(15),
        DQ8    => DRAM(0),
        DQ9    => DRAM(1),
        DQ10   => DRAM(2),
        DQ11   => DRAM(3),
        DQ12   => DRAM(4),
        DQ13   => DRAM(5),
        DQ14   => DRAM(6),
        DQ15   => DRAM(7),
        CLK    => CLK_RAM,
        CKE    => CLK_EN,
        A0     => ARAM(0),
        A1     => ARAM(1),
        A2     => ARAM(2),
        A3     => ARAM(3),
        A4     => ARAM(4),
        A5     => ARAM(5),
        A6     => ARAM(6),
        A7     => ARAM(7),
        A8     => ARAM(8),
        A9     => ARAM(9),
        A10    => ARAM(10),
        A11    => ARAM(11),
        A12    => ARAM(12),
        WENeg  => MEM_WE,
        RASNeg => RAS,
        CSNeg  => '0',
        CASNeg => CAS
		);

	SDRAM_HIGH: mt48lc16m16a2 PORT MAP(
        BA0 	=> BA(0),
        BA1    => BA(1),
        DQMH   => LDQ1,
        DQML   => UDQ1,
        DQ0    => DRAM(24),
        DQ1    => DRAM(25),
        DQ2    => DRAM(26),
        DQ3    => DRAM(27),
        DQ4    => DRAM(28),
        DQ5    => DRAM(29),
        DQ6    => DRAM(30),
        DQ7    => DRAM(31),
        DQ8    => DRAM(16),
        DQ9    => DRAM(17),
        DQ10   => DRAM(18),
        DQ11   => DRAM(19),
        DQ12   => DRAM(20),
        DQ13   => DRAM(21),
        DQ14   => DRAM(22),
        DQ15   => DRAM(23),
        CLK    => CLK_RAM,
        CKE    => CLK_EN,
        A0     => ARAM(0),
        A1     => ARAM(1),
        A2     => ARAM(2),
        A3     => ARAM(3),
        A4     => ARAM(4),
        A5     => ARAM(5),
        A6     => ARAM(6),
        A7     => ARAM(7),
        A8     => ARAM(8),
        A9     => ARAM(9),
        A10    => ARAM(10),
        A11    => ARAM(11),
        A12    => ARAM(12),
        WENeg  => MEM_WE,
        RASNeg => RAS,
        CSNeg  => '0',
        CASNeg => CAS
		);


   -- Clock process definitions 
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   PLL_CLK_process :process
   begin
		PLL_C <= '0';
		wait for CLK_period/4;
		PLL_C <= '1';
		wait for CLK_period/4;
   end process;

   PLL_H_CLK_process :process
   begin
		PLL_C_HALF <= '0';
		wait for CLK_period/2;
		PLL_C_HALF <= '1';
		wait for CLK_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
		A <= (others => '1');
		SIZ <="11";
		RW <='1';
		CBREQ <='1';
		IDE_WAIT <='1';
		nAS  <='1';
		nDS  <='1';
		RESET  <='0';
		ECS  <='1';
		D <= (others => 'Z');
      wait for 10 ns;	
		RESET  <='1';
      wait for CLK_period*100;
		SIZ <="00";
	
		A <= x"08000000";
		wait until rising_edge(CLK);
		D <= x"12345678";
		RW <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		wait until falling_edge(CLK);
		nDS  <='0';
		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		

		A <= x"08000004";
		wait until rising_edge(CLK);
		D <= x"12345679";
		RW <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		wait until falling_edge(CLK);
		nDS  <='0';
		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);


		A <= x"08000008";
		wait until rising_edge(CLK);
		D <= x"1234567A";
		RW <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		wait until falling_edge(CLK);
		nDS  <='0';
		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);

		A <= x"0800000C";
		wait until rising_edge(CLK);
		D <= x"1234567B";
		RW <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		wait until falling_edge(CLK);
		nDS  <='0';
		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);

		A <= x"08000010";
		wait until rising_edge(CLK);
		D <= x"1234567C";
		RW <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		wait until falling_edge(CLK);
		nDS  <='0';
		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);

		A <= x"08000000";
		D <= (others => 'Z');
		RW <='1';
		CBREQ <='0';
		wait until falling_edge(CLK);
		nAS  <='0';
		nDS  <='0';
		wait until falling_edge(CLK);		
		wait until STERM='0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		nAS  <='1';
		nDS  <='1';
		CBREQ <='1';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);


      wait;
   end process;

END;

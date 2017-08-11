--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:51:02 07/21/2017
-- Design Name:   
-- Module Name:   I:/I2C_master/TS_driverTOPtb.vhd
-- Project Name:  I2C_master
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TS_driverTOP
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
USE ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TS_driverTOPtb IS
END TS_driverTOPtb;
 
ARCHITECTURE behavior OF TS_driverTOPtb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TS_driverTOP
    PORT(
         CLK : IN  std_logic;
         GO : IN  std_logic;
         RESET : IN  std_logic;
         TEMPERATURE : OUT  std_logic_vector(15 downto 0);
         TS_EVENT : IN  std_logic;
         SDA : INOUT  std_logic;
         SCL : INOUT  std_logic;
         ALARM : OUT  std_logic;
			button : out STD_LOGIC;
         BUSY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal GO : std_logic := '1';
   signal RESET : std_logic := '1';
   signal TS_EVENT : std_logic := '0';

	--BiDirs
   signal SDA : std_logic:= 'Z';
   signal SCL : std_logic;

 	--Outputs
   signal TEMPERATURE : std_logic_vector(15 downto 0);
   signal ALARM : std_logic;
   signal BUSY : std_logic;
	signal button : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 25 ns;
	constant data_CLK_period : time := 10 us;
	
	signal ack_count : integer:= 0;
	signal count : integer := 0;
	signal addr_reg : std_logic_vector(7 downto 0);
	signal pointer_reg : std_logic_vector(7 downto 0);
	signal dCLK : std_logic; 
	
	--type FSM is (reset, start, address1, rec_point, address2, MSB, LSB, STOP);
	--signal state : FSM:= reset;
	--signal start_count :std_logic := '0'; 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TS_driverTOP PORT MAP (
          CLK => CLK,
          GO => GO,
          RESET => RESET,
          TEMPERATURE => TEMPERATURE,
          TS_EVENT => TS_EVENT,
          SDA => SDA,
          SCL => SCL,
          ALARM => ALARM,
			 button => button,
          BUSY => BUSY
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
   Dclock: process
	begin
		dCLK <= '0';
		wait for data_CLK_period/2;
		dCLK <= '1';
		wait for data_CLK_period/2;
	end process;
	
   -- Stimulus process
   system_stim: process
   begin	
--		if(dCLK'EVENT and dCLK = '1')
--			case state is 
--			when reset =>
--				RESET <= '0'; 
--			   state <= start; 
--			
--			when start =>
--				RESET <= '1';
--				GO <= '0';
--				state <= address1;
--		   
--			when address1 => 
				
     RESET <= '0';
	  SDA <= 'Z';
	  wait until rising_edge(dCLK);
      wait for data_CLK_period;	
		RESET <= '1';
      wait for data_CLK_period*2;
		GO <= '0';
		wait for data_CLK_period;
		Go <= '1';
		wait for data_CLK_period*9;
		SDA <= 'Z';
		wait for data_CLK_period;
		SDA <= 'Z';
		wait for data_CLK_period*8;
		SDA <= 'Z';
		wait for data_CLK_period;
		SDA <= 'Z';
		wait for data_CLK_period*9;
		SDA <= '0';
		wait for data_CLK_period*9;
		SDA <= 'Z';
      wait;
   end process;
	
--	Slave_react: process(SCL, count, ack_count)
--	begin
--		If (SCL'EVENT and SCL = 'Z' and start_count = '1') then
--			If count = 8 then
--				if ack_count < 3 then
--					ack_count <= ack_count + 1;
--				--	SDA <= '0';
--				end if;
--				count <= 0;
--			else
--				count <= count + 1;
--			--	SDA <= 'Z';
--			end if;
--		
--		If (ack_count = 0 or ack_count = 2) then
--			addr_reg(7-count) <= SDA;
--		
--		elsif ack_count = 1  then
--			pointer_reg(7-count) <= SDA;
--		
--		else
--			SDA <= 'Z';
--		end if;	
--	end if;	
--	end process;

END;

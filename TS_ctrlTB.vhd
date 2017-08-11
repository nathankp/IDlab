--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:56:32 07/21/2017
-- Design Name:   
-- Module Name:   I:/I2C_master/TS_ctrlTB.vhd
-- Project Name:  I2C_master
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TS_ctrl
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
 
ENTITY TS_ctrlTB IS
END TS_ctrlTB;
 
ARCHITECTURE behavior OF TS_ctrlTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TS_ctrl
    PORT(
         data_clock : IN  std_logic;
         Go : IN  std_logic;
         pointer : IN  std_logic_vector(7 downto 0);
         mstr_state : IN  std_logic_vector(1 downto 0);
         ack_error : IN  std_logic;
         reset : IN  std_logic;
         data_rd : IN  std_logic_vector(7 downto 0);
         mstr_ena : OUT  std_logic;
        -- reset_mstr : OUT  std_logic;
         rw : OUT  std_logic;
         data_wr : OUT  std_logic_vector(7 downto 0);
         Temperature : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_clock : std_logic := '0';
   signal Go : std_logic := '0';
   signal pointer : std_logic_vector(7 downto 0) := (others => '0');
   signal mstr_state : std_logic_vector(1 downto 0) := (others => '0');
   signal ack_error : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_rd : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal mstr_ena : std_logic;
   signal reset_mstr : std_logic;
   signal rw : std_logic;
   signal data_wr : std_logic_vector(7 downto 0);
   signal Temperature : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant data_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TS_ctrl PORT MAP (
          data_clock => data_clock,
          Go => Go,
          pointer => pointer,
          mstr_state => mstr_state,
          ack_error => ack_error,
          reset => reset,
          data_rd => data_rd,
          mstr_ena => mstr_ena,
          rw => rw,
          data_wr => data_wr,
          Temperature => Temperature
        );

   -- Clock process definitions
   data_clock_process :process
   begin
		data_clock <= '0';
		wait for data_clock_period/2;
		data_clock <= '1';
		wait for data_clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		Go <= '1';	
      reset <= '0';
      wait for 100 ns;	
		reset <= '1';
		mstr_state <= "00";
      wait for data_clock_period*10;
		Go <= '0';
		wait until rising_edge(data_clock);
		wait for data_clock_period*2;
		Go <= '1';
      wait;
   end process;

END;

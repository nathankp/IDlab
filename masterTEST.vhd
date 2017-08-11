--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:39:53 07/24/2017
-- Design Name:   
-- Module Name:   I:/I2C_master/masterTEST.vhd
-- Project Name:  I2C_master
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: i2c_master
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
 
ENTITY masterTEST IS
END masterTEST;
 
ARCHITECTURE behavior OF masterTEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT i2c_master
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         ena : IN  std_logic;
         addr : IN  std_logic_vector(6 downto 0);
         rw : IN  std_logic;
         data_wr : IN  std_logic_vector(7 downto 0);
         slow_clk : OUT  std_logic;
         state_out : BUFFER  std_logic_vector(1 downto 0);
         busy : OUT  std_logic;
         data_rd : OUT  std_logic_vector(7 downto 0);
         ack_error : BUFFER  std_logic;
         sda : INOUT  std_logic;
         scl : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal ena : std_logic := '0';
   signal addr : std_logic_vector(6 downto 0) := "0011000";
   signal rw : std_logic := '0';
   signal data_wr : std_logic_vector(7 downto 0) := "11001100";

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

 	--Outputs
   signal slow_clk : std_logic;
   signal state_out : std_logic_vector(1 downto 0);
   signal busy : std_logic;
   signal data_rd : std_logic_vector(7 downto 0);
   signal ack_error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant slow_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: i2c_master PORT MAP (
          clk => clk,
          reset_n => reset_n,
          ena => ena,
          addr => addr,
          rw => rw,
          data_wr => data_wr,
          slow_clk => slow_clk,
          state_out => state_out,
          busy => busy,
          data_rd => data_rd,
          ack_error => ack_error,
          sda => sda,
          scl => scl
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      reset_n <= '0';
      wait for 100 ns;	
		reset_n <= '1';
      wait for clk_period*10;
		ena <= '1';
		SDA <= 'Z';
		wait for clk_period*8;
		sda <= '0';
		wait for clk_period;
		sda <= 'Z';
		ena <= '0';
		wait for clk_period*8;
		sda <= '0';
		wait for clk_period;
		sda <= 'Z';
   end process;

END;

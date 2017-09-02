----------------------------------------------------------------------------------
-- Company: University of Hawaii at Manoa Instrumentation Developement Lab
-- Engineer: Nathan Park
-- 
-- Create Date:    12:30:46 07/21/2017 
-- Design Name: 
-- Module Name:    TS_driverTOP - Structural 
-- Project Name:   HMB/BMD
-- Target Devices: Spartan6 
-- Tool versions: ISE Design Suite 14.7
-- Description: MCP98244 temperature sensor driver. This version takes in a Go signal, 40 MHz clk, and reads out temperature data/events. i2c master and wrapper. Modify wrapper to adjust functionality. If running at a different input clock, change clock constants in master.   
--
-- Dependencies: 
--
--  Revision 3 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TS_driverTOP is
    Port ( CLK : in  STD_LOGIC; -- 40 MHz clock
           GO : in  STD_LOGIC; -- start signal, negative logic
           RESET : in  STD_LOGIC; --resets i2c master
           TEMPERATURE : out  STD_LOGIC_VECTOR(15 downto 0); --temperature data
	   TS_EVENT : in  STD_LOGIC; -- event signaling temperature limit breeched
           SDA : inout  STD_LOGIC; -- i2c serial data line
           SCL : inout  STD_LOGIC; --i2c serial clock line
           ALARM : out  STD_LOGIC; -- alarm to outside system that temperature limit is breeched.
           BUSY : out  STD_LOGIC; -- notify outside system a transaction is taking place between driver and sensor.
	   );
        end TS_driverTOP;

architecture Structural of TS_driverTOP is
	-- sends commands to the i2c master
	component TS_CTRL
		Port(
		    data_clock : in  STD_LOGIC; --divided clock from master, keep controller and master synced
           	    Go : in  STD_LOGIC; --from TOP initiate communication with sensor
           	    pointer : in  STD_LOGIC_VECTOR(7 downto 0); -- sensor registor pointer 
           	    mstr_state : in  STD_LOGIC_VECTOR (1 downto 0); --state of transaction from master
	            ack_error  : in  STD_LOGIC; --from master acknowledge error
           	    reset : in  STD_LOGIC; -- reset from TOP  
           	    data_rd : in  STD_LOGIC_VECTOR(7 downto 0); --read data byte from master
	            ----master controls---
		    mstr_ena : BUFFER  STD_LOGIC; --enable/disable master 
           	    rw : out  STD_LOGIC; --read/write command bit.
		    data_wr : out STD_LOGIC_VECTOR(7 downto 0); -- byte of data to write to slave 
		     ---Temperature data output----
	            Temperature : out  STD_LOGIC_VECTOR(15 downto 0) --full temperature
           );
		 end component;
	
	component i2c_master 
	 GENERIC(
		input_clk : INTEGER := 40_000_000; --input clock speed from user logic in Hz
		bus_clk   : INTEGER := 100_000);   --speed the i2c bus (scl) will run at in Hz 
		PORT(
			  clk       : IN     STD_LOGIC;                    --system clock
			  reset_n   : IN     STD_LOGIC;                    --active low reset
			  ena       : IN     STD_LOGIC;                    --latch in command
			  addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
			  rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
			  data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave from TS_CTRL
			  slow_clk  : OUT 	  STD_LOGIC;               -- divided clock
			  state_out : BUFFER	  STD_LOGIC_VECTOR (1 DOWNTO 0); --state of transaction 
			  busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
			  data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
			  ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
			  sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
			  scl       : INOUT  STD_LOGIC                     --serial clock output of i2c bus
			 );
		end component;
--Chipscope cores (debugging purposes)---		
component ILA_core
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    TRIG1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component ILA_CONTROL
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
end component;
	
 signal data_tx : std_logic_vector(7 downto 0);
 signal data_rx : std_logic_vector(7 downto 0);
 signal mstr_ena_w : std_logic;
 signal rw_w : std_logic;
 signal addr_w : std_logic_vector (6 downto 0):= "0011000";
 signal slow_clk_w : std_logic;
 signal state_w : std_logic_vector(1 downto 0);
 signal pointer_w : std_logic_vector (7 downto 0):= "00000101";
 signal ack_error_w : std_logic;
 signal temp_reg  : std_logic_vector(15 downto 0);
 signal ICONTROL : STD_LOGIC_VECTOR(35 DOWNTO 0); --for chipscope (debugging purposes)

begin
 COMMANDER : TS_ctrl port map(
	   data_clock => slow_clk_w,
		Go => GO,
		pointer => pointer_w,
		mstr_state => state_w,
		reset => RESET,
		data_rd => data_rx,
		ack_error => ack_error_w,
		mstr_ena => mstr_ena_w,
		rw => rw_w,
		data_wr => data_tx,
		Temperature => temp_reg);
		
 MASTER: i2c_master port map(
		clk => CLK,
		reset_n => RESET,
		ena => mstr_ena_w,
		addr => addr_w,
		rw => rw_w,
		data_wr => data_tx,
		slow_clk => slow_clk_w,
		state_out => state_w,
		busy => BUSY,
		data_rd => data_rx,
		ack_error => ack_error_w,
		sda => SDA,
		SCL => SCL);
--chip scope instantiations (debugging purposes) 		
chipscope_triggerList: ILA_core  
  port map (
    CONTROL => ICONTROL,
    CLK => CLK,
    TRIG0(0) => CLK,
	 TRIG0(1) => SDA,
	 TRIG0(2) => SCL,
	 TRIG1(0) => state_w(0),
	 TRIG1(1) => state_w(1),
	 TRIG1(2) => GO,
    TRIG1(3) => mstr_ena_w,  
	 TRIG1(4) => temp_reg(15),
	 TRIG1(5) => temp_reg(14),
	 TRIG1(6) => temp_reg(13),
	 TRIG1(7) => temp_reg(12));
 
 ILA_controller : ILA_CONTROL
  port map (
    CONTROL0 => ICONTROL)
--event and temperature read out---	  
Alarm <= TS_EVENT;
TEMPERATURE <= temp_reg;
end Structural;


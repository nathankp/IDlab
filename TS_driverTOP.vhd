----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:46 07/21/2017 
-- Design Name: 
-- Module Name:    TS_driverTOP - Structural 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TS_driverTOP is
    Port ( CLK : in  STD_LOGIC;
           GO : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           TEMPERATURE : out  STD_LOGIC_VECTOR(15 downto 0);
			  TS_EVENT : in  STD_LOGIC;
           SDA : inout  STD_LOGIC;
           SCL : inout  STD_LOGIC;
           ALARM : out  STD_LOGIC;
           BUSY : out  STD_LOGIC;
			  --temp debug start button---
			  button : out STD_LOGIC
			  );
end TS_driverTOP;

architecture Structural of TS_driverTOP is
	component TS_CTRL
		Port(
			  data_clock : in  STD_LOGIC; --divided clock from master, keep controller and master synced
           Go : in  STD_LOGIC; --from TOP initiate communication with sensor
           pointer : in  STD_LOGIC_VECTOR(7 downto 0); 
           mstr_state : in  STD_LOGIC_VECTOR (1 downto 0); --where along the transaction is the master?
			  ack_error  : in  STD_LOGIC; --from master acknowledge error
           reset : in  STD_LOGIC; -- reset from TOP  
           data_rd : in  STD_LOGIC_VECTOR(7 downto 0); --read data byte from master
			  ----master controls---
			  mstr_ena : BUFFER  STD_LOGIC; --enable/disable master 
           rw : out  STD_LOGIC; --read/write command bit.
			  data_wr : out STD_LOGIC_VECTOR(7 downto 0);
			  ---data output----
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
			  data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
			  slow_clk  : OUT 	  STD_LOGIC;						  -- (REVISION: ADDED slowed clock to run controller on)
			  state_out : BUFFER	  STD_LOGIC_VECTOR (1 DOWNTO 0); -- (REVISION: ADDED state output to contoller)
			  busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
			  data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
			 -- sda_reg   : OUT	  STD_LOGIC_VECTOR(7 DOWNTO 0); --temporary, to check if correct bytes are being sent
			  ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
			  sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
			  scl       : INOUT  STD_LOGIC                     --serial clock output of i2c bus
			 );
		end component;
		
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
 --signal reset_mstr_w : std_logic;
 signal rw_w : std_logic;
 signal addr_w : std_logic_vector (6 downto 0):= "0011000";
 signal slow_clk_w : std_logic;
 signal state_w : std_logic_vector(1 downto 0);
 signal pointer_w : std_logic_vector (7 downto 0):= "00000101";
 signal ack_error_w : std_logic;
 signal temp_reg  : std_logic_vector(15 downto 0);
 signal ICONTROL : STD_LOGIC_VECTOR(35 DOWNTO 0);
 --signal SDA_regw : std_logic_vector(7 downto 0):= (others => '0');
 --signal reset_w : std_logic; 
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
		--sda_reg => sda_regW,
		sda => SDA,
		SCL => SCL);
		

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
    CONTROL0 => ICONTROL);

Alarm <= TS_EVENT;
TEMPERATURE <= temp_reg;
button <= (not Go) or (not RESET);
--reset_driver: process(CLK)
--begin
--If (CLK'EVENT and CLK = '1') then
--  reset_w <= RESET and(not ack_error_w);        
--end if;
--end process;	
end Structural;


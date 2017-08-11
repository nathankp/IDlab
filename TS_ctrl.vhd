----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:49 07/21/2017 
-- Design Name: 
-- Module Name:    TS_ctrl - Behavioral 
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

entity TS_ctrl is
    Port (
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
			  Temperature : out  STD_LOGIC_VECTOR(15 downto 0) --full temperature reading
           );
end TS_ctrl;

architecture Behavioral of TS_ctrl is
signal MSB : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal LSB : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
begin

Process(data_clock)
begin
if (reset <= '0') then
	mstr_ena <= '0'; --disable master 
	MSB <= (others => '0');
	LSB <= (others => '0');
elsif (data_clock'EVENT and data_clock = '1') then 
  case mstr_state is
	when "00" =>
		data_wr <= pointer;
		rw <= '0';
		IF (Go = '0' or mstr_ena = '1') then --if Go button is pushed down or mstr has been enabled.
			mstr_ena <= '1';
		ELSE
			mstr_ena <= '0';
		END IF;

	when "01" =>
		rw <= '1';
	
	when "10" =>
		MSB <= data_rd;
		
	when "11" =>
		LSB <= data_rd;
		mstr_ena <= '0';
	when others =>
		NULL;
	END CASE;

 END IF;
END process;

temp_rdOUT: process(reset, LSB) 
begin
	if reset  = '0' then
		Temperature <= (others => '0');
	else
		Temperature <= MSB & LSB;
	end if;
end process;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY asynch_ram IS
    PORT (
        data_in  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        address  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        wr       : IN  STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END asynch_ram;

ARCHITECTURE rtl OF asynch_ram IS
    TYPE MEM IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ram_block : MEM;
BEGIN
    PROCESS (wr, data_in, address)
    BEGIN
        IF (wr = '1') THEN -- wr : write enable, wr = '1' : write 
            ram_block(to_integer(unsigned(address))) <= data_in;
        END IF;
        data_out <= ram_block(to_integer(unsigned(address)));
    END PROCESS;
END rtl;
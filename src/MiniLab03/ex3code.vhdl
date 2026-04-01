library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex3code is
    port (clk : in std_logic;
        bcd_code : in std_logic_vector(3 downto 0);
        ex3_code: out std_logic_vector(3 downto 0) );
end ex3code;

architecture sample of ex3code is

type ROM is array(0 to 15) of std_logic_vector(3 downto 0);
constant rom_example: ROM := ("0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111", "0000", "0001", "0010");

begin
    process(Clk)
    begin
        if rising_edge(Clk) then
        ex3_code <= rom_example(to_integer(unsigned(bcd_code)));
        end if;
    end process;
end sample;

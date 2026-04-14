-- rom_example.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_example is
    port (
        clock   : in  std_logic;
        address : in  std_logic_vector(3 downto 0);
        q       : out std_logic_vector(3 downto 0)
    );
end rom_example;

architecture sample of rom_example is
    type ROM is array(0 to 15) of std_logic_vector(3 downto 0);
    constant rom_data : ROM := (
        "0011", "0100", "0101", "0110", "0111",
        "1000", "1001", "1010", "1011", "1100",
        "1101", "1110", "1111", "0000", "0001",
        "0010"
    );
begin
    process(clock)
    begin
        if rising_edge(clock) then
            q <= rom_data(to_integer(unsigned(address)));
        end if;
    end process;
end sample;
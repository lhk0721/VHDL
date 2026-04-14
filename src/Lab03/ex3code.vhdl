-- ex3code
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex3code is
    port (
        clk      : in  std_logic;
        bcd_code : in  std_logic_vector(3 downto 0);
        ex3_code : out std_logic_vector(3 downto 0)
    );
end ex3code;

architecture structural of ex3code is
    component rom_example
        port (
            address : in  std_logic_vector(3 downto 0);
            clock   : in  std_logic;
            q       : out std_logic_vector(3 downto 0)
        );
    end component;
begin
    rom_example_inst : rom_example port map (
        address => bcd_code,
        clock   => clk,
        q       => ex3_code
    );
end structural;
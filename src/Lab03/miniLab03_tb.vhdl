library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity miniLab03_tb is
end miniLab03_tb;

architecture sim of miniLab03_tb is

    component rom_miniLab03
        port (
            clock   : in std_logic;
            address : in  std_logic_vector(2 downto 0);
            q       : out std_logic_vector(3 downto 0)
        );
    end component;

    signal address : std_logic_vector(2 downto 0) := "000";
    signal q       : std_logic_vector(3 downto 0);

begin
    uut : miniLab03 port map(
        clock   => clk,
        address => address,
        q       => q
    );

    process
    begin
        address <= "000"; wait for 50 ns;
        address <= "001"; wait for 50 ns;
        address <= "010"; wait for 50 ns;
        address <= "011"; wait for 50 ns;
        address <= "100"; wait for 50 ns;
        address <= "101"; wait for 50 ns;
        address <= "110"; wait for 50 ns;
        address <= "111"; wait for 50 ns;

        wait;
    end process;

end sim;
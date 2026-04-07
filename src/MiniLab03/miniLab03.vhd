-- miniLab03.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity
entity miniLab03 is
    port (
        clk      : in  std_logic;
        address  : in  std_logic_vector(2 downto 0);
        q        : out std_logic_vector(3 downto 0)
    );
end miniLab03;

-- architectrue
architecture structural of miniLab03 is
    component rom_miniLab03
    port (
            clk      : in  std_logic;
			address  : in  std_logic_vector(2 downto 0);
			q        : out std_logic_vector(3 downto 0)
    );
    end component;
begin
    rom_miniLab03_inst : rom_miniLab03 port map(
        clk => clk,
        address => address,
        q => q
    );
end structural;
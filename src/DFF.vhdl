library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is
    Port (
        clk : in  STD_LOGIC;
        d   : in  STD_LOGIC;
        q   : out STD_LOGIC
    );
end DFF;

architecture Behavioral of DFF is
    signal master_q : STD_LOGIC;
begin

    -- Master D latch (enable = not clk)
    process(clk, d)
    begin
        if clk = '0' then
            master_q <= d;
        end if;
    end process;

    -- Slave D latch (enable = clk)
    process(clk, master_q)
    begin
        if clk = '1' then
            q <= master_q;
        end if;
    end process;

end Behavioral;
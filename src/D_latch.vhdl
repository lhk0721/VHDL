library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_latch is
    port (
        en: in std_logic;
        d: in std_logic;
        q: out std_logic
    );
end D_latch;

architecture Behavioral of D_latch is
begin
    process(en,d)
    begin   
        if en = '1' then
            q <= d;
        end if;
    end process;

end Behavioral;
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modMCounter_tb is
end modMCounter_tb;


architecture arch of modMCounter_tb is
    constant M : integer := 3;  -- count upto 2 (i.e. 0 to 2)
    constant N : integer := 4;
    constant T : time := 100 ns; 

    signal clk, reset : std_logic;  -- input
    signal complete_tick : std_logic; -- output
    signal count : std_logic_vector(N-1 downto 0);  -- output

    -- total samples to store in file
    constant num_of_clocks : integer := 30; 
    signal i : integer := 0; -- loop variable
    
    begin

        modMCounter_unit : entity work.modMCounter
            generic map (M => M, N => N)
            port map (clk=>clk, reset=>reset, complete_tick=>complete_tick,
                        count=>count);
    
        -- reset = 1 for first clock cycle and then 0
        reset <= '1', '0' after T/2;
    
        -- continuous clock
        process 
        begin
            clk <= '0';
            wait for T/2;
            clk <= '1';
            wait for T/2;
    
            -- run 30 clocks
            if (i = num_of_clocks) then
                wait;
            else
                i <= i + 1;
            end if;
        end process;
    end arch;
    
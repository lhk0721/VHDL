library ieee;
use ieee.std_logic_1164.all;

entity simple_SSL_tb is
end entity simple_SSL_tb;

architecture arch of simple_SSL_tb is
    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';

    signal and_in   : std_logic_vector(1 downto 0);

    alias in_a is and_in(0);
    alias in_b is and_in(1);
    signal out_q    : std_logic;

    constant T      : time := 100 ns;
    signal finished : std_logic := '0';

begin

    -- Instantiate the design under test
    dut: entity work.simple_SSL
        port map (
            clk   => clock,
            reset => reset,
            a     => in_a,
            b     => in_b,
            q     => out_q
        );

    -- Reset and clock
    clock <= not clock after T / 2 when finished /= '1' else '0';
    reset <= '1', '0' after 50 ns;

    -- Generate the test stimulus
    stimulus: process
    begin
        finished <= '0';

        -- Wait for the Reset to be released before
        wait until (reset = '0');

        -- Generate each input in turn, waiting 2 clock periods between
        -- each iteration to allow for propagation times
        and_in <= "00";
        wait for 2 * T;
        and_in <= "01";
        wait for 2 * T;
        and_in <= "10";
        wait for 2 * T;
        and_in <= "11";
        wait for 2 * T;

        -- Testing complete
        finished <= '1';
        wait;
    end process stimulus;

end architecture arch;

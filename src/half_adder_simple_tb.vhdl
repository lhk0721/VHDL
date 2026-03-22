library ieee;
use ieee.std_logic_1164.all;


entity half_adder_simple_tb is
end half_adder_simple_tb;

architecture tb of half_adder_simple_tb is
    signal a, b : std_logic;  -- inputs
    signal sum, carry : std_logic;  -- outputs

begin
    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);
    -- half_adder and the TB must be in the same directory

    STIM: process -- unsynthetizeable part
        constant period: time := 50 ns;
    begin
        a <= '0';
        b <= '0';
        wait for period;
        assert ((sum = '0') and (carry = '0'))  -- expected output
        -- error will be reported if sum or carry is not 0
        report "test failed for input combination 00" severity error;

        a <= '0';
        b <= '1';
        wait for period;
        assert ((sum = '1') and (carry = '0'))
        report "test failed for input combination 01" severity error;

        a <= '1';
        b <= '0';
        wait for period;
        assert ((sum = '1') and (carry = '0'))
        report "test failed for input combination 10" severity error;

        a <= '1';
        b <= '1';
        wait for period;
        assert ((sum = '0') and (carry = '1'))
        report "test failed for input combination 11" severity error;

        -- Fail test
        a <= '0';
        b <= '1';
        wait for period;
        assert ((sum = '0') and (carry = '1'))
        report "test failed for input combination 01 (fail test)" severity error;

        wait; -- indefinitely suspend process (Required to process without sensitivity list )
    end process;
end tb;

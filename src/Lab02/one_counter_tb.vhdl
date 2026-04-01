library ieee;
use ieee.std_logic_1164.all;

entity one_counter_tb is
end one_counter_tb;

architecture tb of one_counter_tb is
    -- inputs
    signal clk, reset_n : std_logic;
    signal A : std_logic_vector(7 downto 0);
    signal Load_A, S : std_logic;

    -- outputs
    signal B : std_logic_vector(3 downto 0);
    signal Done : std_logic;
begin
    UUT: entity work.one_counter port map(
        clk => clk,
        reset_n => reset_n,
        A => A,
        Load_A => Load_A,
        S => S,
        B => B,
        Done => Done
    );

    CLK_GEN: process
        constant period : time := 50 ns;
    begin
        while true loop
            clk <= '0';
            wait for period/2;
            clk <= '1';
            wait for period/2;
        end loop;
    end process;

    STIM: process
        constant period : time := 50 ns;
    begin
        -- ===== scenario 1 =====
        -- t0 / reset
        reset_n <= '0';
        Load_A <= '0';
        S <= '0';
        A <= "10110101"; -- 1+0+1+1+0+1+0+1 = 5 ones
        wait for period;

        -- t1 / state = IDLE
        reset_n <= '1';
        Load_A <= '1';
        wait for period;

        -- t2 / state = LOAD
        Load_A <= '0';
        S <= '1';
        wait for period;

        -- t3~t12 / state = SHIFT (1 cycle load + 8 shifts + 1 done detect + 1 DONE_ST)
        S <= '0';
        wait for 11*period;

        -- t13 / state = DONE_ST
        assert(Done = '1')
            report "test failed for input combination 01 (Done should be 1 at t13)"
            severity error;
        assert(B = "0101")
            report "test failed for input combination 01 (B should be 5 for input 10110101)"
            severity error;
        wait for period;


        -- ===== scenario 2 =====
        -- t0 / reset
        reset_n <= '0';
        Load_A <= '0';
        S <= '0';
        A <= "00000000"; -- 0 ones
        wait for period;

        -- t1 / state = IDLE
        reset_n <= '1';
        Load_A <= '1';
        wait for period;

        -- t2 / state = LOAD
        Load_A <= '0';
        S <= '1';
        wait for period;

        -- t3~t12 / state = SHIFT
        S <= '0';
        wait for 11*period;

        -- t13 / state = DONE_ST
        assert(Done = '1')
            report "test failed for input combination 02 (Done should be 1 at t13)"
            severity error;
        assert(B = "0000")
            report "test failed for input combination 02 (B should be 0 for input 00000000)"
            severity error;
        wait for period;


        -- ===== scenario 3 =====
        -- t0 / reset
        reset_n <= '0';
        Load_A <= '0';
        S <= '0';
        A <= "11111111"; -- 8 ones
        wait for period;

        -- t1 / state = IDLE
        reset_n <= '1';
        Load_A <= '1';
        wait for period;

        -- t2 / state = LOAD
        Load_A <= '0';
        S <= '1';
        wait for period;

        -- t3~t12 / state = SHIFT
        S <= '0';
        wait for 11*period;

        -- t13 / state = DONE_ST
        assert(Done = '1')
            report "test failed for input combination 03 (Done should be 1 at t13)"
            severity error;
        assert(B = "1000")
            report "test failed for input combination 03 (B should be 8 for input 11111111)"
            severity error;
        wait for period;


        -- ===== scenario 4 =====
        -- t0 / reset output check
        reset_n <= '0';
        Load_A <= '0';
        S <= '0';
        A <= "10101010";
        wait for 1 ns; --stabilizing

        assert(Done = '0')
            report "test failed for input combination 04 (Done should be 0 during reset)"
            severity error;
        assert(B = "0000")
            report "test failed for input combination 04 (B should be cleared during reset)"
            severity error;
        wait for period;


        -- ===== scenario 5 =====
        -- Load_A와 S를 동시에 인가했을 때 정상 동작 확인
        -- t0 / reset
        reset_n <= '0';
        Load_A <= '0';
        S <= '0';
        A <= "01010101"; -- 0+1+0+1+0+1+0+1 = 4 ones
        wait for period;

        -- t1 / state = IDLE, Load_A and S asserted simultaneously
        reset_n <= '1';
        Load_A <= '1';
        S <= '1';
        wait for period;

        -- t2 / state = LOAD, S still high -> immediate transition to SHIFT
        Load_A <= '0';
        wait for period;

        -- t3~t12 / state = SHIFT
        S <= '0';
        wait for 11*period;

        -- t13 / state = DONE_ST
        assert(Done = '1')
            report "test failed for input combination 05 (Done should be 1 at t13)"
            severity error;
        assert(B = "0100")
            report "test failed for input combination 05 (B should be 4 for input 01010101)"
            severity error;
        wait for period;


        wait; -- for suspension purpose
    end process;
end tb;

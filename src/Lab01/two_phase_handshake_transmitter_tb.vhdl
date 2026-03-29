library ieee;
use ieee.std_logic_1164.all;

entity two_phase_handshake_transmitter_tb is
end two_phase_handshake_transmitter_tb;

architecture tb of two_phase_handshake_transmitter_tb is
    -- inputs
    signal clk, reset_n, ready, ack : std_logic;
    signal Data_to_send : std_logic_vector(7 downto 0);
    signal load : std_logic; -- for verivication purpose

    -- outputs
    signal req: std_logic;
    signal Data : std_logic_vector(7 downto 0);

    -- virtual input
    signal prev_req : std_logic;
begin
    UUT: entity work.two_phase_handshake_transmitter port map(
        load => load,
        clk => clk,
        reset_n => reset_n,
        ready => ready,
        ack => ack,
        Data_to_send => Data_to_send,
        req => req,
        Data => Data
    );

    CLK_GEN: process
        constant period: time := 50 ns;
    begin
        while true loop
            clk <= '0';
            wait for period/2;
            clk <= '1';
            wait for period/2;
        end loop;
    end process;

    STIM: process
        constant period: time := 50 ns;
    begin
        -- ===== scenario 1 =====
        -- t0 / reset
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "10101010";
        wait for period;

        -- t1 / state = "00"
        reset_n <= '1';
        ready <= '1';
        wait for period;

        -- t2 / state = "01"
        wait for period;

        -- t3 / state = "10"
        assert(load = '1')
            report "test failed for input combination 01 (load should be 1 at t3)"
            severity error; 
        prev_req <= req;
        wait for period;
        wait for 1 ns; --stabilizing

        assert(load = '0')
            report "test failed for input combination 01 (load should return to 0 after one clock pulse)"
            severity error;

        -- t4 / state = "11"
        assert(req /= prev_req)
            report "test failed for input combination 01 (req should toggle at t4)"
            severity error;
        ack <= req;
        wait for period;

        -- t5 / state = "00"
        assert(ack = req)
            report "test failed for input combination 01 (ack should match req at t5)"
            severity error;
        assert(Data = Data_to_send)
            report "test failed for input combination 01 (Data should match Data_to_send at t5)"
            severity error;


        -- ===== scenario 2 =====
        -- t0 / reset
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "00101100";
        wait for period;

        reset_n <= '1';
        ready <= '0';
        wait for 2*period;

        prev_req <= req;
        wait for period;

        assert(req = prev_req)
            report "test failed for input combination 02 (req should not toggle when ready is 0)"
            severity error;

        -- ===== scenario 3 =====
        -- t0 / reset
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "11101111";
        wait for period;

        -- t1 / state = "00"
        reset_n <= '1';
        ready <= '1';
        wait for period;

        -- t2 / state = "01"
        wait for period;

        -- t3 / state = "10"
        assert(load = '1')
            report "test failed for input combination 03 (load should be 1 at t3)"
            severity error;
        prev_req <= req;
        wait for period;

        assert(req /= prev_req)
            report "test failed for input combination 03 (req should toggle before delayed ack)"
            severity error;
        -- delegate ack delay
        wait for 3*period;
        ack <= req;
        wait for period;

        assert(ack = req)
            report "test failed for input combination 03 (ack should match req after delayed handshake)"
            severity error;
        assert(Data = Data_to_send)
            report "test failed for input combination 03 (Data should match Data_to_send after delayed handshake)"
            severity error;


        -- ===== scenario 4 =====
        -- t0 / reset output check
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "00000000";
        wait for 1 ns;

        assert(req = '0')
            report "test failed for input combination 04 (req should be 0 during reset)"
            severity error;
        assert(load = '0')
            report "test failed for input combination 04 (load should be 0 during reset)"
            severity error;
        assert(Data = "00000000")
            report "test failed for input combination 04 (Data should be cleared during reset)"
            severity error;
        wait for period;


        -- ===== scenario 5 =====
        -- t0 / reset
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "11000011";
        wait for period;

        -- t1 / state = "00"
        reset_n <= '1';
        ready <= '1';
        wait for period;

        -- t2 / state = "01"
        wait for period;

        -- t3 / first transmission, state = "10"
        assert(load = '1')
            report "test failed for input combination 05 (first transfer should assert load)"
            severity error;
        prev_req <= req;
        wait for period;
        wait for 1 ns;

        -- t4 / first transmission, state = "11"
        assert(req /= prev_req)
            report "test failed for input combination 05 (first transfer should toggle req)"
            severity error;
        ack <= req;
        wait for period;

        -- t5 / first transmission complete, state = "00"
        assert(Data = "11000011")
            report "test failed for input combination 05 (first transfer data mismatch)"
            severity error;

        -- t6 / prepare second transmission
        Data_to_send <= "00110011";
        ack <= req;
        ready <= '1';
        wait for period;

        -- t7 / state = "01"
        wait for period;

        -- t8 / second transmission, state = "10"
        assert(load = '1')
            report "test failed for input combination 05 (second transfer should assert load)"
            severity error;
        prev_req <= req;
        wait for period;
        wait for 1 ns;

        -- t9 / second transmission, state = "11"
        assert(req /= prev_req)
            report "test failed for input combination 05 (second transfer should toggle req)"
            severity error;
        ack <= req;
        wait for period;

        -- t10 / second transmission complete, state = "00"
        assert(Data = "00110011")
            report "test failed for input combination 05 (second transfer data mismatch)"
            severity error;


        -- ===== scenario 6 =====
        -- t0 / reset
        reset_n <= '0';
        ack <= '0';
        ready <= '0';
        Data_to_send <= "01010101";
        wait for period;

        -- t1 / state = "00"
        reset_n <= '1';
        ready <= '1';
        wait for period;

        -- t2 / state = "01"
        wait for period;

        -- t3 / state = "10"
        assert(load = '1')
            report "test failed for input combination 06 (load should rise for one clock)"
            severity error;
        wait for period;
        wait for 1 ns;

        -- t4 / state = "11"
        assert(load = '0')
            report "test failed for input combination 06 (load should fall after one clock)"
            severity error;


        wait; -- for suspension purpose
    end process;
end tb;

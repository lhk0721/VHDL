LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY lab_06_top_tb IS
END lab_06_top_tb;

architecture sim of lab_06_top_tb is
    signal clk : std_logic := '0';
    signal reset_n : std_logic := '1';
    signal Enable : std_logic := '0';
    signal dp_out : std_logic_vector(3 downto 0) :="0000";
    signal i : std_logic_vector(3 downto 0):="0000";
    
    signal load : std_logic := '0';
    signal clear : std_logic := '0';
    signal out_sel : std_logic := '0';
    signal iNOT10 : std_logic := '0';
    
    constant clk_period : time := 50 ns;
    
begin

    UUT : entity lab_06_top port map(
        clk => clk,
        reset_n => reset_n,
        Enable => Enable,
        dp_out => dp_out,
        i => i
    );

    CLK_GEN : process
    begin
        clk <= '0'; WAIT FOR clk_period / 2;
        clk <= '1'; WAIT FOR clk_period / 2;
    end process;

    STIM : process
    begin

        -- == line 0. reset ==
        load <= '1'
        clear <= '1'
        out_sel <= '1'
        reset_n <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert(load = '0' && clear = '0' && out_sel = '0')
            report "reset failed."
            severity error;

        -- == line 1. "i = 0" ==
        clear <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert(i = "0000")
            report "i Initiation failed "
            severity error;

        -- == line 2. increment ==
        Enable = '1'

        wait until rising_edge(clk);
        wait for 1 ns;

        assert(i = "0000")
            report "i incrementation failed"
            severity error;

        assert(clear = '1')
            report "i incrementation failed"
            severity error;
            
        -- == line 3. output i ==
        wait until (iNOT10 = '0');
        wait for 1 ns;

        assert(dp_out = '1010')
            report "dp_out isn't 1010"
            severity error;
    
        WAIT
    end process;

end sim;
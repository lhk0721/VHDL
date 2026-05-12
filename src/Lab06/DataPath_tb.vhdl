LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY lab_06_dp_tb IS
END lab_06_dp_tb;

architecture sim of lab_06_dp_tb is

    signal clk : std_logic := '0';
    signal load : std_logic := '0';
    signal clear : std_logic := '0';
    signal out_sel : std_logic := '0';
    
    signal iNOT10 : std_logic := '0';
    signal dp_out : std_logic_vector(3 downto 0) := "0000";
    signal i : std_logic_vector(3 downto 0) := "0000";

    constant clk_period : time := 50 ns;

begin
    UUT : Entity work.lab_06_dp port map(
        clk => clk,
        load => load,
        clear => clear,
        out_sel => out_sel,
        iNOT10 => iNOT10,
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

        -- == line 1. "i = 0" ==
        load <= '0';
        clear <= '1';
        out_sel <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert(i = "0000")
            report "reset failed: i should be 0000"
            severity error;
        
        -- == line 2. "i = i + 1" ==
        -- step 1. "0 = 0 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';


        assert(i = "0000")
            report "i should be 0000"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 2. "2 = 1 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';

        
        assert(i = "0001")
            report "i should be 0001"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;
        
        -- step 3. "3 = 2 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';


        assert(i = "0010")
            report "i should be 0010"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 4. "4 = 3 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';


        assert(i = "0011")
            report "i should be 0011"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 5. "5 = 4 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';


        assert(i = "0100")
            report "i should be 0100"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 6. "6 = 5 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';
        
        assert(i = "0101")
            report "i should be 0101"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 7. "7 = 6 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';
        
        assert(i = "0110")
            report "i should be 0110"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 8. "8 = 7 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';
        
        assert(i = "0111")
            report "i should be 0111"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 9. "9 = 8 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';
        
        assert(i = "1000")
            report "i should be 1000"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- step 10. "10 = 9 + 1"
        load <= '1';
        clear <= '0';
        out_sel <= '0';
        
        assert(i = "1001")
            report "i should be 1001"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        assert(i = "1010")
            report "i should be 1010"
            severity error;

        assert(iNOT10 = '0')
            report "iNOT10 should be 0 when i is 10"
            severity error;

        -- == line 3. ==
        load <= '0';
        clear <= '0';
        out_sel <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert(dp_out = "1010")
            report "dp_out should be 1010"
            severity error;

        wait;
    end process;
end sim;
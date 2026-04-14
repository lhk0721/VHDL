LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ram_based_datapath_tb IS
END ram_based_datapath_tb;

ARCHITECTURE sim OF ram_based_datapath_tb IS

    SIGNAL clock    : STD_LOGIC := '0';
    SIGNAL reset_n  : STD_LOGIC := '0';
    SIGNAL input    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    SIGNAL mux_sel  : STD_LOGIC := '0';
    SIGNAL ac_load  : STD_LOGIC := '0';
    SIGNAL alu_sel  : STD_LOGIC_VECTOR(2 downto 0) := "000";
    SIGNAL mar_in   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    SIGNAL mar_load     : STD_LOGIC := '0';
    SIGNAL ram_load     : STD_LOGIC := '0';
    SIGNAL output       : STD_LOGIC_VECTOR(3 downto 0);
    -- debug signals
    SIGNAL dbg_alu_out  : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL dbg_mux_out  : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL dbg_mar_out  : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL dbg_ram_out  : STD_LOGIC_VECTOR(3 downto 0);

    CONSTANT clk_period : time := 20 ns;

BEGIN

    UUT : ENTITY work.ram_based_datapath PORT MAP (
        clock       => clock,
        reset_n     => reset_n,
        input       => input,
        mux_sel     => mux_sel,
        ac_load     => ac_load,
        alu_sel     => alu_sel,
        mar_in      => mar_in,
        mar_load    => mar_load,
        ram_load    => ram_load,
        output      => output,
        dbg_alu_out => dbg_alu_out,
        dbg_mux_out => dbg_mux_out,
        dbg_mar_out => dbg_mar_out,
        dbg_ram_out => dbg_ram_out
    );

    CLK_GEN : PROCESS
    BEGIN
        clock <= '0'; WAIT FOR clk_period / 2;
        clock <= '1'; WAIT FOR clk_period / 2;
    END PROCESS;

    STIM : PROCESS
    BEGIN

        -- ===== reset =====
        reset_n <= '0';
        WAIT UNTIL rising_edge(clock);
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        assert(output = "0000")
            report "Reset failed: output should be 0000"
            severity error;

        reset_n <= '1';
        WAIT FOR 1 ns;


        -- ===== step 1 : ac <= input (3) =====
        input   <= "0011";
        mux_sel <= '0';
        ac_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        ac_load <= '0';

        assert(output = "0011")
            report "Step1 failed: AC should be 0011 (3)"
            severity error;
        assert(dbg_mux_out = "0011")
            report "Step1 failed: mux_out should be 0011 (3)"
            severity error;


        -- ===== step 2 : M[2] <= ac =====
        -- 2a: set MAR = 2
        mar_in   <= "010";
        mar_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        mar_load <= '0';

        assert(dbg_mar_out = "010")
            report "Step2 failed: MAR should be 010 (2)"
            severity error;

        -- 2b: alu_sel=000 passes ac_out through ALU -> write to RAM[2]
        alu_sel  <= "000";
        ram_load <= '1';
        WAIT FOR clk_period;

        ram_load <= '0';
        WAIT FOR 1 ns;

        assert(dbg_alu_out = "0011")
            report "Step2 failed: alu_out should be 0011 (3) during write"
            severity error;
        assert(dbg_ram_out = "0011")
            report "Step2 failed: RAM[2] should hold 0011 (3)"
            severity error;


        -- ===== step 3 : ac <= input (2) =====
        input   <= "0010";
        mux_sel <= '0';
        ac_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        ac_load <= '0';

        assert(output = "0010")
            report "Step3 failed: AC should be 0010 (2)"
            severity error;


        -- ===== step 4 : M[1] <= ac =====
        -- 4a: set MAR = 1
        mar_in   <= "001";
        mar_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        mar_load <= '0';

        assert(dbg_mar_out = "001")
            report "Step4 failed: MAR should be 001 (1)"
            severity error;

        -- 4b: write to RAM[1]
        alu_sel  <= "000";
        ram_load <= '1';
        WAIT FOR clk_period;

        ram_load <= '0';
        WAIT FOR 1 ns;

        assert(dbg_alu_out = "0010")
            report "Step4 failed: alu_out should be 0010 (2) during write"
            severity error;
        assert(dbg_ram_out = "0010")
            report "Step4 failed: RAM[1] should hold 0010 (2)"
            severity error;


        -- ===== step 5 : ac <= input (4) =====
        input   <= "0100";
        mux_sel <= '0';
        ac_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        ac_load <= '0';

        assert(output = "0100")
            report "Step5 failed: AC should be 0100 (4)"
            severity error;


        -- ===== step 6 : ac <= ac + M[1]  (4 + 2 = 6 = 0110) =====
        -- MAR is already "001" from step 4, RAM[1] = 2
        alu_sel <= "010";
        mux_sel <= '1';
        ac_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        ac_load <= '0';

        assert(dbg_ram_out = "0010")
            report "Step6 failed: RAM[1] should be 0010 (2)"
            severity error;
        assert(dbg_alu_out = "0110")
            report "Step6 failed: alu_out should be 0110 (6) = 4 + 2"
            severity error;
        assert(output = "0110")
            report "Step6 failed: AC should be 0110 (6) after 4 + 2"
            severity error;


        -- ===== step 7 : ac <= ac + M[2]  (6 + 3 = 9 = 1001) =====
        -- 7a: update MAR to 2 in a separate cycle
        --     (MAR must settle before AC latches the new ram_out value)
        mar_in   <= "010";
        mar_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        mar_load <= '0';

        assert(dbg_mar_out = "010")
            report "Step7 failed: MAR should be 010 (2)"
            severity error;
        assert(dbg_ram_out = "0011")
            report "Step7 failed: RAM[2] should be 0011 (3)"
            severity error;

        -- 7b: AC = AC + RAM[2] = 6 + 3 = 9
        alu_sel <= "010";
        mux_sel <= '1';
        ac_load <= '1';
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        ac_load <= '0';

        assert(dbg_alu_out = "1001")
            report "Step7 failed: alu_out should be 1001 (9) = 6 + 3"
            severity error;
        assert(output = "1001")
            report "Step7 failed: AC should be 1001 (9) after 6 + 3"
            severity error;


        WAIT; -- suspension
    END PROCESS;

END sim;

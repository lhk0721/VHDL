LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY asynch_ram_tb IS
END asynch_ram_tb;

ARCHITECTURE sim OF asynch_ram_tb IS

    SIGNAL data_in  : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL address  : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL wr       : STD_LOGIC := '0';
    SIGNAL data_out : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN

    UUT : ENTITY work.asynch_ram PORT MAP (
        data_in  => data_in,
        address  => address,
        wr       => wr,
        data_out => data_out
    );

    STIM : PROCESS
        CONSTANT delay : time := 20 ns;
    BEGIN

        -- ===== scenario 1 : write 171 to addr 0, check dual-port read =====
        address <= "00000000";
        data_in <= "10101011";
        wr      <= '1';
        WAIT FOR delay;

        assert(data_out = "10101011")
            report "TC1 failed: data_out should be 10101011 when wr=1 (dual-port simultaneous read)"
            severity error;

        -- check value retention after wr release
        wr <= '0';
        WAIT FOR delay;

        assert(data_out = "10101011")
            report "TC1 failed: data_out should be 10101011 when wr=0"
            severity error;


        -- ===== scenario 2 : write 85 to addr 1 =====
        address <= "00000001";
        data_in <= "01010101";
        wr      <= '1';
        WAIT FOR delay;

        wr <= '0';
        WAIT FOR delay;

        assert(data_out = "01010101")
            report "TC2 failed: data_out should be 01010101"
            severity error;


        -- ===== scenario 3 : return to addr 0, check value retention =====
        address <= "00000000";
        wr      <= '0';
        WAIT FOR delay;

        assert(data_out = "10101011")
            report "TC3 failed: addr 0 should retain 10101011"
            severity error;


        -- ===== scenario 4 : boundary test (addr 255, data 255) =====
        address <= "11111111";
        data_in <= "11111111";
        wr      <= '1';
        WAIT FOR delay;

        wr <= '0';
        WAIT FOR delay;

        assert(data_out = "11111111")
            report "TC4 failed: boundary addr 255 data_out should be 11111111"
            severity error;


        -- ===== scenario 5 : overwrite same address =====
        address <= "00000000";
        data_in <= "00010001";
        wr      <= '1';
        WAIT FOR delay;

        wr <= '0';
        WAIT FOR delay;

        assert(data_out = "00010001")
            report "TC5 failed: data_out should be 00010001 after overwrite"
            severity error;


        WAIT; -- suspension
    END PROCESS;

END sim;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity lab_06_top is
    port (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        Enable : IN STD_LOGIC;

        dp_out : out std_logic_vector(3 downto 0);
        i : out std_logic_vector(3 downto 0)
    );
end lab_06_top;

architecture dataflow of lab_06_top IS
    signal load : std_logic;
    signal clear : std_logic;
    signal out_sel : std_logic;
    signal iNOT10 : std_logic;

    begin 
        DP : Entity work.lab_06_dp port map(
            clk => clk,
            load => load,
            clear => clear,
            out_sel => out_sel,
            iNOT10 => iNOT10,
            dp_out => dp_out,
            i => i
        );

        CU : Entity work.lab_06_cu port map(
            clk => clk,
            reset_n => reset_n,
            Enable => Enable,
            iNOT10 => iNOT10,
            load => load,
            clear => clear,
            out_sel => out_sel
        );
end dataflow;
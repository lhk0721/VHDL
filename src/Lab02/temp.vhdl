
-- ===== entity =====
library ieee;
use ieee.std_logic_1164.all;
entity control_unit is
    port(
        clk     : in std_logic;
        reset_n   : in std_logic;

        -- external input
        Load_A  : in std_logic;
        S       : in std_logic;

        -- datapath status input
        done_flag : in std_logic;

        -- control outputs to datapath
        load_reg   : out std_logic;
        shift_en   : out std_logic;
        count_en   : out std_logic;

        -- output
        Done : out std_logic
    );
    
end control_unit;


library ieee;
use ieee.std_logic_1164.all;
entity data_path is
    port(
        clk : in std_logic;
        reset_n : in std_logic;

        -- external inputs
        A : in std_logic_vector(7 downto 0);

        -- control inputs
        load_reg   : in std_logic;
        shift_en   : in std_logic;
        count_en   : in std_logic;

        -- datapath outputs to control
        done_flag :  out std_logic;

        -- outputs
        B : out std_logic_vector(3 downto 0);
    );
end data_path;


library ieee;
use ieee.std_logic_1164.all;
entity one_counter is
    port(
        clk : in std_logic;
        reset_n : in std_logic;

        -- inputs
        A : in std_logic_vector(7 downto 0);
        Load_A : in std_logic;
        S : in std_logic;

        -- outputs
        B : out std_logic_vector(3 downto 0);
        Done : out std_logic;
    );
end one_counter;
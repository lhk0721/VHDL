
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

Entity lab_06_cu is
    port(
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        Enable : IN STD_LOGIC;
        iNOT10  : IN std_logic;

		load    : out STD_LOGIC;
		clear   : out STD_LOGIC;
		out_sel : out std_logic
    );

end lab_06_cu;

Architecture behavior of lab_06_cu is
    type state_type is (
        s0,
        s1,
        s2
    );

    signal state, next_state : state_type;
begin 
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= s0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;

    end process;

    process(state, Enable, iNOT10)
    begin
        load <= '0';
        clear <= '0';
        out_sel <= '0';
        next_state <= state; 

        case state is
            when s0 =>
                clear <= '1';
                
                if Enable = '1' then
                    next_state <= s1;
                else
                    next_state <= s0;
                end if;

            when s1 =>
                clear <= '0';
            
                if iNOT10 = '1' then
                    load <= '1';
                    next_state <= s1;
                else 
                    load <= '0';
                    next_state <= s2;
                end if;

            when s2 =>
                out_sel <= '1';
                next_state <= s0;

        end case;

    end process;

end behavior;
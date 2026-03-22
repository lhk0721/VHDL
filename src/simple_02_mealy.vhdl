LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY simple_02 IS
    PORT (
        clock   : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        input   : IN  STD_LOGIC;
        output  : OUT STD_LOGIC
    );
END simple_02;

ARCHITECTURE Behavior OF simple_02 IS
    signal Mealy_state : std_logic_vector(1 downto 0);
BEGIN

    PROCESS(reset, clock)
    BEGIN
        IF (reset = '1') THEN
        Mealy_state <= "00";

        ELSIF (clock = '1' AND clock'event) THEN
            CASE Mealy_state IS
                WHEN "00" =>
                    IF input = '1' THEN
                        Mealy_state <= "01";
                    ELSE
                        Mealy_state <= "00";
                    END IF;

                WHEN "01" =>
                    IF input = '1' THEN
                        Mealy_state <= "01";
                    ELSE
                        Mealy_state <= "10";
                    END IF;

                WHEN "10" =>
                    IF input = '1' THEN
                        Mealy_state <= "01";
                    ELSE
                        Mealy_state <= "00";
                    END IF;

                WHEN OTHERS =>
                    Mealy_state <= "00";

            END CASE;
        END IF;
    END PROCESS;

    Output <= '1' WHEN (Mealy_state = "10" AND input = '1') ELSE '0';

END Behavior;
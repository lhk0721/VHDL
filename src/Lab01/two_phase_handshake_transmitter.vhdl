library ieee;

-- ===== entity =====
use ieee.std_logic_1164.all;
entity control_unit is
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        ready     : in  std_logic;
        ack       : in  std_logic;
        load      : out std_logic;
        req       : out std_logic
    );
end control_unit;

library ieee;
use ieee.std_logic_1164.all;
entity data_reg is
    port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;
        load        : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        data_out    : out std_logic_vector(7 downto 0)
    );
end data_reg;

library ieee;
use ieee.std_logic_1164.all;
entity two_phase_handshake_transmitter is
    port (
        clk           : in  std_logic;
        reset_n       : in  std_logic;
        Data_to_send  : in  std_logic_vector(7 downto 0);
        ready         : in  std_logic;
        ack           : in  std_logic;
        Data          : out std_logic_vector(7 downto 0);
        load          : out std_logic; -- for verification purpose
        req           : out std_logic
    );
end two_phase_handshake_transmitter;

-- ===== architecture =====
library ieee;
use ieee.std_logic_1164.all;
architecture behavioral of control_unit is

    signal state : std_logic_vector(1 downto 0);
    signal req_reg : std_logic;

begin

    req <= req_reg;

    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            req_reg <= '0';
            load <= '0';
            state <= "00";
            
        elsif rising_edge(clk) then

            load <= '0';

            case (state) is

                when "00" =>
                    if (ready = '0') then
                        state <= "00";
                    else
                        state <= "01";
                    end if;

                when "01" =>
                    load <= '1';
                    state <= "10";

                when "10" =>
                    req_reg <= not req_reg;
                    state <= "11";

                when "11" =>
                    if (req_reg = ack) then
                        state <= "00";
                    else
                        state <= "11";
                    end if;

                when others =>
                    state <= "00";

            end case;
        end if;
    end process;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;
architecture behavioral of data_reg is

begin
    process(clk, reset_n)
    
    begin
        if reset_n = '0' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;

end behavioral;

library ieee;
use ieee.std_logic_1164.all;
architecture structural of two_phase_handshake_transmitter is

    signal load_sig : std_logic;
    signal data_sig : std_logic_vector(7 downto 0);

begin

    -- control unit
    CU: entity work.control_unit
        port map (
            clk     => clk,
            reset_n => reset_n,
            ready   => ready,
            ack     => ack,
            load    => load_sig,
            req     => req
        );

    -- data register
    DR: entity work.data_reg
        port map (
            clk      => clk,
            reset_n  => reset_n,
            load     => load_sig,
            data_in  => Data_to_send,
            data_out => data_sig
        );

    -- 최종 출력 연결
    load <= load_sig; -- for verification purpose
    Data <= data_sig;

end architecture;


-- ===== shift8 (8-bit Parallel Load Serial Shift Register) =====
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY shift8 IS
    PORT (
        clock : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        R     : IN  STD_LOGIC_VECTOR(7 downto 0);
        Load,
        w     : IN  STD_LOGIC;
        Q     : BUFFER STD_LOGIC_VECTOR(7 downto 0)
    );
END shift8;

ARCHITECTURE behavior OF shift8 IS
BEGIN
    PROCESS(reset, clock)
    BEGIN
        IF (reset = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF (clock = '1' AND clock'event) THEN
            IF (Load = '1') THEN
                Q <= R;
            ELSE
                Q(0) <= Q(1);
                Q(1) <= Q(2);
                Q(2) <= Q(3);
                Q(3) <= Q(4);
                Q(4) <= Q(5);
                Q(5) <= Q(6);
                Q(6) <= Q(7);
                Q(7) <= w;
            END IF;
        END IF;
    END PROCESS;
END behavior;


-- ===== entity =====
library ieee;
use ieee.std_logic_1164.all;
entity oc_control_unit is
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

        -- output
        Done : out std_logic
    );

end oc_control_unit;


library ieee;
use ieee.std_logic_1164.all;
entity oc_data_path is
    port(
        clk : in std_logic;
        reset_n : in std_logic;

        -- external inputs
        A : in std_logic_vector(7 downto 0);

        -- control inputs
        load_reg   : in std_logic;
        shift_en   : in std_logic;

        -- datapath outputs to control
        done_flag :  out std_logic;

        -- outputs
        B : out std_logic_vector(3 downto 0)  
    );
end oc_data_path;


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
        Done : out std_logic 
    );
end one_counter;

-- ===== architecture =====
library ieee;
use ieee.std_logic_1164.all;

architecture behavioral of oc_control_unit is
    type state_type is (IDLE, LOAD, SHIFT, DONE_ST);
    signal state : state_type;
begin
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            load_reg <= '0';
            shift_en <= '0';
            Done <= '0';
            state <= IDLE;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    load_reg <= '0';
                    shift_en <= '0';
                    Done <= '0';
                    if Load_A = '1' then
                        state <= LOAD;
                    end if;

                when LOAD =>
                    load_reg <= '1';
                    shift_en <= '0';
                    Done <= '0';
                    if S = '1' then
                        state <= SHIFT;
                    end if;

                when SHIFT =>
                    load_reg <= '0';
                    shift_en <= '1';
                    Done <= '0';
                    if done_flag = '1' then  
                        state <= DONE_ST;
                    end if;

                when DONE_ST =>
                    load_reg <= '0';
                    shift_en <= '0';
                    Done <= '1';
                    state <= IDLE;

            end case;

        end if;
    end process;
    
end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture behavioral of oc_data_path is
    signal shift_q      : std_logic_vector(7 downto 0);  -- shift8 출력
    signal one_count_reg: unsigned(3 downto 0);
    signal bit_counter  : unsigned(3 downto 0);
    signal done_reg     : std_logic;
    signal sr_load      : std_logic;
    signal sr_reset     : std_logic;  -- shift8용 active-HIGH reset
begin
    -- shift8은 Load='0'이면 항상 shift하므로
    -- SHIFT 상태(shift_en='1')일 때만 Load='0', 나머지는 Load='1'로 고정
    sr_load  <= load_reg or (not shift_en);
    sr_reset <= not reset_n;  -- port map에 식 직접 못 넣으므로 중간 신호 사용

    -- shift8: active-HIGH reset, 오른쪽으로 shift (Q(0)<=Q(1)...Q(7)<=w)
    SR: entity work.shift8
    port map(
        clock => clk,
        reset => sr_reset,
        R     => A,
        Load  => sr_load,
        w     => '0',          -- shift 시 MSB에 0 삽입
        Q     => shift_q
    );

    -- 1의 개수 카운터 및 완료 플래그
    process(clk, reset_n)
        variable next_count : unsigned(3 downto 0);
    begin
        if reset_n = '0' then
            one_count_reg <= (others => '0');
            bit_counter   <= (others => '0');
            done_reg      <= '0';
        elsif rising_edge(clk) then
            if load_reg = '1' then
                -- 카운터 초기화 (shift8은 sr_load='1'로 A를 자동 로드)
                one_count_reg <= (others => '0');
                bit_counter   <= (others => '0');
                done_reg      <= '0';
            elsif shift_en = '1' and done_reg = '0' then
                -- shift_q(0): shift8이 아직 shift하기 전의 현재 LSB 값
                if shift_q(0) = '1' then
                    one_count_reg <= one_count_reg + 1;
                end if;
                next_count  := bit_counter + 1;
                bit_counter <= next_count;
                if next_count = "1000" then
                    done_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    B         <= std_logic_vector(one_count_reg);
    done_flag <= done_reg;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;
architecture structural of one_counter is 
    signal load_reg_s  : std_logic;
    signal shift_en_s  : std_logic;
    signal done_flag_s : std_logic;
begin

    CU: entity work.oc_control_unit
    port map(
        clk       => clk,
        reset_n   => reset_n,
        Load_A    => Load_A,
        S         => S,
        done_flag => done_flag_s,
        load_reg  => load_reg_s,
        shift_en  => shift_en_s,
        Done      => Done
    );

    DP: entity work.oc_data_path
    port map(
        clk       => clk,
        reset_n   => reset_n,
        A         => A,
        done_flag => done_flag_s,
        load_reg  => load_reg_s,
        shift_en  => shift_en_s,
        B         => B
    );

end structural;



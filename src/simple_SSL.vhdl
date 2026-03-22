LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- ===== simple_SSL ======

ENTITY simple_SSL IS
    PORT (
        clk   : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        a     : IN STD_LOGIC;
        b     : IN STD_LOGIC;
        q     : OUT STD_LOGIC
    );
END ENTITY simple_SSL;

ARCHITECTURE Behavior OF simple_SSL IS
    -- 필요하면 내부 상태 신호를 여기서 선언
    -- 예:
    -- signal state : std_logic;
    signal state : std_logic_vector(1 downto 0);
        -- std_logic_vector 말고 std_logic으로 써야 하나? 그 이유는? 뭐가다른거지?
BEGIN

    -- 순차회로를 만들려면 reset, clk를 감지하는 process 작성
    -- process (reset, clk)
    -- begin
        --     1. reset = '1' 이면 출력 또는 내부 상태를 초기값으로 설정
        --     2. rising_edge(clk) 이면 a, b를 보고 q 또는 내부 상태를 갱신
        -- end process;
        
        -- q를 조합논리로 바로 만들고 싶다면 concurrent assignment 사용
        -- 예:
        -- q <= ...;
        PROCESS(reset, clk)
        BEGIN
            IF (reset = '1') THEN
                state <= "00";
            ELSIF (rising_edge(clk)) THEN
                CASE state is

            END IF;
        END PROCESS;

    -- 주의:
    -- architecture 안에서 clk, reset를 다시 signal로 선언하지 말 것
    -- 테스트벤치와 포트 이름(clk, reset, a, b, q)을 반드시 맞출 것
    -- synthesizable 하려면 wait문 대신 process + rising_edge(clk) 형태를 사용할 것

END Behavior;

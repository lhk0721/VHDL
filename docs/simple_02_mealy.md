# `simple_02_mealy.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 밀리 방식 상태기계 예제입니다.  
출력이 현재 상태와 현재 입력의 조합에 더 직접적으로 반응합니다.

## 원문 코드

```vhdl
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
```

## 큰 구조 먼저 보기

이 파일도 무어 예제와 비슷하게 두 부분입니다.

1. 상태를 바꾸는 프로세스
2. 상태와 입력을 보고 출력을 만드는 문장

## 줄별 해설

### 1-2. 라이브러리

`STD_LOGIC` 타입을 쓰기 위한 기본 선언입니다.

### 4-11. `ENTITY`

입력과 출력은 아래처럼 구성됩니다.

- `clock`: 상태 갱신 시점
- `reset`: 시작 상태 복귀
- `input`: 외부 입력
- `output`: 결과 출력

### 13. 상태 신호

```vhdl
signal Mealy_state : std_logic_vector(1 downto 0);
```

현재 상태를 저장하는 2비트 신호입니다.

### 16-20. 리셋 처리

```vhdl
IF (reset = '1') THEN
    Mealy_state <= "00";
```

리셋되면 시작 상태 `"00"`으로 돌아갑니다.

### 22. 클럭 에지 조건

상승 에지에서만 상태를 바꿉니다.

### 23-28. 상태 `"00"`

- 입력이 1이면 `"01"`
- 입력이 0이면 `"00"`

### 30-35. 상태 `"01"`

- 입력이 1이면 `"01"` 유지
- 입력이 0이면 `"10"`

### 37-42. 상태 `"10"`

- 입력이 1이면 `"01"`
- 입력이 0이면 `"00"`

이처럼 상태 전이는 이전 입력 흐름을 기억하는 역할을 합니다.

### 44-45. `WHEN OTHERS`

예상하지 못한 상태는 `"00"`으로 복구합니다.

### 51. 출력문

```vhdl
Output <= '1' WHEN (Mealy_state = "10" AND input = '1') ELSE '0';
```

이 문장은 현재 상태가 `"10"` 이고 현재 입력이 `'1'` 이면 출력 1을 내보냅니다.  
그 외에는 0입니다.

이 점이 밀리 방식 느낌을 잘 보여 줍니다.

- 상태만 보지 않음
- 현재 입력도 함께 확인

## 무어 예제와 비교해서 볼 점

- 둘 다 `CASE` 문으로 상태를 바꿉니다.
- 둘 다 클럭 상승 에지에서 상태가 갱신됩니다.
- 밀리 방식은 출력 계산에서 현재 입력이 더 직접적으로 등장합니다.

## 따라칠 때 기억할 문법

- `PROCESS(reset, clock)` 는 민감도 목록
- `IF ... THEN`, `ELSIF`, `ELSE`, `END IF;` 구조를 정확히 닫아야 함
- `"10"` 은 2비트 상태값
- `'1'` 은 1비트 입력값
- 조건부 출력은 `WHEN ... ELSE ...` 로 쓸 수 있음

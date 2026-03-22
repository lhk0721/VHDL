# `simple_01_moore.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 무어 방식 상태기계 예제입니다.  
상태기계는 입력을 보면서 내부 상태를 바꾸고, 그 상태를 바탕으로 출력을 만드는 회로입니다.

## 원문 코드

```vhdl
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY simple_01 IS
    PORT (
        clock   : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        input   : IN  STD_LOGIC;
        output  : OUT STD_LOGIC
    );
END simple_01;

ARCHITECTURE Behavior OF simple_01 IS
    signal Moore_state : std_logic_vector(1 downto 0);
BEGIN

    PROCESS(reset, clock)
    BEGIN
        IF (reset = '1') THEN
            Moore_state <= "00";

        ELSIF (clock = '1' AND clock'event) THEN
            CASE Moore_state IS

                WHEN "00" =>
                    IF input = '1' THEN
                        Moore_state <= "01";
                    ELSE
                        Moore_state <= "00";
                    END IF;

                WHEN "01" =>
                    IF input = '1' THEN
                        Moore_state <= "01";
                    ELSE
                        Moore_state <= "10";
                    END IF;

                WHEN "10" =>
                    IF input = '1' THEN
                        Moore_state <= "11";
                    ELSE
                        Moore_state <= "00";
                    END IF;

                WHEN "11" => 
                    IF input = '1' THEN
                        Moore_state <= "01";
                    ELSE
                        Moore_state <= "10";
                    END IF;
                WHEN OTHERS =>
                    Moore_state <= "00";

            END CASE;
        END IF;
    END PROCESS;

    Output <= '1' WHEN (Moore_state = "11" AND input = 1)  ELSE '0';

END Behavior;
```

## 큰 구조 먼저 보기

이 파일은 크게 두 부분입니다.

1. 클럭에 따라 상태를 바꾸는 부분
2. 현재 상태를 보고 출력을 만드는 부분

## 줄별 해설

### 1-2. 라이브러리 선언

기본 신호 타입 `STD_LOGIC`을 쓰기 위한 준비입니다.

### 4-11. `ENTITY`

입출력 선언입니다.

- `clock`: 상태가 바뀌는 기준
- `reset`: 처음 상태로 되돌리기
- `input`: 외부 입력
- `output`: 결과 출력

### 13. 상태 신호 선언

```vhdl
signal Moore_state : std_logic_vector(1 downto 0);
```

2비트 상태 저장소입니다.  
가능한 상태는 `"00"`, `"01"`, `"10"`, `"11"` 입니다.

### 16-18. 프로세스 시작과 리셋

```vhdl
PROCESS(reset, clock)
BEGIN
    IF (reset = '1') THEN
        Moore_state <= "00";
```

리셋이 들어오면 상태를 시작점 `"00"`으로 되돌립니다.

### 20. 상승 에지 조건

```vhdl
ELSIF (clock = '1' AND clock'event) THEN
```

클럭이 0에서 1로 바뀌는 순간에만 상태를 갱신하겠다는 뜻입니다.

### 21. `CASE Moore_state IS`

현재 상태가 무엇인지에 따라 분기합니다.

### 23-28. 상태 `"00"`

- 입력이 1이면 `"01"`로 이동
- 입력이 0이면 그대로 `"00"`

### 30-35. 상태 `"01"`

- 입력이 1이면 `"01"` 유지
- 입력이 0이면 `"10"` 이동

### 37-42. 상태 `"10"`

- 입력이 1이면 `"11"` 이동
- 입력이 0이면 `"00"` 이동

### 44-49. 상태 `"11"`

- 입력이 1이면 `"01"` 이동
- 입력이 0이면 `"10"` 이동

### 50-52. `WHEN OTHERS`

예상하지 못한 상태가 들어오면 `"00"`으로 되돌립니다.  
안전장치 역할을 합니다.

### 58. 출력문

```vhdl
Output <= '1' WHEN (Moore_state = "11" AND input = 1)  ELSE '0';
```

출력을 결정하는 문장입니다.  
다만 여기에는 문법상 주의할 점이 있습니다.

- `input = 1` 은 일반적으로 `input = '1'` 로 써야 합니다.
- `std_logic` 한 비트 비교에는 작은따옴표를 사용합니다.

즉, 학습용으로 읽을 때는 아래처럼 이해하면 됩니다.

```vhdl
Output <= '1' WHEN (Moore_state = "11" AND input = '1') ELSE '0';
```

## 무어 방식으로 이해하는 포인트

무어 상태기계는 보통 출력이 상태 중심으로 정해집니다.  
그런데 이 코드의 출력문은 현재 입력도 함께 보고 있습니다.  
그래서 엄밀히 말하면 전형적인 무어 형태와는 조금 다르게 보일 수 있습니다.

학습 관점에서는 아래를 기억하면 충분합니다.

- `CASE` 문으로 상태 전이를 만든다
- 상태는 클럭 순간에만 바뀐다
- 상태 이름 대신 비트 조합을 써도 된다

## 따라칠 때 기억할 문법

- `std_logic_vector(1 downto 0)` 는 2비트 벡터
- `CASE ... WHEN ... =>` 는 상태별 분기
- `"11"` 은 2비트 값
- `'1'` 은 1비트 값
- `WHEN OTHERS =>` 는 예외 처리

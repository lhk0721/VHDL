# `modulo_m_counter_tb.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 `modulo_m_counter.vhdl`를 시험해 보는 테스트벤치입니다.  
설정값 `M`, `N`, `T`를 정하고, 리셋과 클럭을 만들어서 카운터가 반복적으로 잘 세는지 확인하는 용도입니다.

## 원문 코드

```vhdl
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modMCounter_tb is
end modMCounter_tb;


architecture arch of modMCounter_tb is
    constant M : integer := 3;  -- count upto 2 (i.e. 0 to 2)
    constant N : integer := 4;
    constant T : time := 100 ns; 

    signal clk, reset : std_logic;  -- input
    signal complete_tick : std_logic; -- output
    signal count : std_logic_vector(N-1 downto 0);  -- output

    -- total samples to store in file
    constant num_of_clocks : integer := 30; 
    signal i : integer := 0; -- loop variable
    
begin

    modMCounter_unit : entity work.modMCounter
        generic map (M => M, N => N)
        port map (clk=>clk, reset=>reset, complete_tick=>complete_tick,
                    count=>count);

    -- reset = 1 for first clock cycle and then 0
    reset <= '1', '0' after T/2;

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;

        -- run 30 clocks
        if (i = num_of_clocks) then
            wait;
        else
            i <= i + 1;
        end if;
    end process;
end arch;
```

## 큰 구조 먼저 보기

이 파일은 크게 네 부분입니다.

1. 라이브러리 선언
2. 테스트용 상수와 신호 선언
3. 카운터 회로 연결
4. 리셋과 클럭 생성

## 줄별 해설

### 1-3. 라이브러리 선언

- `library ieee;`
- `use ieee.std_logic_1164.all;`
- `use ieee.numeric_std.all;`

기본 신호 타입과 숫자 관련 타입을 쓰기 위한 선언입니다.

### 5-6. 빈 `entity`

```vhdl
entity modMCounter_tb is
end modMCounter_tb;
```

테스트벤치는 외부 포트가 없는 경우가 많습니다.  
이 파일도 내부에서만 시험을 진행하므로 `port`가 없습니다.

### 9-11. 상수 선언

```vhdl
constant M : integer := 3;
constant N : integer := 4;
constant T : time := 100 ns;
```

이 값들은 테스트 조건입니다.

- `M = 3`: 카운터가 `0, 1, 2` 까지 센 뒤 다시 0으로 돌아감
- `N = 4`: 출력 비트 폭은 4비트
- `T = 100 ns`: 클럭 한 주기의 기준 시간

문법 포인트:

- `constant` 는 바뀌지 않는 값
- `:=` 는 초기값 지정
- `time` 은 시간 타입

### 13-15. 테스트용 신호 선언

```vhdl
signal clk, reset : std_logic;
signal complete_tick : std_logic;
signal count : std_logic_vector(N-1 downto 0);
```

- `clk`, `reset`: 카운터에 넣어 줄 입력
- `complete_tick`, `count`: 카운터에서 나오는 출력

### 18-19. 반복 횟수용 변수 성격의 신호

```vhdl
constant num_of_clocks : integer := 30;
signal i : integer := 0;
```

- `num_of_clocks`: 총 몇 번 클럭을 만들지
- `i`: 현재 몇 번 진행했는지 세는 값

여기서는 30번 클럭을 만든 뒤 멈추게 설계했습니다.

### 23-26. 회로 인스턴스 생성

```vhdl
modMCounter_unit : entity work.modMCounter
    generic map (M => M, N => N)
    port map (clk=>clk, reset=>reset, complete_tick=>complete_tick,
                count=>count);
```

이 부분은 실제 카운터 회로를 테스트벤치 안에 불러오는 코드입니다.

- `modMCounter_unit`: 인스턴스 이름
- `entity work.modMCounter`: 사용할 회로
- `generic map`: 설정값 연결
- `port map`: 신호 연결

문법 포인트:

- `generic map` 은 회로의 설정값을 넣는 곳
- `port map` 은 입출력 선을 연결하는 곳

### 29. 리셋 파형 생성

```vhdl
reset <= '1', '0' after T/2;
```

이 문장은 시간에 따라 값이 바뀌는 신호를 한 줄로 적은 예입니다.

- 시작 직후에는 `reset = '1'`
- `T/2` 시간이 지나면 `reset = '0'`

즉, 처음 반 주기 동안만 리셋을 걸고 그다음 해제합니다.

### 32-45. 클럭 생성 프로세스

```vhdl
process 
begin
    clk <= '0';
    wait for T/2;
    clk <= '1';
    wait for T/2;

    if (i = num_of_clocks) then
        wait;
    else
        i <= i + 1;
    end if;
end process;
```

이 프로세스는 테스트벤치에서 가장 중요한 부분입니다.

동작 순서는 아래와 같습니다.

1. `clk`를 0으로 둠
2. 반 주기 기다림
3. `clk`를 1로 바꿈
4. 다시 반 주기 기다림
5. 지금까지 만든 클럭 횟수를 확인
6. 30번이 되면 멈춤
7. 아니면 `i`를 1 증가시키고 반복

즉, 이 프로세스 하나가 계속 시계 신호를 만들어 줍니다.

### 46. `end arch;`

테스트벤치의 `architecture`가 끝났다는 뜻입니다.

## 따라칠 때 기억할 문법

- `constant` 는 고정값
- `signal` 은 시간에 따라 바뀔 수 있는 신호
- `generic map` 은 설정값 전달
- `port map` 은 포트 연결
- `after` 는 일정 시간 후 값 변경
- `wait for T/2;` 는 반 주기 대기

## 이 파일을 읽을 때 이해하면 좋은 점

이 테스트벤치는 출력을 `assert`로 직접 검사하지는 않습니다.  
대신 클럭과 리셋을 만들어서 카운터가 시뮬레이션에서 어떻게 움직이는지 관찰하는 형태입니다.

즉, 이전의 `half_adder_simple_tb.vhdl`처럼 정답 비교 중심이라기보다,  
파형을 만들어 동작을 확인하는 연습용 테스트벤치에 가깝습니다.

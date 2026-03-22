# `modulo_m_counter.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 정해진 숫자까지 세고 다시 0으로 돌아가는 카운터입니다.  
기본값으로는 0부터 4까지 센 뒤 다시 0으로 돌아갑니다.

## 원문 코드

```vhdl
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modMCounter is
    generic (
            M : integer := 5;
            N : integer := 3
    );
    
    port(
            clk, reset : in std_logic;
            complete_tick : out std_logic;
            count : out std_logic_vector(N-1 downto 0)
    );
end modMCounter;


architecture arch of modMCounter is
    signal count_reg, count_next : unsigned(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then 
            count_reg <= (others=>'0');
        elsif   clk'event and clk='1' then
            count_reg <= count_next;
        else
            count_reg <= count_reg;
        end if;
    end process;
    
    count_next <= (others=>'0') when count_reg=(M-1) else (count_reg+1);
    
    complete_tick <= '1' when count_reg = (M-1) else '0';
    
    count <= std_logic_vector(count_reg);
end arch;
```

## 큰 구조 먼저 보기

이 파일은 아래 네 부분으로 볼 수 있습니다.

1. 라이브러리 선언
2. `generic`과 `port` 선언
3. 현재 값을 저장하는 레지스터 프로세스
4. 다음 값과 출력 계산

## 줄별 해설

### 1-3. 라이브러리

- `std_logic_1164`는 기본 신호 타입용
- `numeric_std`는 숫자 계산용

특히 `count_reg + 1` 같은 계산을 하려면 `numeric_std`가 중요합니다.

### 5. `entity modMCounter is`

이 카운터 회로의 외부 이름입니다.

### 6-9. `generic`

```vhdl
generic (
    M : integer := 5;
    N : integer := 3
);
```

`generic`은 회로의 설정값입니다.

- `M`: 몇까지 세고 다시 돌아갈지
- `N`: 그 숫자를 표현하기 위한 비트 수

예를 들어 `M=5`이면 `0,1,2,3,4` 까지 센 뒤 다시 0으로 갑니다.

### 11-15. `port`

- `clk`: 카운터가 한 칸 움직이는 기준 클럭
- `reset`: 값을 0으로 초기화
- `complete_tick`: 마지막 값 도달 알림
- `count`: 현재 카운트 값

`count : out std_logic_vector(N-1 downto 0)` 는 비트 폭이 `N`개라는 뜻입니다.

### 19. 내부 신호 선언

```vhdl
signal count_reg, count_next : unsigned(N-1 downto 0);
```

- `count_reg`: 현재 저장된 값
- `count_next`: 다음 클럭에서 들어갈 값

`unsigned`를 쓴 이유는 덧셈을 자연스럽게 하기 위해서입니다.

### 21-29. 레지스터 프로세스

```vhdl
process(clk, reset)
begin
    if reset = '1' then 
        count_reg <= (others=>'0');
    elsif clk'event and clk='1' then
        count_reg <= count_next;
    else
        count_reg <= count_reg;
    end if;
end process;
```

이 부분은 현재 값을 저장하는 순차 회로입니다.

- `process(clk, reset)` 는 클럭이나 리셋이 바뀌면 반응
- `if reset = '1' then` 은 리셋 우선
- `count_reg <= (others=>'0');` 는 모든 비트를 0으로
- `elsif clk'event and clk='1' then` 은 상승 에지에서 동작
- `count_reg <= count_next;` 는 다음 값을 현재 값으로 저장

`(others => '0')` 문법은 벡터의 모든 비트를 0으로 채우라는 뜻입니다.

### 31. 다음 값 계산

```vhdl
count_next <= (others=>'0') when count_reg=(M-1) else (count_reg+1);
```

조건부 신호 할당입니다.

- 현재 값이 `M-1` 이면 다음 값은 0
- 아니면 1 증가

`when ... else ...` 는 짧은 조건식으로 자주 쓰입니다.

### 33. 완료 신호 생성

```vhdl
complete_tick <= '1' when count_reg = (M-1) else '0';
```

현재 값이 마지막 값일 때만 `complete_tick`을 1로 만듭니다.

### 35. 출력 형변환

```vhdl
count <= std_logic_vector(count_reg);
```

내부에서는 `unsigned`를 썼지만, 출력 포트 타입은 `std_logic_vector`입니다.  
그래서 타입을 맞추기 위해 변환합니다.

## 따라칠 때 기억할 문법

- `generic`은 설정값
- `unsigned`는 계산용 숫자 타입
- `downto`는 큰 인덱스에서 작은 인덱스로 내려감
- `clk'event and clk='1'` 는 상승 에지 표현
- `when ... else ...` 는 조건부 할당
- `std_logic_vector(...)` 는 형변환

## 이해 포인트

이 파일은 "현재 값 저장"과 "다음 값 계산"을 분리해서 적은 전형적인 카운터 예제입니다.  
이 구조는 이후 상태기계를 배울 때도 매우 자주 나옵니다.

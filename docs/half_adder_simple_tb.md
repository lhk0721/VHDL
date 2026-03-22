# `half_adder_simple_tb.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 반가산기 회로를 시험해 보는 테스트벤치입니다.  
실제 제품 회로라기보다, 회로가 맞는지 확인하는 실험 코드입니다.

## 원문 코드

```vhdl
library ieee;
use ieee.std_logic_1164.all;


entity half_adder_simple_tb is
end half_adder_simple_tb;

architecture tb of half_adder_simple_tb is
    signal a, b : std_logic;  -- inputs
    signal sum, carry : std_logic;  -- outputs

begin
    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);
    -- half_adder and the TB must be in the same directory

    STIM: process -- unsynthetizeable part
        constant period: time := 50 ns;
    begin
        a <= '0';
        b <= '0';
        wait for period;
        assert ((sum = '0') and (carry = '0'))
        report "test failed for input combination 00" severity error;

        a <= '0';
        b <= '1';
        wait for period;
        assert ((sum = '1') and (carry = '0'))
        report "test failed for input combination 01" severity error;

        a <= '1';
        b <= '0';
        wait for period;
        assert ((sum = '1') and (carry = '0'))
        report "test failed for input combination 10" severity error;

        a <= '1';
        b <= '1';
        wait for period;
        assert ((sum = '0') and (carry = '1'))
        report "test failed for input combination 11" severity error;

        a <= '0';
        b <= '1';
        wait for period;
        assert ((sum = '0') and (carry = '1'))
        report "test failed for input combination 01 (fail test)" severity error;

        wait;
    end process;
end tb;
```

## 큰 구조 먼저 보기

이 파일은 크게 세 부분입니다.

1. 사용할 라이브러리 선언
2. 테스트용 신호와 회로 연결
3. 입력을 순서대로 넣고 결과 검사

## 줄별 해설

### 1-2. 라이브러리 선언

- `library ieee;`
- `use ieee.std_logic_1164.all;`

기본 신호 타입 `std_logic`을 사용하기 위한 준비입니다.

### 5-6. 빈 `entity`

```vhdl
entity half_adder_simple_tb is
end half_adder_simple_tb;
```

테스트벤치는 보통 외부 입출력이 필요 없어서 `port`가 비어 있는 경우가 많습니다.

### 8-10. 내부 신호 선언

```vhdl
signal a, b : std_logic;
signal sum, carry : std_logic;
```

테스트벤치 안에서 사용할 선을 만듭니다.

- `a`, `b`: 반가산기에 넣을 입력
- `sum`, `carry`: 반가산기에서 나오는 출력

### 13. `UUT : entity work.half_adder port map (...)`

이 줄은 매우 중요합니다.

- `UUT`는 인스턴스 이름입니다.
- `entity work.half_adder`는 사용할 회로를 가리킵니다.
- `port map`은 테스트벤치 신호와 회로 포트를 연결합니다.

문법 포인트:

- `=>` 는 포트 연결에 사용
- 왼쪽은 회로 포트 이름
- 오른쪽은 연결할 신호 이름

### 16-17. `STIM: process`

`STIM`은 자극(stimulus)이라는 뜻입니다.  
즉, 입력을 시간 순서대로 넣는 프로세스입니다.

`constant period: time := 50 ns;`

- `constant`: 변하지 않는 값 선언
- `time`: 시간 타입
- `:=`: 변수나 상수의 초기값 지정에 자주 사용

여기서는 50ns마다 다음 테스트로 넘어갑니다.

### 19-24. 첫 번째 테스트

```vhdl
a <= '0';
b <= '0';
wait for period;
assert ((sum = '0') and (carry = '0'))
report "test failed for input combination 00" severity error;
```

의미는 아래와 같습니다.

1. 입력을 `0`, `0`으로 설정
2. 회로가 반응할 시간을 잠깐 기다림
3. 출력이 기대값과 같은지 검사
4. 틀리면 오류 메시지 출력

### 26-31. 두 번째 테스트

입력을 `0`, `1`로 바꿔 검사합니다.

### 33-38. 세 번째 테스트

입력을 `1`, `0`으로 바꿔 검사합니다.

### 40-45. 네 번째 테스트

입력을 `1`, `1`로 바꿔 검사합니다.  
이 경우 자리올림 `carry`가 1이어야 합니다.

### 47-52. 의도적인 실패 테스트

마지막 검사는 일부러 틀린 기대값을 적어 둔 부분입니다.  
테스트 도구가 정말 오류를 잡는지 확인하려는 용도입니다.

### 54. `wait;`

무한 대기입니다.  
프로세스가 여기서 멈추고 끝나지 않게 합니다.

## 따라칠 때 기억할 문법

- `signal`은 테스트벤치 내부 신호 선언
- `port map`은 회로와 신호 연결
- `process`는 시간 순서가 있는 동작을 적을 때 사용
- `wait for 50 ns;` 는 50나노초 대기
- `assert 조건 report "메시지" severity error;` 는 검사문

## 이 파일을 읽으며 같이 익히면 좋은 것

- 조합 회로는 입력을 바꾸면 출력이 바로 따라 바뀜
- 테스트벤치는 입력을 직접 만들어 넣을 수 있음
- 시뮬레이션 코드와 합성 가능한 회로 코드는 다를 수 있음

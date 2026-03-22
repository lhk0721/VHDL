# `half_adder.vhdl` 줄별 설명

## 이 파일의 역할

이 파일은 가장 기본적인 덧셈 회로인 반가산기입니다.  
입력 1비트 두 개를 받아 `sum`과 `carry`를 만듭니다.

## 원문 코드

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity half_adder is 
    port (a, b : in std_logic;
        sum, carry : out std_logic
    );
end half_adder;

architecture arch of half_adder is
begin
    sum <= a xor b;
    carry <= a and b;
end arch;
```

## 줄별 해설

### 1. `library ieee;`

표준 VHDL 라이브러리인 `ieee`를 사용하겠다는 뜻입니다.

### 2. `use ieee.std_logic_1164.all;`

`std_logic` 타입과 논리 연산에 필요한 정의를 가져옵니다.

### 4. `entity half_adder is`

회로의 바깥 모양을 선언합니다.  
`half_adder`가 이 회로의 이름입니다.

### 5-7. `port (...)`

입력과 출력을 선언하는 부분입니다.

- `a, b : in std_logic;`
  입력 두 개를 선언합니다.
- `sum, carry : out std_logic`
  출력 두 개를 선언합니다.

문법 포인트:

- `in`은 입력
- `out`은 출력
- `std_logic`은 1비트 신호 타입

### 8. `end half_adder;`

`entity` 선언이 끝났다는 뜻입니다.  
앞에서 쓴 이름 `half_adder`와 맞춰 주는 것이 읽기 쉽습니다.

### 10. `architecture arch of half_adder is`

회로 내부 동작을 정의하는 부분입니다.

- `arch`는 이 구조의 이름
- `of half_adder`는 이 구조가 어느 `entity`에 대한 것인지 표시

### 11. `begin`

실제 동작 설명이 시작됩니다.

### 12. `sum <= a xor b;`

`xor`는 둘이 다를 때만 1이 되는 연산입니다.

- 0 xor 0 = 0
- 0 xor 1 = 1
- 1 xor 0 = 1
- 1 xor 1 = 0

그래서 반가산기의 합 자리 `sum`에 딱 맞습니다.

### 13. `carry <= a and b;`

`and`는 둘 다 1일 때만 1이 됩니다.  
자리올림은 1+1일 때만 생기므로 `carry`에 맞는 식입니다.

### 14. `end arch;`

`architecture`가 끝났다는 뜻입니다.

## 따라칠 때 기억할 문법

- `<=` 는 신호 할당
- `xor`, `and` 는 논리 연산자
- 입력과 출력 선언은 `port (...)` 안에 작성
- 조합 회로라서 `process` 없이도 간단히 표현 가능

## 직접 확인해 볼 입력 예시

- `a='0'`, `b='0'` 이면 `sum='0'`, `carry='0'`
- `a='0'`, `b='1'` 이면 `sum='1'`, `carry='0'`
- `a='1'`, `b='1'` 이면 `sum='0'`, `carry='1'`

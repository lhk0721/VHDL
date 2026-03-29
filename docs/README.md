# VHDL 학습 문서 안내

이 폴더는 `src` 안에 있는 VHDL 파일을 직접 한 줄씩 따라 읽고, 따라 치면서 익힐 수 있게 만든 문서 모음입니다.

## 폴더 구성

- `src`: 실제 VHDL 소스 코드
- `docs`: 소스 코드를 설명하는 Markdown 문서

## 이 문서를 어떻게 읽으면 좋은가

추천 순서는 아래와 같습니다.

1. `half_adder.vhdl`
2. `half_adder_simple_tb.vhdl`
3. `D_latch.vhdl`
4. `DFF.vhdl`
5. `modulo_m_counter.vhdl`
6. `modulo_m_counter_tb.vhdl`
7. `simple_01_moore.vhdl`
8. `simple_02_mealy.vhdl`

가장 짧은 조합 회로부터 보고, 그다음 테스트 코드, 래치와 플립플롭 같은 기본 저장 소자, 카운터, 상태기계 순서로 읽으면 부담이 적습니다.

## VHDL 파일의 기본 구조

대부분의 VHDL 파일은 아래 흐름을 가집니다.

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity example is
    port(
        a : in std_logic;
        b : out std_logic
    );
end example;

architecture arch of example is
begin
    b <= a;
end arch;
```

각 부분의 의미는 아래와 같습니다.

- `library ieee;`
  표준 라이브러리를 사용하겠다는 선언입니다.
- `use ieee.std_logic_1164.all;`
  `std_logic` 같은 자주 쓰는 신호 타입을 가져옵니다.
- `entity`
  이 회로의 바깥쪽 모양입니다. 입력과 출력이 여기 정의됩니다.
- `architecture`
  회로 내부가 실제로 어떻게 동작하는지 적는 부분입니다.
- `begin`
  실제 동작 코드를 시작한다는 뜻입니다.
- `<=`
  신호에 값을 연결하거나 할당할 때 자주 쓰는 기호입니다.

## 자주 보는 문법

### 1. 자료형

- `std_logic`
  한 개의 디지털 신호를 나타냅니다. 보통 0 또는 1로 생각하면 됩니다.
- `std_logic_vector(1 downto 0)`
  여러 비트를 묶은 신호입니다. 예를 들어 2비트 값입니다.
- `unsigned`
  부호 없는 숫자로 계산할 때 자주 씁니다.

### 2. 포트 선언

```vhdl
port (
    a : in std_logic;
    sum : out std_logic
);
```

- `in`: 입력
- `out`: 출력
- `:`: 이름과 타입을 구분
- `;`: 문장 끝

### 3. 신호 선언

```vhdl
signal count_reg : unsigned(2 downto 0);
```

`signal`은 회로 내부에서 쓰는 배선이나 저장값 같은 개념입니다.

### 4. 동시문

```vhdl
sum <= a xor b;
```

이 문장은 회로 전체에서 항상 동시에 성립하는 연결로 이해하면 됩니다.

### 5. 순차문과 process

```vhdl
process(clk, reset)
begin
    if reset = '1' then
        ...
    elsif clk'event and clk = '1' then
        ...
    end if;
end process;
```

`process` 안은 위에서 아래로 읽히는 순차 코드처럼 보이지만, 실제로는 하드웨어 동작을 기술하는 문법입니다.

### 6. 조건문

```vhdl
if input = '1' then
    ...
else
    ...
end if;
```

조건에 따라 다른 동작을 선택합니다.

### 7. case 문

```vhdl
case state is
    when "00" =>
        ...
    when others =>
        ...
end case;
```

현재 상태가 무엇인지에 따라 분기합니다. 상태기계에서 자주 등장합니다.

### 8. 주석

```vhdl
-- 이 줄은 설명입니다.
```

`--` 뒤는 설명용 글이며 실행되지 않습니다.

## 파일별 문서

- [half_adder.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/half_adder.md)
- [half_adder_simple_tb.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/half_adder_simple_tb.md)
- [D_latch.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/D_latch.md)
- [DFF.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/DFF.md)
- [modulo_m_counter.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/modulo_m_counter.md)
- [modulo_m_counter_tb.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/modulo_m_counter_tb.md)
- [simple_01_moore.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/simple_01_moore.md)
- [simple_02_mealy.md](/Users/neighbor/Documents/Code/Github/vhdl/docs/simple_02_mealy.md)

## 따라칠 때 주의할 점

- 작은따옴표 `'1'`, `'0'` 는 한 비트입니다.
- 큰따옴표 `"00"` 는 여러 비트 묶음입니다.
- 세미콜론 `;` 을 빠뜨리면 오류가 자주 납니다.
- `entity` 이름과 `architecture ... of` 뒤 이름은 서로 맞아야 합니다.
- 테스트벤치는 실제 회로가 아니라 검사용 코드입니다.

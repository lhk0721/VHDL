# Two-Phase Handshake Transmitter 실습 발표 초안

## 목차

1. 실습 개요
2. VHDL Code
3. Test Bench Code
4. RTL Simulation Capture
5. Problems Met During Design & Solutions
6. Discussion
7. Conclusion

---

## 1. 실습 개요

### 슬라이드 제목
Two-Phase Handshake Transmitter Design

### 발표 내용
- 본 실습의 목표는 `two_phase_handshake_transmitter`를 설계하고, 2-phase handshake 동작을 RTL simulation으로 검증하는 것이다.
- 송신기는 `ready`가 활성화되면 입력 데이터를 내부 레지스터에 저장하고, `req`를 토글하여 수신기에 새 데이터 전송을 알린다.
- 수신기 측의 `ack`가 `req`와 같아지면 한 번의 전송이 완료되고, 송신기는 다시 idle 상태로 복귀한다.

### 핵심 포인트
- 2-phase handshake는 신호의 레벨 유지보다 `toggle` 자체가 이벤트 의미를 가진다.
- 따라서 `req`와 `ack`의 값이 같아지는 시점을 handshake 완료로 판단할 수 있다.

---

## 2. VHDL Code

### 슬라이드 제목
VHDL Code Structure

### 발표 내용
- 설계는 크게 `control_unit`, `data_reg`, `two_phase_handshake_transmitter`의 세 부분으로 구성하였다.
- `control_unit`은 상태 천이와 handshake 제어를 담당한다.
- `data_reg`는 `load`가 1인 한 클록 동안 `Data_to_send`를 저장한다.
- 최상위 모듈은 두 블록을 연결하여 최종 출력 `Data`, `req`, `load`를 제공한다.

### 모듈별 설명

#### 2.1 control_unit
- 입력: `clk`, `reset_n`, `ready`, `ack`
- 출력: `load`, `req`
- 내부 상태는 2비트 `state`로 정의하였다.
- 동작 순서는 다음과 같다.

1. `state 0 = "00"`: idle 상태에서 `ready='1'`이면 다음 상태로 이동
2. `state 1 = "01"`: `load <= '1'`을 출력하여 데이터를 레지스터에 저장
3. `state 2 = "10"`: `req_reg <= not req_reg`로 request 토글
4. `state 3 = "11"`: `ack`가 `req_reg`와 같아질 때까지 대기

### 발표용 설명 문장
- 본 설계의 핵심은 `load`를 한 클록만 활성화하고, 그 다음 클록에서 `req`를 토글하도록 분리한 점이다.
- 이를 통해 데이터 저장 시점과 handshake 시작 시점을 명확히 구분할 수 있었다.

#### 2.2 data_reg
- 입력: `clk`, `reset_n`, `load`, `data_in`
- 출력: `data_out`
- `reset_n='0'`일 때 `data_out`을 모두 0으로 초기화한다.
- 클록 상승 에지에서 `load='1'`이면 `data_in` 값을 `data_out`으로 저장한다.

### 발표용 설명 문장
- `data_reg`는 매우 단순한 구조이지만, `load`를 통해 데이터 저장 시점을 명확하게 통제할 수 있도록 했다.

#### 2.3 top module
- 입력: `clk`, `reset_n`, `Data_to_send`, `ready`, `ack`
- 출력: `Data`, `load`, `req`
- `control_unit`의 `load_sig`를 `data_reg`에 전달한다.
- `Data_to_send`는 `data_reg`를 통해 최종 `Data`로 출력된다.
- `load` 출력은 검증용 포트로 외부에 노출하였다.

### 발표용 설명 문장
- 검증을 쉽게 하기 위해 `load`를 top module 출력으로 연결했고, test bench에서 직접 확인할 수 있도록 구성했다.

---

## 3. Test Bench Code

### 슬라이드 제목
Test Bench Scenarios

### 발표 내용
- 테스트벤치는 클록 생성 프로세스와 자극 생성 프로세스로 구성하였다.
- 클록 주기는 `50 ns`로 설정하였다.
- 다양한 handshake 상황을 검증하기 위해 총 6개의 scenario를 작성하였다.

### 주요 검증 항목

#### Scenario 1: 정상 전송
- `ready='1'`일 때 `load`가 1클록 동안 올라가는지 확인
- 이후 `req`가 toggle 되는지 확인
- `ack <= req` 이후 `Data = Data_to_send`인지 확인

#### Scenario 2: ready가 0인 경우
- 송신기가 idle 상태를 유지하는지 확인
- `req`가 불필요하게 toggle 되지 않는지 검증

#### Scenario 3: delayed ack
- `req`가 먼저 toggle 된 뒤, `ack`가 늦게 도착해도 handshake가 정상 완료되는지 검증

#### Scenario 4: reset 검증
- reset 동안 `req='0'`, `load='0'`, `Data="00000000"`인지 확인

#### Scenario 5: 연속 전송
- 첫 번째 전송 완료 후 두 번째 데이터 전송이 정상적으로 이어지는지 검증
- 각 전송마다 `load`와 `req`가 독립적으로 동작하는지 확인

#### Scenario 6: load pulse width 검증
- `load`가 정확히 1클록 동안만 활성화되는지 확인

### 발표용 설명 문장
- 단순 정상 동작만 보는 것이 아니라, `ready=0`, delayed ack, reset, back-to-back transfer까지 포함해 설계의 안정성을 검증했다.

---

## 4. RTL Simulation Capture

### 슬라이드 제목
RTL Simulation Results

### 슬라이드에 넣을 캡처 제안
- `clk`, `reset_n`, `ready`, `load`, `req`, `ack`, `Data_to_send`, `Data`
- 특히 Scenario 1과 Scenario 3 파형을 넣는 것이 좋다.

### 캡처 1 설명
정상 handshake 동작
- `ready`가 1이 된 후 `load`가 한 클록 동안만 1로 올라간다.
- 다음 클록에서 `req`가 toggle 된다.
- 이후 `ack`가 `req`와 같아지면 handshake가 완료된다.
- 최종적으로 `Data`가 `Data_to_send`와 동일하게 유지된다.

### 캡처 2 설명
Delayed ack 동작
- `req`가 먼저 toggle 된 뒤에도, `ack`가 도착하기 전까지 상태가 유지된다.
- `ack=req`가 되는 순간 idle로 복귀하며 전송이 완료된다.

### 발표용 설명 문장
- 시뮬레이션 결과, 데이터 로드와 request 토글의 순서가 의도대로 분리되어 나타났고, delayed ack 상황에서도 오동작 없이 handshake가 유지되었다.

### 캡처 아래에 넣을 한 줄 요약
- `load`는 1클록 펄스, `req`는 event toggle, `ack=req`에서 transaction complete

---

## 5. Problems Met During Design & Solutions

### 슬라이드 제목
Problems Met During Design & Solutions

### 문제 1
`load`와 `req`의 타이밍 분리 필요

### 원인
- 데이터를 저장하는 시점과 handshake 요청 시점이 동시에 일어나면 파형 해석과 검증이 복잡해질 수 있었다.

### 해결
- FSM을 `"01"`과 `"10"` 상태로 분리하여,
- 먼저 `load`를 1클록 발생시키고,
- 다음 클록에서 `req`를 toggle 하도록 설계하였다.

### 문제 2
2-phase handshake 완료 조건 정의

### 원인
- pulse 기반 handshake와 달리 2-phase handshake는 신호 토글이 이벤트이므로 완료 조건을 명확히 잡아야 했다.

### 해결
- `req_reg = ack`일 때 handshake 완료로 정의하였다.
- 즉, 송신기의 request 토글을 수신기가 동일한 값의 ack로 따라오면 전송 완료로 판단하였다.

### 문제 3
지연된 ack에 대한 동작 보장

### 원인
- 수신기 응답이 늦을 경우 상태가 prematurely 종료되면 안 된다.

### 해결
- `"11"` 상태에서 `req_reg = ack`가 될 때까지 유지하도록 설계하였다.
- test bench에서 delayed ack scenario를 추가해 실제로 검증하였다.

### 문제 4
검증 포인트 부족

### 원인
- 내부 `load` 신호를 외부에서 직접 볼 수 없으면 디버깅이 불편하다.

### 해결
- `load`를 top-level 출력 포트로 노출하여 simulation에서 직접 확인할 수 있게 하였다.

---

## 6. Discussion

### 슬라이드 제목
Discussion

### 발표 내용
- 이번 실습을 통해 handshake 기반 데이터 전송에서는 기능 구현뿐 아니라 신호 타이밍 정의가 매우 중요하다는 점을 확인했다.
- 특히 2-phase handshake는 단순히 `req`를 올리고 내리는 구조가 아니라, `toggle`의 의미를 정확히 이해해야 설계를 올바르게 구현할 수 있다.
- 또한 test bench를 다양한 예외 상황까지 포함해 작성해야 설계 신뢰성을 높일 수 있음을 확인했다.

### 확장 가능성
- 현재는 8-bit 단일 데이터 전송 구조이므로,
- 이후에는 데이터 폭 확장,
- receiver 모듈 추가,
- full handshake system 구성,
- timeout 또는 error handling 추가로 확장할 수 있다.

### 발표용 마무리 문장
- 이번 설계는 간단한 구조이지만, 비동기적 이벤트 동기화와 FSM 기반 제어를 연습하는 좋은 예제가 되었다.

---

## 7. Conclusion

### 슬라이드 제목
Conclusion

### 발표 내용
- `two_phase_handshake_transmitter`를 VHDL로 설계하였다.
- FSM 기반 제어와 data register를 분리하여 구조적으로 구현하였다.
- test bench 6개 scenario를 통해 정상 동작과 예외 상황을 검증하였다.
- RTL simulation으로 handshake sequence와 data transfer 결과를 확인하였다.

### 마지막 한 줄
- 결과적으로 본 설계는 2-phase handshake transmitter의 기본 동작을 성공적으로 구현하고 검증하였다.

---

## 발표 시 짧게 말하면 좋은 핵심 요약

- `ready`가 들어오면 데이터를 먼저 저장하고, 그 다음 `req`를 toggle 한다.
- `ack`가 같은 값으로 따라오면 한 번의 handshake가 완료된다.
- test bench에서는 정상 동작뿐 아니라 reset, delayed ack, 연속 전송까지 검증했다.
- simulation 결과로 설계 의도와 실제 파형이 일치함을 확인했다.

# Requirements

## Mission

Design an “one-counter” with the state machine design technique.

Report should include 
- VHDL code
- RTL Simulation capture
- Problems met during design & Solutions
- Discussion

Refer 
Pseuo-code : src\Lab02\Pseudo-code.vhdl
timing digram 
Shift register code : src\Lab02\4bit Parallel Load Serial input Shift register.vhdl

## Inputs

- A : 8bit data
- Load_A(LA)
- S : Start countiong indicator

## Outputs

- B : 4 bit data
- Done

## Funtion

- if 'Load' is 'true' then receive 8 bit data input 'A'
- If 'S' is '1' then count '1's in 'A's bitstream, and output the number to 'B', and set 'Done' to '1'.


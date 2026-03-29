LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY shift4 IS
    PORT ( 
    clock    : IN 	STD_LOGIC ;
	reset    : IN 	STD_LOGIC ;
	R 	     : IN 	STD_LOGIC_VECTOR(3 downto 0);
	Load, w	 : IN 	STD_LOGIC;
	Q	     : BUFFER 	STD_LOGIC_VECTOR(3 downto 0) 
    );
END shift4 ;

ARCHITECTURE behavior OF shift4 IS
BEGIN
	PROCESS(reset, clock)
	Begin
		IF(reset = '1') THEN
			Q <= (OTHERS => '0');
		ELSIF (clock = '1' AND clock'event) THEN
			IF (Load = '1') THEN
				Q <= R;
			ELSE
				Q(0) <= Q(1);
				Q(1) <= Q(2);
				Q(2) <= Q(3);
				Q(3) <= w;
			END IF;
		END IF;
	END Process;
END behavior;

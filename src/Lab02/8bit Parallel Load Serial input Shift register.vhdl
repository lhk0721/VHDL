LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY shift8 IS
    PORT ( 
    clock    : IN 	STD_LOGIC ;
	reset    : IN 	STD_LOGIC ;
	R 	     : IN 	STD_LOGIC_VECTOR(7 downto 0);
	Load, w	 : IN 	STD_LOGIC;
	Q	     : BUFFER 	STD_LOGIC_VECTOR(7 downto 0) 
    );
END shift8 ;

ARCHITECTURE behavior OF shift8 IS
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
				Q(3) <= Q(4);
				Q(4) <= Q(5);
				Q(5) <= Q(6);
				Q(6) <= Q(7);
				Q(7) <= w;
			END IF;
		END IF;
	END Process;
END behavior;

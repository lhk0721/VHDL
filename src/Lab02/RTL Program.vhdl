-- step1
B <- (OTHERS => '0');
Done <- 0;
-- step2~9
process(clk)
begin
    if rising_edge(clk) then
        for i in 0 to 7 loop
            if a0 = 1 then
                B = B + 1;
                Right-shift A;
            end if;
        end loop;
    end if;
    Done <- 1;
end process;




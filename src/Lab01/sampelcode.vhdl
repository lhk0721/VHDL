proc1: process (reset_n, clk) is
    begin
        if (reset_n = '0') then
            req <= '0';
            state <= "00"; -- state should be a 2-bit unsigned signal
        elsif rising_edge(clk) then -- on posedge clk
            state <= state + 1; -- auto-increment current state
    
            case (state) is
                when "00" =>
                    if (ready = '0') then
                        state <= "00"; -- repeat until ready
                    end if;
    
                when "01" =>
                    data <= data_in; -- assume data_in is data to be sent
    
                when "10" =>
                    req <= not req; -- send request signal
    
                when others =>
                    if (ack /= req) then -- case “11”
                        state <= "11"; -- stay in this state until (ack = req)
                    end if;
            end case;
        end if; -- of elsif rising_edge(clk)
    end process proc1;
    
-- ===========================================================
    architecture rtl of control_unit is
        signal state : std_logic_vector(1 downto 0);
    begin
    
        process(clk, reset_n)
        begin
            if reset_n = '0' then
                state <= "00";
                req <= '0';
                load <= '0';
    
            elsif rising_edge(clk) then
    
                case state is
    
                    when "00" => -- idle
                        load <= '0';
                        if ready = '1' then
                            state <= "01";
                        end if;
    
                    when "01" => -- load
                        load <= '1';
                        state <= "10";
    
                    when "10" => -- request toggle
                        load <= '0';
                        req <= not req;
                        state <= "11";
    
                    when others => -- wait ack
                        if ack = req then
                            state <= "00";
                        end if;
    
                end case;
            end if;
        end process;
    
    end architecture;

--===========================================================

architecture rtl of data_reg is
    begin
    
        process(clk, reset_n)
        begin
            if reset_n = '0' then
                data_out <= (others => '0');
    
            elsif rising_edge(clk) then
                if load = '1' then
                    data_out <= data_in;
                end if;
            end if;
        end process;
    
    end architecture;
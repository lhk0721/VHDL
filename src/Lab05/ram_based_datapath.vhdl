-- ===== entity =====
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY MUX is
    port(
        w0 : IN STD_LOGIC_VECTOR(3 downto 0);
        w1 : IN STD_LOGIC_VECTOR(3 downto 0);
        sel : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end MUX;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY AC is
    port(
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        load : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(3 downto 0);
        output : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end AC;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY ALU is
    port(
        op1 : IN STD_LOGIC_VECTOR(3 downto 0);
        op2 : IN STD_LOGIC_VECTOR(3 downto 0);
        sel : IN STD_LOGIC_VECTOR(2 downto 0);
        output : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end ALU;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY MAR is
    port(
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(2 downto 0);
        load : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(2 downto 0)
    );
end MAR;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY async_ram is
    port(
        input : IN STD_LOGIC_VECTOR(3 downto 0);
        address : IN STD_LOGIC_VECTOR(2 downto 0);
        wr : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end async_ram;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY ram_based_datapath is
    PORT(
        clock : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(3 downto 0);
        mux_sel : IN STD_LOGIC;
        ac_load : IN STD_LOGIC;
        alu_sel : IN STD_LOGIC_VECTOR(2 downto 0);
        mar_in : in STD_LOGIC_VECTOR(2 downto 0);
        mar_load : IN STD_LOGIC;
        ram_load : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(3 downto 0);
        -- debug ports
        dbg_alu_out : OUT STD_LOGIC_VECTOR(3 downto 0);
        dbg_mux_out : OUT STD_LOGIC_VECTOR(3 downto 0);
        dbg_mar_out : OUT STD_LOGIC_VECTOR(2 downto 0);
        dbg_ram_out : OUT STD_LOGIC_VECTOR(3 downto 0)
    );
end ram_based_datapath;

-- ===== architecture =====
LIBRARY ieee;
USE ieee.std_logic_1164.all;
architecture behavioral of MUX is 
BEGIN
    PROCESS(w0, w1, sel)
    BEGIN
        case sel is
            when '0' =>
                output <= w0;

            when '1' =>
                output <= w1;
            
            when others => 
                output <= (others => 'X');
        END case;        
    END PROCESS;
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
architecture behavioral of AC is 
BEGIN
    process(clock, reset_n)
    begin
        if (reset_n = '0') then
            output <= (others => '0');
        elsif rising_edge(clock) then 
            if load = '1' then
                output <= input;
            end if;
        end if;
    end process;
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
architecture behavioral of ALU is 
begin
    process(op1, op2, sel)
    begin
        case sel is
            when "000" => 
                output <= op1;
            when "001" => 
                output <= op2;
            when "010" => 
                output <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
            when "011" => 
                output <= STD_LOGIC_VECTOR(unsigned(op1) - unsigned(op2));
            when "100" => 
                output <= op1 and op2;
            when "101" => 
                output <= op1 or op2;
            when "110" => 
                output <= op1 xor op2;
            when others =>
                output <= not op1;
        end case;
    end process;
end behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
architecture behavioral of MAR is 
begin
    process(clock, reset_n)
    begin
        if (reset_n = '0') then
            output <= "000";
        elsif rising_edge(clock) then 
            if(load = '1') then
                output <= input;
            end if;
        end if;
    end process;
end behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
architecture rtl of async_ram is 
    type MEM is array(7 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    signal ram_block : MEM;
begin 
    process(input, address, wr)
    begin
        if(wr = '1') then --write
            ram_block(to_integer(unsigned(address))) <= input;
        end if;
        output <= ram_block(to_integer(unsigned(address)));
    end process;
end rtl;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
architecture structural of ram_based_datapath is
    signal alu_out : STD_LOGIC_VECTOR(3 downto 0);
    signal mux_out : STD_LOGIC_VECTOR(3 downto 0);
    signal ac_out : STD_LOGIC_VECTOR(3 downto 0);
    signal mar_out : STD_LOGIC_VECTOR(2 downto 0);
    signal ram_out : STD_LOGIC_VECTOR(3 downto 0);
begin
    MUX : entity work.MUX
        port map(
            w0 => input,
            w1 => alu_out,
            sel => mux_sel,
            output => mux_out
        );

    AC : entity work.AC
        port map(
            clock => clock,
            reset_n => reset_n,
            load => ac_load,
            input => mux_out,
            output => ac_out
        );
        output <= ac_out;

    ALU : entity work.ALU
        port map(
            op1 => ac_out,
            op2 => ram_out,
            sel => alu_sel,
            output => alu_out
        );

    MAR : entity work.MAR
        port map(
            clock => clock,
            reset_n => reset_n,
            input => mar_in,
            load => mar_load,
            output => mar_out
        );

    ASYNC_RAM : entity work.async_ram
        port map(
            input => alu_out,
            address => mar_out,
            wr => ram_load,
            output => ram_out
        );

    dbg_alu_out <= alu_out;
    dbg_mux_out <= mux_out;
    dbg_mar_out <= mar_out;
    dbg_ram_out <= ram_out;

end structural;

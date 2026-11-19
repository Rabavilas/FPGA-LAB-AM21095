library ieee;
use ieee.std_logic_1164.all;

-- Timing-analysis wrapper: registers the ALU inputs and output.
entity alu_timing_top is
    port (
        clk  : in  std_logic;                     -- 50 MHz (PIN_P11)
        ac   : in  std_logic_vector(7 downto 0);  -- Virtual pins
        db   : in  std_logic_vector(7 downto 0);  -- Virtual pins
        alus : in  std_logic_vector(7 downto 1);  -- ALU control bits 1 through 7
        dout : out std_logic_vector(7 downto 0)   -- Virtual pins
    );
end alu_timing_top;

architecture arc of alu_timing_top is
    signal ac_r   : std_logic_vector(7 downto 0);
    signal db_r   : std_logic_vector(7 downto 0);
    signal alus_r : std_logic_vector(7 downto 0);
    signal dout_c : std_logic_vector(7 downto 0);
begin

    -- The ALU uses control indices 1 through 7; index 0 is unused.
    alus_r(7 downto 1) <= alus;
    alus_r(0) <= '0';

    -- Register inputs and the ALU result on each rising clock edge.
    process (clk)
    begin
        if rising_edge(clk) then
            ac_r <= ac;
            db_r <= db;
            dout <= dout_c;
        end if;
    end process;

    alu_i : entity work.alu
        port map (
            ac   => ac_r,
            db   => db_r,
            alus => alus_r,
            dout => dout_c
        );
end architecture arc;

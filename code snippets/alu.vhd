library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alulib.all;

entity alu is 
    generic (
        n : positive := 8
    );
    port (
        ac : in std_logic_vector(n-1 downto 0); -- accumulator
        db : in std_logic_vector(n-1 downto 0); -- data bus
        alus : in std_logic_vector(7 downto 0); -- select 
        dout : out std_logic_vector(n-1 downto 0) -- data out
    );
end entity alu;

architecture arch of alu is 
    signal arithmetic_temp1 : std_logic_vector(n - 1 downto 0);
    signal arithmetic_temp2 : std_logic_vector(n - 1 downto 0);
    signal db_bar : std_logic_vector(n - 1 downto 0);
    signal au_out : std_logic_vector(n - 1 downto 0);
    signal lu_out : std_logic_vector(n - 1 downto 0);
    
begin
    db_bar <= not db;

    arithmetic_mux2 : mux2
        generic map (
            n => n
        )
        port map (
            a   => (others => '0'),
            b   => ac,
            sel => alus(1),
            y   => arithmetic_temp1
        );
    
    arithmetic_mux3 : mux4
        generic map (
            n => n
        )
        port map (
            a   => (others => '0'),
            b   => db,
            c   => db_bar,
            d   => (others => '0'),
            sel => alus(2) & alus(3),
            y   => arithmetic_temp2
        );

    arithmetic_adder : adder_para_nbit
        generic map (
            n => n
        )
        port map (
            a    => arithmetic_temp1,
            b    => arithmetic_temp2,
            cin  => alus(4),
            s    => au_out,
            cout => open
        );

    logic_mux4 : mux4
        generic map (
            n => n
        )
        port map (
            a   => ac and db,
            b   => ac or db,
            c   => ac xor db,
            d   => not ac,
            sel => alus(5) & alus(6),
            y   => lu_out
        );

    output_mux : mux2
        generic map (
            n => n
        )
        port map (
            a   => au_out,
            b   => lu_out,
            sel => alus(7),
            y   => dout
        );
end architecture arch;

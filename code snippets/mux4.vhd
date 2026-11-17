library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
   generic (
      n : positive := 8
   );

   port (
        a : in std_logic_vector(n-1 downto 0);
        b : in std_logic_vector(n-1 downto 0);
        c : in std_logic_vector(n-1 downto 0);
        d : in std_logic_vector(n-1 downto 0);
        sel : in std_logic_vector(1 downto 0);
        y : out std_logic_vector(n-1 downto 0)
   );
end entity mux4;

architecture behavior of mux4 is
begin
    with sel select
        y <= a when "00",
             b when "01",
             c when "10",
             d when "11",
             (others => '0') when others;
end architecture behavior;
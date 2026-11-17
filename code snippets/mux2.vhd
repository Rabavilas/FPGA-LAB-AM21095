library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
   generic (
      n : positive := 8
   );

   port (
        a : in std_logic_vector(n-1 downto 0);
        b : in std_logic_vector(n-1 downto 0);
        sel : in std_logic;
        y : out std_logic_vector(n-1 downto 0)
   );
end entity mux2;

architecture behavior of mux2 is
begin
    with sel select
        y <= a when '0',
             b when '1';
             (others => '0') when others;
end architecture behavior;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regnbit is
    generic (
        n : positive := 8
    );

    port (
        clk     : in std_logic;
        rst     : in std_logic;
        ld      : in std_logic;
        inc     : in std_logic;
        din     : in std_logic_vector(n-1 downto 0);
        dout    : out std_logic_vector(n-1 downto 0)   
    );
end entity regnbit;

architecture rtl of regnbit is
    signal temp : std_logic_vector(n-1 downto 0);

begin
    process(clk,rst)
    begin
        if rst = '0' then -- active low
            temp <= (others => '0'); --all bits to 0
        elsif rising_edge(clk) then
            if ld = '1' then
                temp <= din;
            elsif inc = '1' then
                temp <= std_logic_vector(unsigned(temp) + 1);
            end if;
        end if;
    end process;
    dout <= temp;

end architecture;

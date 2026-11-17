library ieee;
use ieee.std_logic_1164.all;

entity adder_para_nbit is
    generic (
        n : positive := 8
    );

    port (
        a       : in std_logic_vector(n-1 downto 0);
        b       : in std_logic_vector(n-1 downto 0);
        cin     : in std_logic;
        s       : out std_logic_vector(n-1 downto 0);
        cout    : out std_logic
    );
end entity adder_para_nbit;

architecture structural of adder_para_nbit is
    signal carry : std_logic_vector(n downto 0);
begin
    carry(0) <= cin;
    cout <= carry(n);

    bit_adders : for i in 0 to n - 1 generate
        full_adder_i : entity work.adder1bit
            port map (
                a    => a(i),
                b    => b(i),
                cin  => carry(i),
                s    => s(i),
                cout => carry(i + 1)
            );
    end generate bit_adders;
end architecture structural;
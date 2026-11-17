library ieee;
use ieee.std_logic_1164.all;

package alulib is
    component adder1bit is
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            cin  : in  std_logic;
            s    : out std_logic;
            cout : out std_logic
        );
    end component adder1bit;

    component adder_para_nbit is
        generic (
            n : positive := 8
        );
        port (
            a    : in  std_logic_vector(n - 1 downto 0);
            b    : in  std_logic_vector(n - 1 downto 0);
            cin  : in  std_logic;
            s    : out std_logic_vector(n - 1 downto 0);
            cout : out std_logic
        );
    end component adder_para_nbit;

    component mux2 is
        generic (
            n : positive := 8
        );
        port (
            a   : in  std_logic_vector(n - 1 downto 0);
            b   : in  std_logic_vector(n - 1 downto 0);
            sel : in  std_logic;
            y   : out std_logic_vector(n - 1 downto 0)
        );
    end component mux2;

    component mux4 is
        generic (
            n : positive := 8
        );
        port (
            a   : in  std_logic_vector(n - 1 downto 0);
            b   : in  std_logic_vector(n - 1 downto 0);
            c   : in  std_logic_vector(n - 1 downto 0);
            d   : in  std_logic_vector(n - 1 downto 0);
            sel : in  std_logic_vector(1 downto 0);
            y   : out std_logic_vector(n - 1 downto 0)
        );
    end component mux4;

    component regnbit is
        generic (
            n : positive := 8
        );
        port (
            clk  : in  std_logic;
            rst  : in  std_logic;
            ld   : in  std_logic;
            inc  : in  std_logic;
            din  : in  std_logic_vector(n - 1 downto 0);
            dout : out std_logic_vector(n - 1 downto 0)
        );
    end component regnbit;
end package alulib;

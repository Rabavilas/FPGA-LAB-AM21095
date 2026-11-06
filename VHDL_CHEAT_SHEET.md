# VHDL Cheat Sheet

A quick reference for writing synthesizable VHDL. Examples use `ieee.std_logic_1164` and `ieee.numeric_std`.

## Basic file structure

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_block is
    generic (
        WIDTH : positive := 8
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        a     : in  std_logic_vector(WIDTH - 1 downto 0);
        y     : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity my_block;

architecture rtl of my_block is
    signal result : unsigned(WIDTH - 1 downto 0);
begin
    -- Concurrent statements go here.
    y <= std_logic_vector(result);
end architecture rtl;
```

- The **entity** declares the block's interface; the **architecture** describes its behavior.
- `in`, `out`, and `inout` describe port direction. Prefer `in` and `out` for ordinary logic.
- Declarations go before `begin`; concurrent statements go after it.
- VHDL is case-insensitive, but consistent naming improves readability.

## Types and useful operators

| Type | Typical use |
|---|---|
| `std_logic` | Single digital signal (`'0'`, `'1'`, `'Z'`, `'X'`, etc.) |
| `std_logic_vector(N downto 0)` | Collection of logic bits; not inherently a number |
| `unsigned(N downto 0)` | Non-negative arithmetic |
| `signed(N downto 0)` | Two's-complement arithmetic |
| `integer` / `natural` | General integer values; constrain ranges in hardware-facing declarations |

Use `numeric_std` for arithmetic. Convert explicitly between vectors and numeric types:

```vhdl
signal bits : std_logic_vector(7 downto 0);
signal count : unsigned(7 downto 0);

count <= unsigned(bits);
bits  <= std_logic_vector(count);
count <= count + 1;
```

Common operators:

- Logic: `and`, `or`, `not`, `xor`, `nand`, `nor`
- Compare: `=`, `/=`, `<`, `<=`, `>`, `>=`
- Arithmetic: `+`, `-`, `*`, `/`, `mod`, `rem`
- Concatenate: `&` (for example, `'0' & bits`)
- Assignment: `<=` for signals; `:=` for variables

## Concurrent logic

Concurrent assignments continuously describe logic and are written outside a process:

```vhdl
sum  <= a + b;
flag <= '1' when a = b else '0';
```

Conditional assignment is useful for simple muxes. For more branches, use a `process` with `if` or `case`.

## Combinational process

```vhdl
process(all)  -- VHDL-2008
begin
    y <= '0';                 -- Default prevents a latch.
    if select = '1' then
        y <= a;
    else
        y <= b;
    end if;
end process;
```

- Assign every output on every possible path; otherwise synthesis may infer a latch.
- With older VHDL versions, list every read signal in the sensitivity list instead of using `process(all)`.
- A `case` is often clearer for decoders and state machines:

```vhdl
process(all)
begin
    case state is
        when IDLE   => next_state <= RUN;
        when RUN    => next_state <= DONE;
        when DONE   => next_state <= IDLE;
        when others => next_state <= IDLE;
    end case;
end process;
```

## Clocked process and register

```vhdl
process(clk)
begin
    if rising_edge(clk) then
        q <= d;
    end if;
end process;
```

### Synchronous reset

Reset is checked only on the active clock edge:

```vhdl
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            q <= '0';
        else
            q <= d;
        end if;
    end if;
end process;
```

### Asynchronous reset

Reset takes effect independently of the clock. Include it in the sensitivity list:

```vhdl
process(clk, reset)
begin
    if reset = '1' then
        q <= '0';
    elsif rising_edge(clk) then
        q <= d;
    end if;
end process;
```

Use the reset polarity and style required by your FPGA design or lab specification.

## Counter example

```vhdl
signal count : unsigned(3 downto 0);

process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            count <= (others => '0');
        else
            count <= count + 1;
        end if;
    end if;
end process;
```

`(others => '0')` fills every bit with zero. A fixed-width unsigned counter wraps around when it overflows.

## Variables, signals, and assignment timing

- **Signals** (`<=`) are used for ports and inter-process connections. Signal updates take effect after the process suspends.
- **Variables** (`:=`) are local to a process and update immediately within that process.
- In a clocked process, multiple assignments to the same signal in one activation leave the last scheduled assignment in effect.

```vhdl
process(clk)
    variable temp : unsigned(7 downto 0);
begin
    if rising_edge(clk) then
        temp := unsigned(a) + unsigned(b); -- Immediate variable update.
        result <= temp;                    -- Signal update is scheduled.
    end if;
end process;
```

## Quick checklist

- Include `use ieee.numeric_std.all;` when doing numeric arithmetic.
- Choose `unsigned` or `signed` for values used as numbers; convert to/from `std_logic_vector` at interfaces as needed.
- Use `rising_edge(clk)` (or `falling_edge(clk)`) for clocked logic.
- Give combinational outputs a value on every path to avoid unintended latches.
- Check vector widths, index directions, reset behavior, and counter overflow.
- Keep clocked and combinational logic in separate, clearly structured processes.
- Simulate and check synthesis warnings before relying on the hardware behavior.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_counter_bcd is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;  -- synchronous reset, active-high
    tick_10ms : in  std_logic;
    run_en    : in  std_logic;
    reset_p   : in  std_logic;  -- pulse reset (debounced)
    d0        : out std_logic_vector(3 downto 0); -- hundredths ones
    d1        : out std_logic_vector(3 downto 0); -- hundredths tens
    d2        : out std_logic_vector(3 downto 0); -- seconds ones
    d3        : out std_logic_vector(3 downto 0)  -- seconds tens
  );
end entity;

architecture rtl of time_counter_bcd is
  signal r0, r1, r2, r3 : unsigned(3 downto 0) := (others => '0');
begin
  d0 <= std_logic_vector(r0);
  d1 <= std_logic_vector(r1);
  d2 <= std_logic_vector(r2);
  d3 <= std_logic_vector(r3);

  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (reset_p = '1') then
        r0 <= (others => '0');
        r1 <= (others => '0');
        r2 <= (others => '0');
        r3 <= (others => '0');

      elsif (tick_10ms = '1') and (run_en = '1') then
        if r0 = 9 then
          r0 <= (others => '0');
          if r1 = 9 then
            r1 <= (others => '0');
            if r2 = 9 then
              r2 <= (others => '0');
              if r3 = 9 then
                r3 <= (others => '0'); -- wrap 99.99 -> 00.00
              else
                r3 <= r3 + 1;
              end if;
            else
              r2 <= r2 + 1;
            end if;
          else
            r1 <= r1 + 1;
          end if;
        else
          r0 <= r0 + 1;
        end if;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity run_toggle is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;      -- synchronous reset, active-high
    toggle_p : in  std_logic;
    run_en   : out std_logic
  );
end entity;

architecture rtl of run_toggle is
  signal r : std_logic := '0';
begin
  run_en <= r;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        r <= '0';
      else
        if toggle_p = '1' then
          r <= not r;
        end if;
      end if;
    end if;
  end process;
end architecture;

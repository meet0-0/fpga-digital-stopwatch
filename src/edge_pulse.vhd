library ieee;
use ieee.std_logic_1164.all;

entity edge_pulse is
  port (
    clk        : in  std_logic;
    rst        : in  std_logic;     -- synchronous reset, active-high
    sig_in     : in  std_logic;
    rise_pulse : out std_logic
  );
end entity;

architecture rtl of edge_pulse is
  signal prev : std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        prev       <= '0';
        rise_pulse <= '0';
      else
        rise_pulse <= sig_in and (not prev);
        prev       <= sig_in;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tick_gen is
  generic (
    CLK_HZ : integer := 100_000_000
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;      -- synchronous reset, active-high
    tick_1ms  : out std_logic;      -- 1-cycle pulse
    tick_10ms : out std_logic       -- 1-cycle pulse
  );
end entity;

architecture rtl of tick_gen is
  constant C_1MS  : integer := CLK_HZ / 1000;   -- 100_000 for 100MHz
  constant C_10MS : integer := CLK_HZ / 100;    -- 1_000_000 for 100MHz

  signal cnt_1ms  : integer range 0 to C_1MS-1  := 0;
  signal cnt_10ms : integer range 0 to C_10MS-1 := 0;

  signal t1  : std_logic := '0';
  signal t10 : std_logic := '0';
begin
  tick_1ms  <= t1;
  tick_10ms <= t10;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        cnt_1ms  <= 0;
        cnt_10ms <= 0;
        t1  <= '0';
        t10 <= '0';
      else
        -- default: no tick
        t1  <= '0';
        t10 <= '0';

        -- 1ms tick
        if cnt_1ms = C_1MS - 1 then
          cnt_1ms <= 0;
          t1 <= '1';
        else
          cnt_1ms <= cnt_1ms + 1;
        end if;

        -- 10ms tick
        if cnt_10ms = C_10MS - 1 then
          cnt_10ms <= 0;
          t10 <= '1';
        else
          cnt_10ms <= cnt_10ms + 1;
        end if;
      end if;
    end if;
  end process;
end architecture;

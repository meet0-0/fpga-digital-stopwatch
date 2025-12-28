library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
  generic (
    STABLE_MS : integer := 20
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;      -- synchronous reset, active-high
    tick_1ms  : in  std_logic;
    btn_raw   : in  std_logic;
    btn_clean : out std_logic
  );
end entity;

architecture rtl of debounce is
  signal last_sample : std_logic := '0';
  signal stable_cnt  : integer range 0 to STABLE_MS := 0;
  signal clean       : std_logic := '0';
begin
  btn_clean <= clean;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        last_sample <= '0';
        stable_cnt  <= 0;
        clean       <= '0';
      else
        if tick_1ms = '1' then
          if btn_raw = last_sample then
            -- still stable, count up to threshold
            if stable_cnt < STABLE_MS then
              stable_cnt <= stable_cnt + 1;
            end if;
          else
            -- changed, restart stability window
            stable_cnt  <= 0;
            last_sample <= btn_raw;
          end if;

          -- update output once stable long enough
          if stable_cnt = STABLE_MS then
            clean <= last_sample;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;

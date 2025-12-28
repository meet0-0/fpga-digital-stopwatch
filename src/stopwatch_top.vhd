library ieee;
use ieee.std_logic_1164.all;

entity stopwatch_top is
  port (
    clk  : in  std_logic;  
    btnU : in  std_logic;  -- start/stop toggle
    btnC : in  std_logic;  -- reset

    seg  : out std_logic_vector(6 downto 0);
    dp   : out std_logic;
    an   : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of stopwatch_top is
  signal tick_1ms  : std_logic;
  signal tick_10ms : std_logic;

  signal btnU_db, btnC_db : std_logic;
  signal start_p, reset_p : std_logic;

  signal run_en : std_logic;

  signal d0, d1, d2, d3 : std_logic_vector(3 downto 0);
begin
  -- Tick generator runs always (no button-based reset!)
  tg: entity work.tick_gen
    port map (
      clk       => clk,
      rst       => '0',
      tick_1ms  => tick_1ms,
      tick_10ms => tick_10ms
    );

  dbU: entity work.debounce
    generic map ( STABLE_MS => 20 )
    port map (
      clk       => clk,
      rst       => '0',
      tick_1ms  => tick_1ms,
      btn_raw   => btnU,
      btn_clean => btnU_db
    );

  dbC: entity work.debounce
    generic map ( STABLE_MS => 20 )
    port map (
      clk       => clk,
      rst       => '0',
      tick_1ms  => tick_1ms,
      btn_raw   => btnC,
      btn_clean => btnC_db
    );

  epU: entity work.edge_pulse
    port map (
      clk        => clk,
      rst        => '0',
      sig_in     => btnU_db,
      rise_pulse => start_p
    );

  epC: entity work.edge_pulse
    port map (
      clk        => clk,
      rst        => '0',
      sig_in     => btnC_db,
      rise_pulse => reset_p
    );

  -- Reset run state on reset_p, toggle on start_p
  rt: entity work.run_toggle
    port map (
      clk      => clk,
      rst      => reset_p,
      toggle_p => start_p,
      run_en   => run_en
    );

  tc: entity work.time_counter_bcd
    port map (
      clk       => clk,
      rst       => '0',
      tick_10ms => tick_10ms,
      run_en    => run_en,
      reset_p   => reset_p,
      d0        => d0,
      d1        => d1,
      d2        => d2,
      d3        => d3
    );

  dm: entity work.display_mux
    port map (
      clk      => clk,
      rst      => '0',
      tick_1ms => tick_1ms,
      d0       => d0,
      d1       => d1,
      d2       => d2,
      d3       => d3,
      seg      => seg,
      dp       => dp,
      an       => an
    );
end architecture;

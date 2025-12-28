library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_mux is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic; -- synchronous reset, active-high
    tick_1ms : in  std_logic;

    d0 : in std_logic_vector(3 downto 0);
    d1 : in std_logic_vector(3 downto 0);
    d2 : in std_logic_vector(3 downto 0);
    d3 : in std_logic_vector(3 downto 0);

    seg : out std_logic_vector(6 downto 0);
    dp  : out std_logic;
    an  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of display_mux is
  signal idx     : unsigned(1 downto 0) := (others => '0');
  signal cur_bcd : std_logic_vector(3 downto 0) := (others => '0');
  signal seg_i   : std_logic_vector(6 downto 0);

  component sevenseg_decoder is
    port (
      bcd : in  std_logic_vector(3 downto 0);
      seg : out std_logic_vector(6 downto 0)
    );
  end component;
begin
  dec: sevenseg_decoder
    port map (
      bcd => cur_bcd,
      seg => seg_i
    );

  seg <= seg_i;

  -- scan index increments every 1ms:
  -- 1kHz scan / 4 digits => 250Hz per digit (no flicker)
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        idx <= (others => '0');
      else
        if tick_1ms = '1' then
          idx <= idx + 1;
        end if;
      end if;
    end if;
  end process;

  -- Active-low anodes (Basys3 typical): an(3)=leftmost ... an(0)=rightmost
  -- Display format: d3 d2 . d1 d0  =>  SS.hh
  process(idx, d0, d1, d2, d3)
  begin
    case idx is
      when "00" =>
        -- leftmost
        cur_bcd <= d3;
        an <= "0111";  -- enable an3
        dp <= '1';

      when "01" =>
        cur_bcd <= d2;
        an <= "1011";  -- enable an2
        dp <= '0';     -- dp ON here => SS.hh separator

      when "10" =>
        cur_bcd <= d1;
        an <= "1101";  -- enable an1
        dp <= '1';

      when others =>
        -- rightmost
        cur_bcd <= d0;
        an <= "1110";  -- enable an0
        dp <= '1';
    end case;
  end process;
end architecture;

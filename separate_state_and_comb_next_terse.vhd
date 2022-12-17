
-- Identical to separate_state_and_comb_next, but without explicitly calling out register values that don't change

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity separate_state_and_comb_next_terse is
  port (
    iClk                : in std_logic;
    iReset              : in std_logic;
    iData               : in std_logic;
    oParity             : out std_logic :='0'
  ) ;
end entity ; -- separate_state_and_comb_next_terse

architecture rtl of separate_state_and_comb_next_terse is

  type state_type is (S0, S1);
  signal state, next_state : state_type;

  signal parity_comb : std_logic := '0';

begin

  RESET_PROC : process (iClk)
  begin
    if rising_edge(iClk) then
      if (iReset = '1') then
        state <= S0;
      else
        state <= next_state;
      end if;
    end if;
  end process;

  -- Register output without reset
  SYNC_PROC : process (iClk)
  begin
    if rising_edge(iClk) then
      oParity <= parity_comb;
    end if;
  end process;

  NEXT_STATE_DECODE : process (state, iData)
  begin
    parity_comb <= '0';
    case (state) is
      when S0 =>
        if (iData = '1') then
          parity_comb <= '1';
          next_state  <= S1;
        -- else
        --   next_state  <= S0;
        end if;
      when S1 =>
        if (iData = '1') then
          next_state  <= S0;
        else
          parity_comb <= '1';
          -- next_state  <= S1;
        end if;
      when others =>
        next_state <= S0;
    end case;
  end process;

end architecture ; -- rtl

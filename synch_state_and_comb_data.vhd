
-- Synchronous State transitions with Synchronous Reset
-- Asynchronous data, registered on output (no reset)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synch_state_and_comb_data is
  port (
    iClk                : in std_logic;
    iReset              : in std_logic;
    iData               : in std_logic;
    oParity             : out std_logic :='0'
  ) ;
end entity ; -- synch_state_and_comb_data

architecture rtl of synch_state_and_comb_data is

  type state_type is (S0, S1);
  signal state : state_type;

  signal parity_comb : std_logic := '0';

begin

  RESET_PROC : process (iClk)
  begin
    if rising_edge(iClk) then
      if (iReset = '1') then
        state <= S0;
      else
        case (state) is
          when S0 =>
            if (iData = '1') then
              state  <= S1;
            else
              state  <= S0;
            end if;
          when S1 =>
            if (iData = '1') then
              state  <= S0;
            else
              state  <= S1;
            end if;
          when others =>
            state <= S0;
    end case;
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

  DATA_PROC : process (state, iData)
  begin
    parity_comb <= '0';
    case (state) is
      when S0 =>
        if (iData = '1') then
          parity_comb <= '1';
        end if;
      when S1 =>
        if (iData = '1') then
          null;
        else
          parity_comb <= '1';
        end if;
    end case;
  end process;

end architecture ; -- rtl

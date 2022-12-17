
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Standared State Machine
entity single_process is
  port (
    iClk                : in std_logic;
    iReset              : in std_logic;
    iData               : in std_logic;
    oParity             : out std_logic :='0'
  ) ;
end entity single_process;

architecture rtl of single_process is

  type state_t is (S0, S1);
  signal state     : state_t     := S0;

begin

  single_process_proc : process( iClk )
  begin
    if( rising_edge(iClk) ) then
      if (iReset = '1') then
        state <= S0;
      else
        oParity <= '0';
        case state is
          when S0 =>
            if iData = '1' then
              oParity <= '1';
              state <= S1;
            end if ;
            
          when S1 =>
            if iData = '1' then
              state <= S0;
            else
              oParity <= '1';
            end if ;
            
          when others => 
            state <= S0;
        end case;
      end if;
    end if ;
  end process ; -- single_process_proc 


end architecture ; -- rtl
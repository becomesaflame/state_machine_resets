
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Standared State Machine
entity separate_state_machine is
  port (
    iClk                : in std_logic;
    iReset              : in std_logic;
    iData               : in std_logic;
    oParity             : out std_logic :='0'
  ) ;
end entity separate_state_machine;

architecture rtl of separate_state_machine is

  type state_t is (S0, S1);
  signal state     : state_t     := S0;

begin

  separate_state_machine_control_proc : process( iClk )
  begin
    if( rising_edge(iClk) ) then
      if (iReset = '1') then
        state <= S0;
      else
        -- oParity <= '0';
        case state is
          when S0 =>
            if iData = '1' then
              -- oParity <= '1';
              state <= S1;
            end if ;
            
          when S1 =>
            if iData = '1' then
              state <= S0;
            -- else
            --   oParity <= '1';
            end if ;
            
          when others => 
            state <= S0;
        end case;
      end if;
    end if ;
  end process ; -- separate_state_machine_control_proc 

  separate_state_machine_data_proc : process( iClk )
  begin
    if( rising_edge(iClk) ) then
      -- if (iReset = '1') then
      --   state <= S0;
      -- else
        oParity <= '0';
        case state is
          when S0 =>
            if iData = '1' then
              oParity <= '1';
              -- state <= S1;
            end if ;
            
          when S1 =>
            if iData = '1' then
              -- state <= S0;
              null;
            else
              oParity <= '1';
            end if ;
            
          when others => 
            -- state <= S0;
            null;
        end case;
      -- end if;
    end if ;
  end process ; -- separate_state_machine_data_proc 


end architecture ; -- rtl
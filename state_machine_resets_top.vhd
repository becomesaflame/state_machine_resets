-- Tool versions: Vivado 2018.1, Quartus Prime Pro 19.2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Standared State Machine
entity state_machine_resets_top is
  port (
    iClk                : in std_logic;
    iReset              : in std_logic;
    iData               : in std_logic;
    oParity             : out std_logic_vector(7 downto 0)
  ) ;
end entity state_machine_resets_top;

architecture rtl of state_machine_resets_top is

begin

  -- One clocked process with synchronous reset
  -- state transitions are reset
  -- data not reset, but is set in same state machine
  single_process_1 : entity work.single_process
    port map (
      iClk      => iClk,
      iReset    => iReset,
      iData     => iData,
      oParity   => oParity(0)
    );
  -- Results:
  -- Vivado: Creates clock enable on data register. Also uses enable on state register. 1 logic level
  -- Quartus: Reset uses enable input on data register. Muxes with Din for data
  --    register. Uses 2 logic levels plus reset mux for state register. 
  --    Very similar to separate_state_machine, with the addition of enable
  -- Maintainability: Great


    -- Two separate synchronous process. State proc has reset, data proc does not
  separate_state_machine_1 : entity work.separate_state_machine
    port map (
      iClk      => iClk,
      iReset    => iReset,
      iData     => iData,
      oParity   => oParity(1)
    );
  -- Results:
  -- Vivado: Reset is correct. Uses clock enable for state reg. 1 logic level
  -- Quartus: Reset muxes state Din. Creates the same 2-level logic as bottom_state_machine. 3 logic levels total. Parity LUT ok
  -- Maintainability: garbage


  -- One synchronous process for data and state.
  -- Reset is at the bottom, with an if statement that overrides the state value
  bottom_state_machine_1 : entity work.bottom_state_machine
    port map (
      iClk      => iClk,
      iReset    => iReset,
      iData     => iData,
      oParity   => oParity(2)
    );
  -- Vivado synthesises it well - identical to separate_state_and_comb_next 
  --    except that the parity LUT is duplicated for no good reason.
  --    Maybe this will get fixed in optimization?
  --    1 logic level
  -- Quartus: Reset is correct. State Din is separate from parity Din and uses 2 logic levels. Parity LUT ok
  -- Maintainability: Great


  -- Textbook method - based on Xilinx example
  -- Split process - sequential state transitions, combinatorial data outputs
  -- uses combinatorial next_state
  -- synch reset
  separate_state_and_comb_next_1 : entity work.separate_state_and_comb_next
    port map (
      iClk      => iClk,
      iReset    => iReset,
      iData     => iData,
      oParity   => oParity(5)
    );
  -- Results:
  -- Vivado synthesises it beautifully. Reset is correct, no extra garbage. Smart enough to see that the inputs to both registers are the same.
  -- Quartus screws it all up. Instead of using the reset, they use the reset to mux the state Din with 0. Adds a second layer of logic
  -- Maintainability: Okay. Need to work in combinatorial logic, and register outputs separately. 

  -- BROKEN (infers latches)
  -- -- Same as separate_state_and_comb_next without explicit register values when they don't change
  -- separate_state_and_comb_next_terse_1 : entity work.separate_state_and_comb_next_terse
  --   port map (
  --     iClk      => iClk,
  --     iReset    => iReset,
  --     iData     => iData,
  --     oParity   => oParity(6)
  --   );
  -- -- Results:
  -- -- Because next_state is combinatorial, latches are inferred when some conditionals are not defined


  -- Split process - sequential state transitions, combinatorial data outputs
  -- no next_state
  -- synch reset
  synch_state_and_comb_data_1 : entity work.synch_state_and_comb_data
    port map (
      iClk      => iClk,
      iReset    => iReset,
      iData     => iData,
      oParity   => oParity(7)
    );
  -- Results:
  -- Xilinx: Perfect - identical to separate_state_and_comb_next
  -- Quartus: Identical to separate_state_and_comb_next, but duplicates the parity LUT for no good reason. 2 logic levels
  -- Maintainability: garbage

end architecture ; -- rtl
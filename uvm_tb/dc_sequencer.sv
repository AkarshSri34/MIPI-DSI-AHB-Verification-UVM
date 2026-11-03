class dc_sequencer extends uvm_sequencer#(dc_transaction);
  `uvm_component_utils(dc_sequencer)
  function new(string name="dc_sequencer",uvm_component parent);
    super.new(name,parent); 
  endfunction
endclass

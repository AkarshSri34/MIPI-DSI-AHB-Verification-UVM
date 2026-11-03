`include "dc_sequencer.sv"
`include "dc_driver.sv"
`include "dc_monitor.sv"
class dc_agent extends uvm_agent;
  `uvm_component_utils(dc_agent)
  function new(string name="dc_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  dc_sequencer sqr;
  dc_driver drv;
  dc_monitor mon;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=dc_sequencer::type_id::create("sqr",this);
    drv=dc_driver::type_id::create("drv",this);
    mon=dc_monitor::type_id::create("mon",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass

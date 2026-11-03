`include "dc_sequence.sv"
`include "dc_env.sv"
class dc_test extends uvm_test;
  `uvm_component_utils(dc_test)
  function new(string name="dc_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  dc_sequence sq;
  dc_env env;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sq=dc_sequence::type_id::create("sq");
    env=dc_env::type_id::create("env",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    sq.start(env.act_agn.sqr);
    #500;
    phase.drop_objection(this);
  endtask
    
  
endclass

`include "dc_agent.sv"
class dc_env extends uvm_env;
  `uvm_component_utils(dc_env)
  function new(string name="dc_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
 // dc_scoreboard scb;
  dc_agent act_agn;
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //scb=dc_scoreboard::type_id::create("scb",this);
    act_agn=dc_agent::type_id::create("act_agn",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   // act_agn.mon.dc_send_data.connect(scb.dc_collect_item);
  endfunction
 
endclass

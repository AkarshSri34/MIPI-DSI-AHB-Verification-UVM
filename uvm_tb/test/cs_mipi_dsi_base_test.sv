`ifndef CS_MIPI_DSI_BASE_TEST
`define CS_MIPI_DSI_BASE_TEST
`include "cs_base_test.sv"
`include "cs_mipi_dsi_env.sv"
`include "ahb_master_wr_rd_sequence.sv"
`include "pixel_sequence.sv"
class cs_mipi_dsi_base_test extends cs_base_test;
  cs_mipi_dsi_env         env;
  cs_mipi_dsi_env_cfg     env_cfg;
  
ahb_master_wr_rd_sequence ahb_seq;
pixel_sequence pixel_seq;
    `uvm_component_utils(cs_mipi_dsi_base_test)

  function new(string name = "cs_mipi_dsi_base_test", uvm_component parent = null);
  super.new(name,parent);
  endfunction


virtual function void build_phase(uvm_phase phase);
  `uvm_info(get_full_name(),"------------BUILD PHASE ENTERED-----------------",UVM_LOW)

  env = cs_mipi_dsi_env::type_id::create("env", this);
  env_cfg = cs_mipi_dsi_env_cfg::type_id::create("env_cfg");
  env_cfg.build_cfg_objects();// call function for creating interface configuartion object
  ahb_seq = ahb_master_wr_rd_sequence::type_id::create("ahb_seq");
  pixel_seq = pixel_sequence::type_id::create("pixel_seq");
     // Get virtual interface from top
    if (!uvm_config_db#(virtual cs_mipi_dsi_env_if)::get(this, "*", "env_vif", env_cfg.env_if)) begin
      `uvm_fatal("NOVIF", "env_vif not found in config DB")
    end
    uvm_config_db#(cs_mipi_dsi_env_cfg)::set(this, "*", "env_cfg",env_cfg);
   //Set Number of Frams(FPS)
    uvm_config_db#(int unsigned)::set(null,"*","fps",1);

  `uvm_info(get_full_name(),"---------- BUILD PHASE EXITING ------------------",UVM_LOW)
endfunction : build_phase


virtual task run_phase (uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_full_name(),"-----------RUN PHASE ENTERED--------------------",UVM_LOW)
   ahb_seq.start(env.ahb_env.ahb_system_env.master[0].sequencer);
   pixel_seq.start(env.pixel_env.pixel_agn.pixel_sqr);
 #500ns;
  `uvm_info(get_full_name(),"-----------RUN PHASE EXITING--------------------",UVM_LOW)
  phase.drop_objection(this);

  endtask :run_phase 
endclass : cs_mipi_dsi_base_test

`endif


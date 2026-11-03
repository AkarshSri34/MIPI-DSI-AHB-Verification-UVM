`ifndef GUARD_AHB_BASE_TEST_SV
`define GUARD_AHB_BASE_TEST_SV

`include "ahb_basic_env.sv"
`include "dc_env.sv"
`include "ppi_basic_env.sv"
`include "cs_mipi_dsi_scoreboard.sv"
//`include "cust_svt_ahb_system_configuration.sv"


class cs_mipi_dsi_env extends uvm_env;

  /** UVM Component Utility macro */
  `uvm_component_utils(cs_mipi_dsi_env)

  /** Instance of the environment */
  ahb_basic_env ahb_env;
  dc_env pixel_env;
  ppi_basic_env ppi_env;
//Instance of the Scoreboard
  cs_mipi_dsi_scoreboard scb;
  /** Customized configuration */
  //cust_svt_ahb_system_configuration cfg;


 cs_mipi_dsi_env_cfg env_cfg;
  /** Class Constructor */
  function new(string name = "cs_mipi_dsi_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new


  /**
   * Build Phase
   * - Create and apply the customized configuration transaction factory
   * - Create the TB Sub_ENV
    */
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entered...", UVM_LOW)
    super.build_phase(phase);
    //env_cfg = cs_mipi_dsi_env_cfg::type_id::create("env_cfg",this);

    /** Create the configuration object */
   // cfg = cust_svt_ahb_system_configuration::type_id::create("cfg");

    /** Set configuration in environment */
    //uvm_config_db#(cust_svt_ahb_system_configuration)::set(this, "env", "cfg", env_cfg.cfg);

    /** Create the environment */
   ahb_env = ahb_basic_env::type_id::create("ahb_env", this);
   pixel_env = pixel_basic_env::type_id::create("pixel_env",this);
   ppi_env = ppi_basic_env::type_id::create("ppi_env",this);
   scb = cs_mipi_dsi_scoreboard::type_id::create("scr",this);
 if (!uvm_config_db #(cs_mipi_dsi_env_cfg)::get(this, "", "env_cfg", env_cfg)) begin
    `uvm_fatal(get_full_name(), $sformatf("Configuration must be set for %s.env_cfg", get_full_name()))
  end

 uvm_config_db#(cust_svt_ahb_system_configuration)::set(this, "*", "cfg", env_cfg.ahb_vip_cfg);
 uvm_config_db#(virtual svt_ahb_if)::set(this, "*", "vif", env_cfg.env_if.ahb_if);

    `uvm_info("build_phase", "Exiting...", UVM_LOW)
  endfunction: build_phase

 
 virtual function void connect_phase(uvm_phase phase);
   pixel_env.pixel_agn.pxl_mon.pixel_send_item.connect(scb.pixel_fifo.analysis_export);
   ppi_env.ppi_agn.ppi_mon.ppi_send_item.connect(scb.ppi_fifo.analysis_export);
 endfunction
endclass

`endif // GUARD_AHB_BASE_TEST_SV


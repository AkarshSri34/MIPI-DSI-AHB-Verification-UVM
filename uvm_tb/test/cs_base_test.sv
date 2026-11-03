`ifndef INC_CS_BASE_TEST
`define INC_CS_BASE_TEST

class cs_base_test extends uvm_test;
  uvm_report_server report_server;

  longint timeout_us;
  longint timestamp_us;

  `uvm_component_utils(cs_base_test)

  extern function new(string name = "cs_base_test", uvm_component parent = null);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
endclass

function cs_base_test::new(string name = "cs_base_test", uvm_component parent = null);
  super.new(name,parent);
  timeout_us   = 100000;
  timestamp_us = 500;
endfunction : new

function void cs_base_test::end_of_elaboration_phase(uvm_phase phase);
  void'($value$plusargs("timeout_us=%d", timeout_us));
  uvm_top.set_timeout(timeout_us * 1us);
  `uvm_info("UVM_TEST", $sformatf(" Timeout_period : %0dus", timeout_us), UVM_NONE)
  if ($test$plusargs("print_uvm_hier"))
    `uvm_info("UVM_TEST", $sformatf("Hierarchy: \n%s", this.sprint()), UVM_NONE)
endfunction : end_of_elaboration_phase


task cs_base_test::main_phase(uvm_phase phase);
  fork: TIMESTAMP_THREAD
    begin
      void'($value$plusargs("timestamp_us=%d", timestamp_us));
      `uvm_info("UVM_TEST", $sformatf("Timestamp period: %0dus", timestamp_us), UVM_NONE)
      forever #(timestamp_us * 1us)
        `uvm_info("TIMESTAMP", "-----------", UVM_NONE)
    end
  join_none
endtask : main_phase

function void cs_base_test::report_phase(uvm_phase phase);
  report_server = uvm_report_server::get_server();
  if ((report_server.get_severity_count(UVM_FATAL) + report_server.get_severity_count(UVM_ERROR)) == 0)
    begin
    $display("			########     ###     ######   ######  ######## ########   		");
    $display("			##     ##   ## ##   ##    ## ##    ## ##       ##     ##  		");
    $display("			##     ##  ##   ##  ##       ##       ##       ##     ##  		");
    $display("			########  ##     ##  ######   ######  ######   ##     ##   		");
    $display("			##        #########       ##       ## ##       ##     ##      		");
    $display("			##        ##     ## ##    ## ##    ## ##       ##     ##  		");
    $display("			##        ##     ##  ######   ######  ######## ########          	");
    end
  else
    begin
    $display("			########    ###    #### ##       ######## ########   		");
    $display("			##         ## ##    ##  ##       ##       ##     ##  		");
    $display("			##        ##   ##   ##  ##       ##       ##     ##  		");
    $display("			######   ##     ##  ##  ##       ######   ##     ##  		");
    $display("			##       #########  ##  ##       ##       ##     ##             ");
    $display("			##       ##     ##  ##  ##       ##       ##     ##  		");
    $display("			##       ##     ## #### ######## ######## ########   		");
    end
endfunction : report_phase

`endif


`include "uvm_pkg.sv"
`include "svt_ahb.uvm.pkg"
`include "svt_ahb_if.svi"

`include "cs_mipi_dsi_if.sv"
`include "cs_mipi_dsi_env_if.sv"
`include "cs_mipi_dsi_wrapper.sv"
`include "cs_mipi_dsi_tb_connect.sv"
`include "dc_intf.sv"
`include "cs_mipi_dsi_connection.sv"
import uvm_pkg::*;
import svt_uvm_pkg::*; 
import svt_ahb_uvm_pkg::*; 

module cs_mipi_dsi_top();
`include "top_test.sv"
dc_intf intf();
cs_mipi_dsi_if dut_if();
cs_mipi_dsi_env_if env_if();



//always #5 ahb_clk=~ahb_clk;


assign intf.clk=env_if.clk;
cs_mipi_dsi_tb_connect tb_connect(env_if, dut_if);
cs_mipi_dsi_wrapper dut_wrapper(dut_if);
cs_mipi_dsi_connection pixel_connect(env_if,intf);
	
  initial begin
    uvm_config_db#(virtual dc_intf)::set(null,"*","intf",intf);
uvm_config_db#(svt_ahb_vif)::set(uvm_root::get(),"uvm_test_top.env.ahb_system_env","vif",env_if.ahb_if);
    run_test();
  end
  initial begin 
  //  #100000 $finish;
  end
initial begin
 
   if($test$plusargs("ENABLE_DUMP")) begin
    `ifdef XCELIUM
       $shm_open("waves.shm", 1);
       $shm_probe("ASCTF");
    `else
       $fsdbDumpfile("./mydump.fsdb");
       $fsdbDumpvars; 
    `endif
    end

  end

endmodule 

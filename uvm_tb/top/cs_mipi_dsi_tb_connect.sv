module cs_mipi_dsi_tb_connect(cs_mipi_dsi_env_if env_if , cs_mipi_dsi_if dut_if);

assign dut_if.pclk=env_if.clk;
assign dut_if.dsi_rst=env_if.resetn;
assign env_if.ahb_if.master_if[0].hgrant=1;
assign dut_if.haddr=env_if.ahb_if.master_if[0].haddr;
assign dut_if.hwrite=env_if.ahb_if.master_if[0].hwrite;
assign dut_if.hsize=env_if.ahb_if.master_if[0].hsize;
assign dut_if.hburst=env_if.ahb_if.master_if[0].hburst;
assign dut_if.htrans=env_if.ahb_if.master_if[0].htrans;
assign dut_if.hwdata=env_if.ahb_if.master_if[0].hwdata;
assign env_if.ahb_if.hrdata_bus = dut_if.hrdata;
assign dut_if.hprot = env_if.ahb_if.master_if[0].hprot;
assign env_if.ahb_if.hresp_bus = dut_if.hresp;
assign env_if.ahb_if.hready_bus = dut_if.hready;

assign dut_if.pixel_data=env_if.pixel_data;
assign dut_if.data_valid=env_if.data_valid;
assign dut_if.hsync=env_if.hsync;
assign dut_if.vsync=env_if.vsync;

endmodule

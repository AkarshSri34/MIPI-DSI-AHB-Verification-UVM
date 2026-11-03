
module cs_mipi_dsi_wrapper(cs_mipi_dsi_if dut_if);

   dsi dut(
    // -------- AHB MASTER INTERFACE --------
    .haddr    (dut_if.haddr),
    .hwrite   (dut_if.hwrite),
    .hsize    (dut_if.hsize),
    .hburst   (dut_if.hburst),
    .htrans   (dut_if.htrans),
    .hwdata   (dut_if.hwdata),
    .hprot    (dut_if.hprot),
    .hresp    (dut_if.hresp),
    .hready   (dut_if.hready),
    .hrdata   (dut_if.hrdata),

    // -------- VIDEO INPUT SIDE --------
    .pixel_data (dut_if.pixel_data),
    .data_valid (dut_if.data_valid),
    .hsync      (dut_if.hsync),
    .vsync      (dut_if.vsync),

    // -------- CLOCK / RESET --------
    .pclk     (dut_if.pclk),
    .dsi_clk  (dut_if.dsi_clk),
    .dsi_rst  (dut_if.dsi_rst),

    // -------- PPI OUTPUTS --------
    .ppi_data_lane0 (dut_if.ppi_data_lane0),
    .ppi_data_lane1 (dut_if.ppi_data_lane1),
    .ppi_data_lane2 (dut_if.ppi_data_lane2),
    .ppi_data_lane3 (dut_if.ppi_data_lane3),
    .ppi_lane0_en   (dut_if.ppi_lane0_en),
    .ppi_lane1_en   (dut_if.ppi_lane1_en),
    .ppi_lane2_en   (dut_if.ppi_lane2_en),
    .ppi_lane3_en   (dut_if.ppi_lane3_en)
  );

endmodule

interface cs_mipi_dsi_if;

  // ----------------------------
  // AHB Interface Signals
  // ----------------------------
  logic [31:0] haddr;
  logic        hwrite;
  logic [2:0]  hsize;
  logic [2:0]  hburst;
  logic [1:0]  htrans;
  logic [31:0] hwdata;
  logic [3:0]  hprot;
  logic [1:0]  hresp;
  logic        hready;
  logic [31:0] hrdata;
  // ----------------------------
  // Pixel Interface
  // ----------------------------
  logic [23:0] pixel_data;
  logic        data_valid;
  logic        hsync;
  logic        vsync;

  // ----------------------------
  // Clock & Reset
  // ----------------------------
  logic        pclk;
  logic        dsi_clk;
  logic        dsi_rst;

  // ----------------------------
  // Pixel Interface
  // ----------------------------
  logic [7:0]  ppi_data_lane0;
  logic [7:0]  ppi_data_lane1;
  logic [7:0]  ppi_data_lane2;
  logic [7:0]  ppi_data_lane3;

  logic        ppi_lane0_en;
  logic        ppi_lane1_en;
  logic        ppi_lane2_en;
  logic        ppi_lane3_en;

endinterface


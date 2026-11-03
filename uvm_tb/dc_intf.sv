interface dc_intf();
  logic clk;//pixel clk
  logic hsync;
  logic vsync;
  logic data_valid;
  logic [23:0] pixel_data;
endinterface

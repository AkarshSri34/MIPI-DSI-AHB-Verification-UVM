module cs_mipi_dsi_connection(cs_mipi_dsi_env_if env_if, dc_intf intf);
 assign env_if.pixel_data=intf.pixel_data;
 assign env_if.data_valid=intf.data_valid;
 assign env_if.hsync=intf.hsync;
 assign env_if.vsync=intf.vsync;
endmodule

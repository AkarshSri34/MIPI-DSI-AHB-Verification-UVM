class cs_mipi_dsi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cs_mipi_dsi_scoreboard)

  uvm_tlm_analysis_fifo #(pixel_transaction) pixel_fifo;
  uvm_tlm_analysis_fifo #(ppi_transaction)   ppi_fifo;

  function new(string name="cs_mipi_dsi_scoreboard", uvm_component parent=null);
    super.new(name,parent);
    pixel_fifo = new("pixel_fifo", this);
    ppi_fifo   = new("ppi_fifo",   this);
  endfunction

  task run_phase(uvm_phase phase);
    pixel_transaction pix_tr;
    ppi_transaction   ppi_tr;

    forever begin
      pixel_fifo.get(pix_tr);   // Golden pixels
      ppi_fifo.get(ppi_tr);     // PHY reconstructed pixels

      compare_frames(pix_tr, ppi_tr);
    end
  endtask

  task compare_frames(pixel_transaction pix, ppi_transaction phy);
    int errors = 0;

    if (pix.pixel_q.size() != phy.payload_q.size()) begin
      `uvm_error("SCOREBOARD",$sformatf("SIZE MISMATCH: PIX=%0d  PHY=%0d",pix.pixel_q.size(), phy.payload_q.size()))
      return;
    end

    for (int i = 0; i < pix.pixel_q.size(); i++) begin
      if (pix.pixel_q[i] !== phy.payload_q[i]) begin
        `uvm_error("PIXEL_MISMATCH",$sformatf("PIX[%0d]=%0h  PHY[%0d]=%0h",i, pix.pixel_q[i],i, phy.payload_q[i]))
        errors++;
      end
    end

    if (errors == 0)
      `uvm_info("SCOREBOARD","FRAME MATCH PASS",UVM_LOW)
    else
      `uvm_error("SCOREBOARD",$sformatf("FRAME FAIL : %0d PIXEL ERRORS", errors))
  endtask
endclass



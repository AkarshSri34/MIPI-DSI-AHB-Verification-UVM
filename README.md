# MIPI DSI + AHB Verification using UVM

UVM testbench for a **MIPI DSI display controller IP that is configured over AMBA AHB**. The environment drives video frames (HSYNC / VSYNC / 24-bit pixel data) into the DUT and checks that the pixels coming out of the DSI PHY side (PPI) match the pixels that went in.

**Tech:** SystemVerilog · UVM · Synopsys VCS / Verdi · Synopsys SVT AHB VIP

---

## Testbench architecture

```
                 cs_mipi_dsi_test (uvm_test)
                            |
                 cs_mipi_dsi_env (uvm_env)
      +---------------------+----------------------+
      |                     |                      |
  AHB env (SVT VIP)   Pixel / display env    cs_mipi_dsi_scoreboard
  register config     dc_agent:              pixel_fifo  (golden pixels)
                      sequencer -> driver    ppi_fifo    (PHY output)
                      monitor                frame-by-frame compare
      |                     |                      ^
      +----------> MIPI DSI DUT (wrapper) ---------+
```

## Key features

- **Constrained-random video timing:** `dc_transaction` randomizes the resolution (QQVGA to Full HD, scaled down for simulation) and the HSYNC/VSYNC pulse width, back porch and front porch (`randc`). `post_randomize()` derives HTOTAL, VTOTAL and the active-video begin/end points.
- **Timing-accurate driver:** `dc_driver` drives HSYNC, VSYNC and pixel data in parallel threads (`fork…join`), so one frame is produced with the correct blanking intervals.
- **AHB register configuration** through the Synopsys SVT AHB VIP.
- **TLM scoreboard:** `cs_mipi_dsi_scoreboard` takes golden pixels and PHY-reconstructed pixels from two analysis FIFOs. It checks the frame size, compares every pixel, and reports PASS or the number of mismatches.

## Repository layout

```
uvm_tb/
├── dc_transaction.sv          # video timing + resolution sequence item
├── dc_sequence.sv             # frame sequence
├── dc_sequencer.sv
├── dc_driver.sv               # HSYNC / VSYNC / pixel-data driver
├── dc_monitor.sv
├── dc_agent.sv
├── dc_env.sv
├── dc_intf.sv                 # pixel interface
├── env.sv                     # top env: AHB env + pixel env + scoreboard
├── cs_mipi_dsi_scoreboard.sv  # frame-level pixel comparison
├── test/                      # base tests and test package
└── top/                       # top module, DUT wrapper, interfaces, connections
```

## Running

Built for **Synopsys VCS** with the **SVT AHB VIP**, which needs a Synopsys VIP license. The DUT RTL, the AHB sequence/env packages and the VIP sources are not included in this repository.

## Author

**Akarsh Srivastava** · Design Verification Engineer
[LinkedIn](https://www.linkedin.com/in/akarsh-srivastava-a034a7196) · [GitHub](https://github.com/AkarshSri34)

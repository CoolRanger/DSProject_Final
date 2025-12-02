# 4_Software_Development
After completing the hardware system design, this chapter guides you through developing the software application that runs on the PYNQ-Z2 board.

This software interacts with the AXI-Lite convolution IP, transfers data using AXI CDMA, and displays the processed results.

The provided Jupyter Notebook (`main.ipynb`) is **partially completed**.
You are required to fill in key sections to complete the end-to-end hardware–software integration.

The software is responsible for:
- Loading the bitstream and hardware description
- Transferring image data between DDR and BRAM
- Triggering the AXI-Lite convolution IP
- Reading back the processed output
- Displaying the results

The `pic/` directory contains sample test images that you may use when running the notebook.

## Before You Start
Make sure you have the following files generated from Chapter 3 – System Integration:

- `conv_system.bit`
- `conv_system.hwh`

These two files describe the FPGA hardware design and are required by PYNQ to correctly configure the programmable logic (PL).

## Software Development Steps
1. Set up the PYNQ environment on your host PC and PYNQ-Z2 board.

2. Transfer the generated `*.bit` and `*.hwh` files to the PYNQ-Z2 board.

3. Fill in the missing code sections in `main.ipynb` to complete the software application.

4. Run the Jupyter Notebook to verify that the convolution IP works correctly and produces the expected output image.



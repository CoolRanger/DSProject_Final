# 2_AXI-Lite_Integration_for_Convolution_Module
In this chapter, the convolution module developed in the previous section is integrated with an AXI-Lite interface.
The AXI-Lite wrapper allows the convolution IP to be configured, triggered, and monitored through standard AXI-Lite read and write operations, making it suitable for system-level integration with processors or other bus-based components.

A detailed tutorial on how to create and wrap an AXI-Lite interface can be found at the following link:

[AXI-Lite](https://github.com/ukp66482/Xilinx-FPGA-tutorial/tree/main/Hardware-Software-Codesign/Part3-AXI-Lite)

The AXI-Lite wrapper provided in the `src/` directory is generated using Vivado’s IP Packager template.

Additional comments have been inserted throughout the files (`conv_v1_0_S00_AXI.v`, `conv_v1_0.v`) to indicate which sections must be completed in order to connect the convolution module to the AXI-Lite interface. These annotations specify where register logic, control signals, and data-path wiring should be added.

You may use the provided wrapper files directly, or you may generate your own AXI-Lite wrapper in Vivado and apply the same modifications to the corresponding regions.
The provided files simply serve as a reference to show which parts of the template need to be modified; the implementation steps remain the same regardless of whether you use the supplied wrapper or one you generate yourself.

For the detailed specification of the AXI-Lite integrated convolution IP—including port descriptions, register definitions, signal behaviors, and integration requirements—refer to the `IP_Spec.md` file located in this directory.
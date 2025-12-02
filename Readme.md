# NCKU-CSIE-Digital-System-Final-Proj
This repository contains all the design files and documentation for the final project of Digital System Design course at National Cheng Kung University (NCKU) Computer Science and Information Engineering (CSIE) department.

## Before You Start
Before working on this project, you must review specific parts of the following tutorial, which provides the background knowledge required for AXI, PYNQ, and Vivado IP design:

Xilinx FPGA Tutorial:

https://github.com/ukp66482/Xilinx-FPGA-tutorial

## Project Overview
This project serves as a teaching-oriented exercise that walks learners through the basic steps of designing a small hardware module and running it on the PYNQ-Z2 platform.

The focus is on understanding the flow of:

- RTL implementation of a simple 3×3 convolution module
- Functional simulation using Vivado
- AXI-Lite integration to allow software to control the hardware
- System integration and testing on the PYNQ-Z2 board

The purpose of this project is not to build a highly optimized accelerator, but rather to help learners become familiar with:

- Verilog module design
- Vivado project setup and simulation
- AXI-Lite wrapper usage
- Hardware–software interaction using PYNQ

By completing this project, learners will understand the essential steps required to design an IP, verify it, wrap it, and run it in a simple FPGA system.

## Requirements

### Hardware
- PYNQ-Z2 Board
![PYNQ-Z2](./pic/PYNQ-Z2.png)

### Software
- Vivado 2023.2
- PYNQ 2.6
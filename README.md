# RISC-V Verilog Processor

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-red)
![ISA](https://img.shields.io/badge/ISA-RISC--V%20RV32I-green)

A Register-Transfer Level (RTL) implementation of a RISC-V processor written in Verilog. This project implements the **RV32I** (Base Integer) instruction set and targets Xilinx FPGAs.

It includes the core design, testbenches for verification, and constraint files for FPGA deployment.

## 📂 Repository Structure

| File/Folder | Description |
| :--- | :--- |
| **`Design Sources/`** | Contains the Verilog source code (`.v`) for the processor modules (ALU, Control Unit, RegFile, etc.). |
| **`TestBenches/`** | Simulation files to verify the design logic and instruction execution. |
| **`Screenshots/`** | Waveform simulations and implementation diagrams. |
| **`constraints.xdc`** | Xilinx Design Constraints file for mapping I/O to specific FPGA pins. |
| **`instructions.txt`** | Hexadecimal machine code loaded into Instruction Memory for testing. |

---

## 🏗️ Architecture

This core follows a [Single-Cycle] architecture.

* **ISA:** RISC-V RV32I
* **Data Width:** 32-bit
* **Memory:** Harvard Architecture (Separate Instruction and Data memory)

### visual Verification
*(Below are images from the `Screenshots` folder showing successful simulation)*

![Simulation Waveform](Screenshots/Screenshot 2025-12-12 221006.png)


## 🚀 Getting Started

### Prerequisites
* **Xilinx Vivado** (WebPACK or Standard Edition)
* A text editor (VS Code, Notepad++)

### How to Simulate
1.  Open **Vivado**.
2.  Create a new project and select "RTL Project".
3.  **Add Sources:** Import all files from the `Design Sources/` folder.
4.  **Add Simulation Sources:** Import files from the `TestBenches/` folder.
5.  **Load Program:** Ensure `instructions.txt` is in the simulation working directory (or update the path in your Instruction Memory module).
6.  Click **Run Simulation > Run Behavioral Simulation**.

### How to Synthesize (FPGA)
1.  **Add Constraints:** Import `constraints.xdc` into the project.
2.  Select your target FPGA part (e.g., Artix-7, Basys 3).
3.  Click **Run Synthesis** followed by **Run Implementation**.
4.  Generate Bitstream and program the device.

---

## 📝 Instruction Loading
The processor reads instructions from `instructions.txt`. To run a new program:
1.  Compile your Assembly/C code to machine code (hex).
2.  Paste the hex strings into `instructions.txt`.
3.  Re-run the simulation (no need to re-synthesize for simulation).

---

## 🛠️ Future Improvements
* [ ] Implement Pipelining
* [ ] Add support for Compressed (C) instructions
* [ ] Add UART interface for I/O

## 📜 License
This project is open-source.

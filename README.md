# 🧠 Verilog Single-Cycle CPU

This project implements a simple 8-bit **single-cycle CPU** in Verilog.  
It supports basic ALU operations, branching, jumping, and immediate loading.

---

## ✅ Supported Instructions

- `MOVI` — Move Immediate (load a constant to a register)
- `ADD`, `SUB`, `AND`, `OR` — Arithmetic and logic operations
- `BEQ` — Branch if equal
- `BNE` — Branch if not equal
- `JUMP` — Unconditional jump to instruction address

---

## 🧱 Project Structure

    verilog-single-cycle-cpu/
    ├── alu.v               # Arithmetic Logic Unit
    ├── cpu.v               # Top-level CPU module
    ├── cpu_tb.v            # Testbench that verifies all instructions
    ├── datapath.v          # Connects ALU, register file, PC
    ├── instr_mem.v         # Instruction memory with hardcoded test program
    ├── pc.v                # Program counter with jump logic
    ├── register_file.v     # 8x8-bit register file
    ├── README.md           # Project description and usage instructions


---

## ▶️ How to Run

Make sure you have Icarus Verilog and GTKWave installed.

## Compile and simulate:

```bash
iverilog -o cpu_test alu.v register_file.v datapath.v pc.v instr_mem.v cpu.v cpu_tb.v
vvp cpu_test

## View Waveform :
gtkwave cpu.vcd


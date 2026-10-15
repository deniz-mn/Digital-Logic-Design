# CA-1 · Iterative Hash Engine

[← Repository overview](../README.md)

A SystemVerilog implementation of an assignment-specific hash algorithm. The default configuration processes a **128-bit message as four 32-bit words over 64 iterations**, using a separate controller and datapath for both hashing and message-word selection.

## Design

1. Load the initial state words supplied at the top-level interface.
2. Derive a message-word index from the iteration number using an XOR-feedback shift register.
3. Select a round-dependent Boolean function and add its result to a state word, a constant, and the selected message word.
4. Rotate the sum left using a shift register and a countdown counter.
5. Update the state registers and repeat until `done` is asserted.

`Top` exposes `clk`, `rst`, `start`, `message`, `constants`, and `initialValues`; its outputs are `done` and `hashed`. The round functions and rotation schedule resemble MD5, but message selection and the overall interface are specific to this assignment.

## Code guide

| Files | Purpose |
| --- | --- |
| [TOP.sv](Code/TOP.sv) | Connects the hash engine and index generator |
| [hashDatapath.sv](Code/hashDatapath.sv), [hashFSM.sv](Code/hashFSM.sv), [hashTop.sv](Code/hashTop.sv) | State registers, round arithmetic, and sequencing |
| [rndDatapath.sv](Code/rndDatapath.sv), [rndFSM.sv](Code/rndFSM.sv), [rndTop.sv](Code/rndTop.sv) | Iteration-seeded word-index generation |
| [FGenerator.sv](Code/FGenerator.sv) | Four round-dependent Boolean functions |
| [rotate.sv](Code/rotate.sv), [leftRotate.sv](Code/leftRotate.sv), [stepGenerator.sv](Code/stepGenerator.sv) | Multi-cycle rotation and rotation-count lookup |
| `nBit*.sv` | Registers, counters, shift register, and multi-input adder |
| [tb_Top.sv](Code/tb_Top.sv) | Full-design stimulus and iteration trace |
| [tb_rndTop.sv](Code/tb_rndTop.sv), [tb_Adder.sv](Code/tb_Adder.sv) | Component testbenches |

## Simulation

Use a simulator with SystemVerilog unpacked-array port support. From `CA-1/Code`, run these commands in the ModelSim/Questa console:

```tcl
vlib work
vlog -sv *.sv
vsim work.tb_Top
run -all
```

Keep [constant.mem](Code/constant.mem) in the simulator working directory. The testbench supplies one fixed message and initial state, prints intermediate state and the final hash, then stops. It does not automatically compare the hash with an expected value. Select `tb_rndTop` or inspect the adder testbench for smaller experiments.

The RTL exposes size parameters, but the supplied test and rotation table target the default 64-round configuration; other configurations need separate validation.

## What I practiced

- Separating control logic from datapath logic.
- Coordinating nested multi-cycle operations with start/done signals.
- Implementing rotations with sequential hardware.
- Using parameters, generate loops, arrays, and reusable RTL modules.
- Tracing internal state to debug an iterative algorithm.

## Supporting material

[Assignment](CAD-CA1.pdf) · [Pseudocode](pseudocode.txt) · [Worked example](example.txt) · [Rotation steps](step.txt) · [Submitted document](For-Upload/doc.pdf)

Use `Code/` as the reading entry point. `For-Upload/` and ZIP files retain submission copies, which may differ from the working source.

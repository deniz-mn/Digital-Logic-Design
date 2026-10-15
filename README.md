# Digital Logic Design — University of Tehran

Five computer assignments from my Digital Logic Design course at the **University of Tehran**, covering hardware design from algorithm-level descriptions to RTL, custom logic cells, synthesis, and automatic Verilog generation.

The projects show how I practiced **datapath/controller design, sequential arithmetic, simulation, technology mapping, and resource-constrained scheduling**.

## Projects at a glance

| Assignment | What I built | Main concepts | Implementation |
| --- | --- | --- | --- |
| [CA-1 · Iterative hash engine](CA-1/README.md) | A 128-bit, 64-round hash datapath with iterative rotation and message-word selection | FSMs, registers, counters, parameterized RTL, handshaking | SystemVerilog |
| [CA-2 · Bit-serial matrix–vector multiplication](CA-2/README.md) | A memory-connected accelerator using two Stripes processing elements | Signed arithmetic, bit-serial dot products, accumulation, memory addressing | Verilog |
| [CA-3 · Hash engine using custom cells](CA-3/README.md) | A 32-bit hash variant assembled from combinational and sequential cells | Structural design, one-hot control, sequential multiplication, reference testing | Verilog, Python, C++ |
| [CA-4 · Synthesis and technology mapping](CA-4/README.md) | A flow that synthesizes hash RTL to LUTs and maps them to custom cells | Yosys synthesis, LUT truth tables, flip-flop mapping, netlist simulation | Verilog, Python, Yosys script |
| [CA-5 · Expression-to-Verilog tool](CA-5/README.md) | A tool that turns expressions into scheduled datapaths and controllers | Data-flow graphs, list scheduling, resource sharing, RTL generation | Python, Graphviz, Verilog |

## What I learned

- **Translate algorithms into hardware:** divide computation into clocked steps and coordinate datapaths with finite-state machines.
- **Build reusable components:** combine registers, counters, multiplexers, arithmetic units, and processing elements into larger designs.
- **Explore hardware tradeoffs:** reuse arithmetic resources across cycles and examine the relationship between resources and latency.
- **Work at different abstraction levels:** move from behavioral RTL to structural cells and synthesized netlists.
- **Verify designs:** use component testbenches, stored input/output vectors, software models, and simulation logs.
- **Automate design tasks:** parse expressions, schedule operations, visualize dependencies, and emit Verilog.

## Where to start

For a quick RTL example, open [CA-1's top module](CA-1/Code/TOP.sv). For arithmetic architecture, explore [CA-2's processing element](CA-2/Code/stripesPE.v). To follow a complete automation pipeline, start with [CA-5](CA-5/README.md), which includes ten sample inputs, graph images, schedules, and generated hardware.

Each assignment README explains its architecture, important files, learning outcomes, and simulation or execution setup. Assignment PDFs, reports, submission archives, and original simulator artifacts are retained alongside the source.

## Languages and tools

| Tool or language | Used for |
| --- | --- |
| Verilog / SystemVerilog | Hardware modules and testbenches |
| ModelSim / Questa-style simulator workflow | HDL compilation, simulation, and waveform inspection |
| Python 3 | Hash reference model, netlist mapping, scheduling, and code generation |
| Graphviz and its Python package | Data-flow graph images in CA-5 |
| Yosys | LUT synthesis in CA-4 |
| C++ / Windows API | Custom-cell counting helpers in CA-3 |

Compile assignments separately: several reuse module names such as `top`, `datapath`, and `register`. Run simulations from the working directory specified in each assignment README so memory files resolve correctly.

**Scope:** these are course implementations. The hash designs implement assignment-specific algorithms; the documentation does not claim standard MD5 compatibility. Stored outputs and reports are historical artifacts. HDL simulation and synthesis were not rerun as part of this documentation update.

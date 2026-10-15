# CA-3 · Hash Engine Built from Custom Logic Cells

[← Repository overview](../README.md)

A structural Verilog implementation of a **32-bit, 64-round hash variant**, built around custom combinational cells (`c1`, `c2`) and sequential cells (`s1`, `s2`). This assignment connects Boolean functions and storage primitives to a complete algorithmic datapath.

## Design

The default message consists of four 8-bit words. State registers start at `01`, `89`, `FE`, and `76`. Each round selects a message byte, computes a Boolean function, and forms an 8-bit sum with the current A register and a round constant.

The sum's upper and lower nibbles are multiplied by a sequential shift-and-add unit. Its product is added to B, while the remaining state words move through the register chain. This multiplication replaces the rotation used in CA-1.

The top-level interface accepts `clk`, `rst`, `start`, and `message`, and returns `digest` and `done`. The controller uses one-hot state signals implemented with custom cells. Although parameters are exposed, several byte slices and multiplier counters are fixed to the default configuration.

## Code guide

| Files | Purpose |
| --- | --- |
| [top.v](codes/top.v), [datapath.v](codes/datapath.v), [fsm.v](codes/fsm.v) | Complete engine, state updates, and structural control |
| [modules.v](codes/modules.v) | Definitions of `c1`, `c2`, `s1`, `s2`, and `FDCP` |
| [calF.v](codes/calF.v) | Round-dependent Boolean functions constructed with cells |
| [multiplier.v](codes/multiplier.v), [bitMultiplier.v](codes/bitMultiplier.v), [bitI.v](codes/bitI.v) | Sequential nibble multiplication |
| `adder.v`, `counter.v`, `register.v`, `mux.v`, `*Module.v` | Reusable structural arithmetic, storage, and logic |
| `rndTop.v`, `rndDatapath.v`, `rndFsm.v` | Message-word index generator |
| [tbFullTop.v](codes/tbFullTop.v) | 64-vector comparison against stored expected digests |
| [top_module_sim.py](top_module_sim.py) | Python model with a round-by-round trace |
| `c1.cpp`, `c2.cpp`, `s2-s1.cpp` | Windows cell-counting helpers that update `numbers.txt` |

## Simulation

Use `CA-3` as the simulator working directory so [k.mem](k.mem), [testcase.txt](testcase.txt), and [out_hw.txt](out_hw.txt) resolve correctly.

The cell definitions invoke `c1.exe`, `c2.exe`, and `s2-s1.exe` through `$system` when simulation starts. The original executables are in [For_upload/for-work-space](For_upload/for-work-space/), and their source is in `codes/`. For the original Windows counting workflow, make these helpers available in the working directory and provide a writable `numbers.txt` initialized to `0`. For functional-only simulation, use a separate copy of `modules.v` with the counting-only `initial` blocks removed.

With the counting prerequisites prepared, run in the ModelSim/Questa console:

```tcl
vlib work
vlog codes/*.v
vsim work.tbFullTop
run -all
```

`tbFullTop` prints success/failure for each vector and a total out of 64. Smaller testbenches cover the adder, counter, register, multiplier, Boolean function, and index generator.

The separate [verifyTestBench.v](codes/verifyTestBench.v) expects `testcase3.txt` and optionally `golden_out_hw3.txt`. Those exact filenames are absent from the checked-in tree; prepare the intended datasets before using that bench. The Python model can be inspected or run with `python top_module_sim.py`; it is a trace utility rather than an automated HDL test runner.

## What I practiced

- Realizing arithmetic and Boolean functions with a restricted cell library.
- Building sequential multiplication from selection, addition, and registers.
- Implementing one-hot control at the structural level.
- Comparing hardware outputs with stored reference vectors.
- Instrumenting cell usage with simulation hooks and helper programs.

## Supporting material

[Assignment](CAD-CA3.pdf) · [Submitted report](For_upload/report/CAD_CA3_RREPORT.pdf) · [Archived cell-count data](For_upload/report/numbers.txt)

Start with `codes/`; `For_upload/` preserves the submission snapshot.

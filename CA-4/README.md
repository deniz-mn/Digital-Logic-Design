# CA-4 · Synthesis and Custom-Cell Technology Mapping

[← Repository overview](../README.md)

A synthesis flow for the **32-bit hash variant with nibble multiplication**. Behavioral Verilog is synthesized into small lookup tables, then a Python mapper rewrites LUT and flip-flop instances into the course's custom cell library.

## Flow

```text
Hash RTL → Yosys synthesis to LUT2 → Python cell mapping → mapped Verilog → simulation
```

The RTL uses four 8-bit state words and 64 rounds. Unlike CA-3's explicit sequential multiplier, the RTL expresses the nibble product with `*`, leaving its implementation to synthesis. Round constants are embedded in `constModule.v`.

The mapper reads LUT truth tables, resolves input bits, and emits `c1` or `c2` instances. It also maps recognized flip-flop forms to `s1`/`s2` cells and handles whitespace termination for escaped Verilog identifiers.

## Code guide

| Path | Purpose |
| --- | --- |
| [Code/top.v](Code/top.v) | RTL entry point: `message` → `hashed`, with start/done control |
| [Code/hashDatapath.v](Code/hashDatapath.v) | State updates, byte selection, addition, and nibble multiplication |
| [Code/lut2synthesis.ys](Code/lut2synthesis.ys) | Source list, hierarchy check, `synth -lut 2`, and netlist export |
| [Code-Mapped/lut2mapper.py](Code-Mapped/lut2mapper.py) | LUT and flip-flop conversion script |
| [Code-Mapped/synth.v](Code-Mapped/synth.v) | Stored synthesized netlist |
| [Code-Mapped/mapped_synth.v](Code-Mapped/mapped_synth.v) | Stored custom-cell netlist |
| [Code-Mapped/modules.v](Code-Mapped/modules.v) | Custom-cell simulation definitions with counting hooks |
| [Code-Mapped/verifyTestBench.v](Code-Mapped/verifyTestBench.v) | File-driven digest comparison |

## Reproduce the mapping

Requirements: Yosys, Python 3, and a Verilog simulator. Run the following shell commands from `CA-4/Code`:

```text
yosys -s lut2synthesis.ys
```

The script writes `mapped.v` in that directory. To keep generated files separate from the archived results, continue from `CA-4` in PowerShell:

```powershell
New-Item -ItemType Directory -Force mapping-output
Set-Location mapping-output
python ../Code-Mapped/lut2mapper.py ../Code/mapped.v --cell c2
```

This writes `mapped_mapped.v` and `modules.v` in `mapping-output/`. The filename is intentional: the mapper prefixes the input basename with `mapped_`. The archived `mapped_synth.v` instead corresponds to an input named `synth.v`.

For a basic simulation, run from `mapping-output/` in the ModelSim/Questa console:

```tcl
vlib work
vlog mapped_mapped.v modules.v ../Code-Mapped/tbTop.v
vsim work.tbTop
run -all
```

Compile only one implementation of `top` at a time. The mapper's optional `--count-cells` flag generates Windows executable hooks; omitting it produces cell definitions without those counting calls. The archived `Code-Mapped/modules.v` contains the hooks.

## Verification artifacts

The [stored verification log](report/100-test-outout/verify_log_hw.txt) records **100 / 100 passed** for the archived run; [hardware outputs](report/100-test-outout/verify_out_hw.txt) are also included. This is historical evidence, not a newly reproduced result.

The verification bench opens `testcase3.txt` and `golden_out_hw3.txt`, which are not included under those names. Reproducing the comparison requires supplying the intended inputs and reference outputs. Without the reference file, the bench disables comparison.

## What I practiced

- Moving from RTL to synthesized netlists.
- Translating LUT truth tables into configurable logic cells.
- Preserving clock, enable, and reset behavior during cell mapping.
- Processing generated Verilog with Python.
- Checking mapped hardware against reference outputs.

## Supporting material

[Assignment](CAD-CA4.pdf) · [Report](report/CAD-CA4-Report.pdf) · [Stored cell-count data](report/numbers.txt)

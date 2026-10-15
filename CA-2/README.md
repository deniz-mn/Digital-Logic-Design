# CA-2 · Bit-Serial Matrix–Vector Multiplication

[← Repository overview](../README.md)

A Verilog accelerator that computes row-wise dot products using **Stripes processing elements**. With the default parameters, it loads an eight-element vector and an 8 × 8 matrix, then writes eight results to memory. The source calls the engine `matrixMultiplier`; its implemented access pattern performs a matrix–vector product.

## Design

The datapath holds vector A and one matrix row B in register banks. It presents one bit from every A element per cycle, beginning with the sign bit, while B remains available in parallel.

Two four-lane `stripesPE` instances cover the eight terms of a dot product. Each lane selects zero, B, or negated B according to the current A bit and the MSB flag. Adders and an accumulator combine contributions across bit positions; the second processing element adds the first element's partial result.

The controller sequences vector loading, row loading, MSB processing, remaining bits, result writes, and completion. Defaults are 16-bit A/B elements, 128 memory locations, and a 34-bit memory data width.

### Default memory layout

| Addresses | Contents |
| --- | --- |
| 0–7 | Vector A |
| 8–71 | Eight rows of B, eight elements per row |
| 72–79 | Eight output dot products |

These ranges follow `readAddress.v` and `writeAddress.v`; they change with `NUM_O_MATRIX_ROWS`.

## Code guide

| Files | Purpose |
| --- | --- |
| [top.v](Code/top.v), [memory.v](Code/memory.v) | Accelerator integration and initialized memory |
| [matrixMultiplierTop.v](Code/matrixMultiplierTop.v) | Controller/datapath wiring |
| [matrixMultiplierDatapath.v](Code/matrixMultiplierDatapath.v) | Register banks, counters, address logic, and two processing elements |
| [matrixMultiplierController.v](Code/matrixMultiplierController.v) | Nine-state control sequence |
| [stripesPE.v](Code/stripesPE.v), [selectorM1.v](Code/selectorM1.v), [accumulator.v](Code/accumulator.v) | Bit-serial arithmetic and signed-bit handling |
| [tbTop.v](Code/tbTop.v), [tbStripesPE.v](Code/tbStripesPE.v) | Integrated and standalone PE stimulus |
| [TestCases](TestCases/) | Three input-memory files and corresponding stored outputs |

## Simulation

From `CA-2/Code`, copy the input selected by `tbTop.v` into the working directory. For the checked-in configuration, use PowerShell:

```powershell
Copy-Item '../TestCases/input_memory_(3).txt' .
```

Then run in the ModelSim/Questa console from that directory:

```tcl
vlib work
vlog *.v
vsim work.tbTop
run -all
```

The testbench prints memory write addresses and data, then stops after `done`. Compare these writes with [output_memory_(3).txt](TestCases/output_memory_%283%29.txt); it does not perform an automatic comparison. For another case, update `MEM_FILE` in `tbTop.v` and supply the matching input. Use `tb_stripesPE` as the simulation top for the standalone four-lane example.

## What I practiced

- Trading parallel multipliers for arithmetic spread across clock cycles.
- Handling two's-complement sign bits and sign extension.
- Combining processing elements into a larger dot-product engine.
- Designing memory layouts, address generators, and register-bank enables.
- Testing arithmetic components separately from the integrated controller.

## Supporting material

[Assignment](CAD-CA2.pdf) · [Phase 1 document](Phase-1/CAD_HW2_810102603_810102549.pdf) · [Reports](Report/)

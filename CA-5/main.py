import ast
import sys
import json
from pathlib import Path
from src.dfg_creator import GraphBuilder
from src.graph_visualizer import expression_to_graph, visualize_graph, visualize_scheduled_graph
from src.scheduler import MinLatencyScheduler, MinResourceScheduler, ScheduledNodeInfo

import math
import os
import shutil
from typing import List, Dict
from src.dfg_creator import IdentifierNode, OP_TYPES

MinResourceAlgorithm = "MinResourceLatencyConstrained"
MinlatencyAlgorithm = "MinLatencyResourceContrained"

def load_input(filename: str) -> dict:
    with open(filename, "r") as file:
        return json.load(file)

def build_dfg(expression: str, folder_path : str):
    ast_root = expression_to_graph(expression)

    dot = visualize_graph(ast_root)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/DFG", format='png', view=False, cleanup=True)

    builder = GraphBuilder()
    return builder.build(ast_root)


def schedule_dfg(dfg_root, algorithm : str, config : dict, folder_path : str) -> list:
    if (algorithm == MinResourceAlgorithm):
        scheduler = MinResourceScheduler(dfg_root=dfg_root, numof_resources=config["Resources"], max_time=config["MaxTime"])
    else:
        scheduler = MinLatencyScheduler(dfg_root=dfg_root, numof_resources=config["Resources"])    
    scheduler.schedule()
    schedule_info = scheduler.get_scheduling_info()

    dot = visualize_scheduled_graph(root_id=dfg_root.id, schedule_info=schedule_info)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/ScheduledDFG", format='png', view=False, cleanup=True)

    return schedule_info

class VerilogGenerator:
    def __init__(self, folder_path: str, schedule_info: List[ScheduledNodeInfo]):
        self.folder_path = folder_path
        self.schedule_info = schedule_info
        self.sorted_nodes = sorted(schedule_info, key=lambda x: x.node.id)
        
        self.max_time = max((node.scheduled_time for node in schedule_info), default=0)
        
        self.schedule_map = {t: [] for t in range(1, self.max_time + 1)}
        for item in self.schedule_info:
            self.schedule_map[item.scheduled_time].append(item)

        self.inputs = self._extract_inputs()
        self.resources = self._extract_resources()
        self.mux_sources = self._create_mux_sources_map()
        
        num_sources = len(self.mux_sources)
        self.mux_bits = math.ceil(math.log2(num_sources)) if num_sources > 1 else 1

    def _extract_inputs(self) -> List[str]:
        inputs = set()
        for item in self.schedule_info:
            for op in item.node.operands:
                if isinstance(op, IdentifierNode):
                    inputs.add(op.name)
        return sorted(list(inputs))

    def _extract_resources(self) -> Dict[str, int]:
        res_counts = {op: 0 for op in OP_TYPES}
        for item in self.schedule_info:
            res_type = item.node.op_type
            if item.resource_num > res_counts.get(res_type, 0):
                res_counts[res_type] = item.resource_num
        return res_counts

    def _create_mux_sources_map(self) -> Dict[str, int]:
        sources = [f"{inp}" for inp in self.inputs]
        for item in self.sorted_nodes:
            sources.append(f"reg_{item.node.op_type.lower()}{item.node.id}")
        return {name: i for i, name in enumerate(sources)}

    def generate(self):
        codes_dir = os.path.join(self.folder_path, "codes")
        os.makedirs(codes_dir, exist_ok=True)

        self._write_datapath(os.path.join(codes_dir, "Datapath.v"))
        self._write_controller(os.path.join(codes_dir, "Controller.v"))
        self._write_top_module(os.path.join(codes_dir, "TopModule.v"))
        self._write_testbench(os.path.join(codes_dir, "tbTopModule.v"))

    def _write_datapath(self, filepath):
        lines = [
            "module datapath(",
            "input clk, rst,"
        ]
        
        lines.extend([f"input [31:0] {inp}," for inp in self.inputs])

        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"input [{self.mux_bits-1}:0] {name}_sel1, {name}_sel2,")
                width = "[1:0] " if res_type == "LOG" else ""
                lines.append(f"input {width}{name}_op,")

        lines.append("input result_en, done_next,")
        lines.extend([f"input reg_{n.node.op_type.lower()}{n.node.id}_en," for n in self.sorted_nodes])
        
        lines.append("output reg [31:0] result,")
        lines.append("output reg done")
        lines.append(");")

        lines.extend([f"reg [31:0] reg_{n.node.op_type.lower()}{n.node.id};" for n in self.sorted_nodes])

        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"reg [31:0] {name}_op1, {name}_op2;")
                lines.append(f"reg [31:0] {name}_out;")

        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                for op_num in [1, 2]:
                    lines.append(f"always @(*) begin")
                    lines.append(f"case ({name}_sel{op_num})")
                    for src_name, idx in self.mux_sources.items():
                        lines.append(f"{self.mux_bits}'d{idx}: {name}_op{op_num} = {src_name};")
                    lines.append(f"default: {name}_op{op_num} = 32'd0;")
                    lines.append(f"endcase")
                    lines.append(f"end")

        self._append_functional_units_logic(lines)

        lines.append("always @(posedge clk or posedge rst) begin")
        lines.append("if (rst) begin")
        lines.append("done <= 0;")
        lines.append("result <= 0;")
        for n in self.sorted_nodes:
            lines.append(f"reg_{n.node.op_type.lower()}{n.node.id} <= 0;")
        lines.append("end else begin")
        lines.append("done <= done_next;")
        
        for info in self.sorted_nodes:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            res_wire = f"{info.node.op_type.lower()}{info.resource_num}_out"
            lines.append(f"if ({reg_name}_en) {reg_name} <= {res_wire};")
        
        if self.sorted_nodes:
            last_node = self.sorted_nodes[-1]
            last_res_wire = f"{last_node.node.op_type.lower()}{last_node.resource_num}_out"
            lines.append(f"if (result_en) result <= {last_res_wire};")

        lines.append("end")
        lines.append("end")
        lines.append("endmodule")

        with open(filepath, "w") as f:
            f.write("\n".join(lines))

    def _append_functional_units_logic(self, lines):
        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"always @(*) begin")
                lines.append(f"case ({name}_op)")
                
                if res_type == "ALU":
                    lines.append(f"1'b0: {name}_out = {name}_op1 + {name}_op2;")
                    lines.append(f"1'b1: {name}_out = {name}_op1 - {name}_op2;")
                elif res_type == "MUL":
                    lines.append(f"1'b0: {name}_out = {name}_op1 * {name}_op2;")
                    lines.append(f"1'b1: {name}_out = {name}_op1 / {name}_op2;")
                elif res_type == "LOG":
                    lines.append(f"2'b00: {name}_out = {name}_op1 & {name}_op2;")
                    lines.append(f"2'b01: {name}_out = {name}_op1 | {name}_op2;")
                    lines.append(f"2'b10: {name}_out = {name}_op1 ^ {name}_op2;")
                
                lines.append(f"default: {name}_out = 32'd0;")
                lines.append(f"endcase")
                lines.append(f"end")

    def _write_controller(self, filepath):
        lines = [
            "module controller(",
            "input clk, rst, start,",
            "output reg op_ready, done_next, result_en,"
        ]

        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"output reg [{self.mux_bits-1}:0] {name}_sel1, {name}_sel2,")
                width = "[1:0] " if res_type == "LOG" else ""
                lines.append(f"output reg {width}{name}_op,")

        lines.extend([f"output reg reg_{n.node.op_type.lower()}{n.node.id}_en," for n in self.sorted_nodes])
        
        if lines[-1].endswith(","): lines[-1] = lines[-1][:-1]
        lines.append(");")

        lines.append("\nreg [31:0] state, next_state;")
        lines.append(f"localparam S_IDLE = 0, S_DONE = {self.max_time + 1};")
        lines.extend([f"localparam S_CYCLE_{t} = {t};" for t in range(1, self.max_time + 1)])

        lines.append("\nalways @(posedge clk or posedge rst) begin")
        lines.append("if (rst) state <= S_IDLE;")
        lines.append("else state <= next_state;")
        lines.append("end")

        lines.append("\nalways @(*) begin")
        lines.append("next_state = state;")
        lines.append("op_ready = 0;\ndone_next = 0;\nresult_en = 0;")
        
        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"{name}_sel1 = 0; {name}_sel2 = 0; {name}_op = 0;")
        
        for n in self.sorted_nodes:
            lines.append(f"reg_{n.node.op_type.lower()}{n.node.id}_en = 0;")

        lines.append("\ncase (state)")
        lines.append("S_IDLE: begin")
        lines.append("op_ready = 1;")
        lines.append("if (start) next_state = S_CYCLE_1;")
        lines.append("end")

        for t in range(1, self.max_time + 1):
            lines.append(f"S_CYCLE_{t}: begin")
            active_nodes = self.schedule_map.get(t, [])
            for info in active_nodes:
                self._append_node_control_logic(lines, info)

            if t < self.max_time:
                lines.append(f"next_state = S_CYCLE_{t+1};")
            else:
                lines.append("result_en = 1;")
                lines.append("next_state = S_DONE;")
            lines.append("end")

        lines.append("S_DONE: begin")
        lines.append("done_next = 1;")
        lines.append("next_state = S_IDLE;")
        lines.append("end")
        lines.append("endcase")
        lines.append("end")
        lines.append("endmodule")

        with open(filepath, "w") as f:
            f.write("\n".join(lines))

    def _append_node_control_logic(self, lines, info):
        res_name = f"{info.node.op_type.lower()}{info.resource_num}"
        reg_en_name = f"reg_{info.node.op_type.lower()}{info.node.id}_en"

        op1, op2 = info.node.operands[0], info.node.operands[1]
        src1_key = op1.name if isinstance(op1, IdentifierNode) else f"reg_{op1.op_type.lower()}{op1.id}"
        src2_key = op2.name if isinstance(op2, IdentifierNode) else f"reg_{op2.op_type.lower()}{op2.id}"
        
        lines.append(f"{res_name}_sel1 = {self.mux_bits}'d{self.mux_sources[src1_key]};")
        lines.append(f"{res_name}_sel2 = {self.mux_bits}'d{self.mux_sources[src2_key]};")
        lines.append(f"{reg_en_name} = 1;")

        op_code = "0"
        op_obj = info.node.op
        
        if isinstance(op_obj, (ast.Sub, ast.Div, ast.BitOr)):
            op_code = "1"
        elif isinstance(op_obj, ast.BitXor):
            op_code = "2"

        if info.node.op_type == "LOG":
            lines.append(f"{res_name}_op = 2'd{op_code};")
        else:
            lines.append(f"{res_name}_op = 1'b{op_code};")

    def _write_top_module(self, filepath):
        lines = [
            "module topModule(",
            "input clk, rst, start,"
        ]
        lines.extend([f"input [31:0] {inp}," for inp in self.inputs])
        lines.append("output [31:0] result,")
        lines.append("output done")
        lines.append(");")

        lines.append("\nwire op_ready, done_next, result_en;")

        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                lines.append(f"wire [{self.mux_bits-1}:0] {name}_sel1, {name}_sel2;")
                width = "[1:0] " if res_type == "LOG" else ""
                lines.append(f"wire {width}{name}_op;")
        
        lines.extend([f"wire reg_{n.node.op_type.lower()}{n.node.id}_en;" for n in self.sorted_nodes])

        lines.append("\ncontroller ctrl_inst (")
        lines.append(".clk(clk), .rst(rst), .start(start),")
        lines.append(".op_ready(op_ready), .done_next(done_next), .result_en(result_en),")
        
        ctrl_connections = []
        for res_type, count in self.resources.items():
            for i in range(1, count + 1):
                name = f"{res_type.lower()}{i}"
                ctrl_connections.append(f".{name}_sel1({name}_sel1)")
                ctrl_connections.append(f".{name}_sel2({name}_sel2)")
                ctrl_connections.append(f".{name}_op({name}_op)")
        
        for n in self.sorted_nodes:
            name = f"reg_{n.node.op_type.lower()}{n.node.id}_en"
            ctrl_connections.append(f".{name}({name})")
        
        lines.append(", ".join(ctrl_connections))
        lines.append(");")

        lines.append("\ndatapath dp_inst (")
        lines.append(".clk(clk), .rst(rst),")
        lines.append(", ".join([f".{inp}({inp})" for inp in self.inputs]) + ",")
        lines.append(".done_next(done_next), .result_en(result_en), .result(result), .done(done),")
        lines.append(", ".join(ctrl_connections))
        lines.append(");")
        lines.append("endmodule")

        with open(filepath, "w") as f:
            f.write("\n".join(lines))

    def _write_testbench(self, filepath):
        lines = [
            "`timescale 1ns / 1ps",
            "module tbTopModule;"
        ]

        lines.append("reg clk, rst, start;")
        for inp in self.inputs:
            lines.append(f"reg [31:0] {inp};")
        
        lines.append("wire [31:0] result;")
        lines.append("wire done;")

        lines.append("\ntopModule dut (")
        lines.append(".clk(clk), .rst(rst), .start(start),")
        lines.append(", ".join([f".{inp}({inp})" for inp in self.inputs]) + ",")
        lines.append(".result(result), .done(done)")
        lines.append(");")

        lines.append("\nalways #5 clk = ~clk;")

        
        def get_op_symbol(op_obj):
            if isinstance(op_obj, ast.Add): return "+"
            if isinstance(op_obj, ast.Sub): return "-"
            if isinstance(op_obj, ast.Mult): return "*"
            if isinstance(op_obj, ast.Div): return "/"
            if isinstance(op_obj, ast.Mod): return "%"
            if isinstance(op_obj, ast.BitAnd): return "&"
            if isinstance(op_obj, ast.BitOr): return "|"
            if isinstance(op_obj, ast.BitXor): return "^"
            return "?"

        for info in self.sorted_nodes:
            wire_name = f"expected_{info.node.id}"
            lines.append(f"wire [31:0] {wire_name};")
            
            op1, op2 = info.node.operands[0], info.node.operands[1]
            
            val1 = op1.name if isinstance(op1, IdentifierNode) else f"expected_{op1.id}"
            val2 = op2.name if isinstance(op2, IdentifierNode) else f"expected_{op2.id}"
            
            symbol = get_op_symbol(info.node.op)
            lines.append(f"assign {wire_name} = {val1} {symbol} {val2};")
        
        if self.sorted_nodes:
            expected_result_wire = f"expected_{self.sorted_nodes[-1].node.id}"
        else:
            expected_result_wire = "32'd0"

        lines.append("\ninitial begin")
        lines.append("clk = 0; rst = 1; start = 0;")
        for inp in self.inputs:
            lines.append(f"{inp} = 0;")
        
        lines.append("#20 rst = 0;")
        
        for inp in self.inputs:
            lines.append(f"{inp} = $urandom & 4'hF;")
        
        lines.append("#10 start = 1;")
        lines.append("#10 start = 0;")
        
        lines.append("wait(done == 1);")
        lines.append("#5;")
        lines.append(f'$display("Time: %0t | Result: %0d | Expected: %0d", $time, result, {expected_result_wire});')
        lines.append(f"if (result === {expected_result_wire}) begin")
        lines.append('$display("Test PASSED");')
        lines.append("end else begin")
        lines.append('$display("Test FAILED");')
        lines.append("end")
        
        lines.append("\n#20 $stop;")
        lines.append("end")
        lines.append("endmodule")

        with open(filepath, "w") as f:
            f.write("\n".join(lines))

def generate_verilog(folder_path: str, schedule_info: List[ScheduledNodeInfo]):
    if not schedule_info:
        print("Warning: Schedule info is empty. No Verilog generated.")
        return

    try:
        generator = VerilogGenerator(folder_path, schedule_info)
        generator.generate()
        print(f"Verilog codes successfully generated in {folder_path}/codes/")

        source_dir = os.path.join(folder_path, "codes")
        target_dir = "./samples/Code-test/codes"

        os.makedirs(target_dir, exist_ok=True)

        files_to_copy = ["Datapath.v", "Controller.v", "TopModule.v", "tbTopModule.v"]

        for filename in files_to_copy:
            src_file = os.path.join(source_dir, filename)
            dst_file = os.path.join(target_dir, filename)
            
            if os.path.exists(src_file):
                shutil.copy(src_file, dst_file)
                print(f"Copied {filename} to {target_dir}")
            else:
                print(f"Warning: {filename} was not found and could not be copied.")

    except Exception as e:
        print(f"Error generating Verilog: {e}")

def save_result(folder_path : str, schedule_info : list[ScheduledNodeInfo]):
    json_output = {}
    with open(folder_path + "/output.json", "w") as file:
        for node_info in schedule_info:
            json_output[node_info.node.id] = {
                "clk": node_info.scheduled_time,
                "resource_type": node_info.node.op_type,
                "resource_num": node_info.resource_num
            }
        json.dump(json_output, file, indent=4)


def run_test(folder_path : str):
    input_file_path = folder_path + "/input.json"
    data = load_input(input_file_path)

    dfg_root = build_dfg(expression=data["Expression"], folder_path=folder_path)

    schedule_info = schedule_dfg(dfg_root, algorithm=data["Algorithm"], config=data["Config"], folder_path=folder_path)

    save_result(folder_path=folder_path, schedule_info=schedule_info)

    generate_verilog(folder_path=folder_path, schedule_info=schedule_info)

def main():
    if len(sys.argv) > 1:
        run_test(folder_path=sys.argv[1])
    else:
        print("Please provide the input folder path.")

if __name__ == "__main__":
    main()
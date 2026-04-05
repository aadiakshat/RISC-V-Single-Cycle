module SRAM_Top (
    input clk,
    input reset,
    
    // External SRAM Interface
    output [18:0] sram_addr,
    inout  [15:0] sram_dq,
    output sram_ce_n,
    output sram_we_n,
    output sram_oe_n,
    output sram_lb_n,
    output sram_ub_n
);

    wire [31:0] PC, Instr, ReadData, WriteData, DataAddr;
    wire MemWrite;
    
    // Decode mem_read from opcode (load instructions are 7'b0000011)
    wire mem_read = (Instr[6:0] == 7'b0000011);
    
    wire sram_ready;
    
    // The core should stall if there is a memory operation requested and the SRAM controller hasn't signaled ready
    wire stall = (mem_read || MemWrite) && !sram_ready;

    Single_Cycle_Core core_top (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .Instr(Instr),
        .ReadData(ReadData),
        .PC(PC),
        .MemWrite(MemWrite),
        .ALUResult(DataAddr),
        .WriteData(WriteData)
    );

    Instruction_Memory Instr_Memory ( 
        .A(PC),
        .RD(Instr) 
    );
    
    SRAM_Controller sram_ctrl (
        .clk(clk),
        .reset(reset),
        
        .mem_read(mem_read),
        .mem_write(MemWrite),
        .size(Instr[14:12]),
        .addr(DataAddr),
        .wdata(WriteData),
        .rdata(ReadData),
        .ready(sram_ready),
        
        .sram_addr(sram_addr),
        .sram_dq(sram_dq),
        .sram_ce_n(sram_ce_n),
        .sram_we_n(sram_we_n),
        .sram_oe_n(sram_oe_n),
        .sram_lb_n(sram_lb_n),
        .sram_ub_n(sram_ub_n)
    );

endmodule

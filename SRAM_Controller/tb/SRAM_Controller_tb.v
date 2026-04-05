`timescale 1ns / 1ps

module SRAM_Controller_tb;

    reg clk;
    reg reset;
    
    reg mem_read;
    reg mem_write;
    reg [2:0] size;
    reg [31:0] addr;
    reg [31:0] wdata;
    
    wire [31:0] rdata;
    wire ready;
    
    wire [18:0] sram_addr;
    wire [15:0] sram_dq;
    wire sram_ce_n, sram_we_n, sram_oe_n, sram_lb_n, sram_ub_n;

    // Instantiate SRAM Controller
    SRAM_Controller uut (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .size(size),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .ready(ready),
        .sram_addr(sram_addr),
        .sram_dq(sram_dq),
        .sram_ce_n(sram_ce_n),
        .sram_we_n(sram_we_n),
        .sram_oe_n(sram_oe_n),
        .sram_lb_n(sram_lb_n),
        .sram_ub_n(sram_ub_n)
    );

    // Instantiate SRAM Model
    SRAM_Model model (
        .addr(sram_addr),
        .dq(sram_dq),
        .ce_n(sram_ce_n),
        .we_n(sram_we_n),
        .oe_n(sram_oe_n),
        .lb_n(sram_lb_n),
        .ub_n(sram_ub_n)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Helper task to perform a memory transaction
    task do_transaction;
        input is_write;
        input [2:0] t_size;
        input [31:0] t_addr;
        input [31:0] t_wdata;
        begin
            @(posedge clk);
            if (is_write) begin
                mem_write = 1;
                mem_read = 0;
            end else begin
                mem_write = 0;
                mem_read = 1;
            end
            size = t_size;
            addr = t_addr;
            wdata = t_wdata;
            
            // Wait for ready
            wait(ready == 1'b1);
            @(posedge clk);
            mem_write = 0;
            mem_read = 0;
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        mem_read = 0;
        mem_write = 0;
        size = 0;
        addr = 0;
        wdata = 0;
        
        #20 reset = 0;
        
        $display("Starting SRAM Tests...");
        
        // Test 1: Store Word (SW)
        $display("Test 1: SW at 0x100 = 0xDEADBEEF");
        do_transaction(1, 3'b010, 32'h100, 32'hDEADBEEF);
        
        // Test 2: Load Word (LW)
        $display("Test 2: LW at 0x100");
        do_transaction(0, 3'b010, 32'h100, 32'h0);
        #1;
        if (rdata == 32'hDEADBEEF) $display("  PASS: rdata = %h", rdata);
        else $display("  FAIL: rdata = %h", rdata);

        // Test 3: Store Halfword (SH)
        $display("Test 3: SH at 0x104 = 0xFACE");
        do_transaction(1, 3'b001, 32'h104, 32'hFACE);
        
        // Test 4: Load Halfword Sign-Extended (LH)
        $display("Test 4: LH at 0x104");
        do_transaction(0, 3'b001, 32'h104, 32'h0);
        #1;
        if (rdata == 32'hFFFFFACE) $display("  PASS: rdata = %h", rdata);
        else $display("  FAIL: rdata = %h (Expected FFFFFACE)", rdata);

        // Test 5: Store Byte (SB) on odd address
        $display("Test 5: SB at 0x109 = 0x85");
        do_transaction(1, 3'b000, 32'h109, 32'h85);
        
        // Test 6: Load Byte Sign-Extended (LB)
        $display("Test 6: LB at 0x109");
        do_transaction(0, 3'b000, 32'h109, 32'h0);
        #1;
        if (rdata == 32'hFFFFFF85) $display("  PASS: rdata = %h", rdata);
        else $display("  FAIL: rdata = %h (Expected FFFFFF85)", rdata);

        // Test 7: Load Byte UnSigned (LBU)
        $display("Test 7: LBU at 0x109");
        do_transaction(0, 3'b100, 32'h109, 32'h0);
        #1;
        if (rdata == 32'h00000085) $display("  PASS: rdata = %h", rdata);
        else $display("  FAIL: rdata = %h (Expected 00000085)", rdata);

        $display("Tests Completed.");
        $finish;
    end

endmodule

module SRAM_Model (
    input wire [18:0] addr,
    inout wire [15:0] dq,
    input wire ce_n,
    input wire we_n,
    input wire oe_n,
    input wire lb_n,
    input wire ub_n
);

    // 512K x 16-bit array = 1MB
    reg [15:0] mem [0:524287];
    
    // Initial memory state (optional)
    initial begin
        // Example initialization
        mem[0] = 16'h1122;
        mem[1] = 16'h3344;
    end

    // Write operation
    always @(addr or dq or ce_n or we_n or lb_n or ub_n) begin
        if (!ce_n && !we_n) begin
            if (!lb_n) mem[addr][7:0]   <= dq[7:0];
            if (!ub_n) mem[addr][15:8]  <= dq[15:8];
        end
    end

    // Read operation (output enable)
    wire read_en = !ce_n && we_n && !oe_n;
    
    wire [15:0] data_out;
    assign data_out[7:0]  = (!lb_n) ? mem[addr][7:0]  : 8'hzz;
    assign data_out[15:8] = (!ub_n) ? mem[addr][15:8] : 8'hzz;
    
    assign dq = read_en ? data_out : 16'hzzzz;

endmodule

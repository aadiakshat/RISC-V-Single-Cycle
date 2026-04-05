module SRAM_Controller (
    input clk,
    input reset,
    
    // CPU Interface
    input mem_read,
    input mem_write,
    input [2:0] size,      // funct3: 000=LB/SB, 001=LH/SH, 010=LW/SW, 100=LBU, 101=LHU
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata,
    output reg ready,      // 1 when transaction is done
    
    // SRAM Interface
    output wire [18:0] sram_addr,
    inout  wire [15:0] sram_dq,
    output wire sram_ce_n,
    output wire sram_we_n,
    output wire sram_oe_n,
    output wire sram_lb_n,
    output wire sram_ub_n
);

    localparam S_IDLE  = 2'd0,
               S_ACC1  = 2'd1,
               S_ACC2  = 2'd2,
               S_DONE  = 2'd3;

    reg [1:0] state, next_state;
    reg [31:0] read_buffer;
    
    // Wire assignments for SRAM interface based on current state
    reg [18:0] addr_out;
    reg we_n_out;
    reg oe_n_out;
    reg lb_n_out;
    reg ub_n_out;
    reg [15:0] dq_out;
    reg dq_en;
    
    assign sram_addr = addr_out;
    assign sram_ce_n = 1'b0; // Always enable chip for simplicity
    assign sram_we_n = we_n_out;
    assign sram_oe_n = oe_n_out;
    assign sram_lb_n = lb_n_out;
    assign sram_ub_n = ub_n_out;
    assign sram_dq   = dq_en ? dq_out : 16'hzzzz;

    wire is_word = (size == 3'b010);
    wire is_half = (size == 3'b001) || (size == 3'b101);
    wire is_byte = (size == 3'b000) || (size == 3'b100);

    // Sequential logic for state and read_buffer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            read_buffer <= 32'd0;
        end else begin
            state <= next_state;
            
            // Capture data on state transitions
            if (state == S_ACC1 && mem_read) begin
                read_buffer[15:0] <= sram_dq;
            end
            if (state == S_ACC2 && mem_read) begin
                read_buffer[31:16] <= sram_dq;
            end
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (mem_read || mem_write)
                    next_state = S_ACC1;
            end
            S_ACC1: begin
                if (is_word)
                    next_state = S_ACC2;
                else
                    next_state = S_DONE;
            end
            S_ACC2: begin
                next_state = S_DONE;
            end
            S_DONE: begin
                // Always transition straight to IDLE to ensure back-to-back 
                // memory instructions start a fresh transaction safely.
                next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Combinational logic for outputs
    always @(*) begin
        // Defaults
        addr_out = 19'd0;
        we_n_out = 1'b1;
        oe_n_out = 1'b1;
        lb_n_out = 1'b0;
        ub_n_out = 1'b0;
        dq_out   = 16'd0;
        dq_en    = 1'b0;
        ready    = 1'b0;
        rdata    = 32'd0;
        
        case (state)
            S_IDLE: begin
                // In IDLE, keep SRAM disabled
                oe_n_out = 1'b1;
                we_n_out = 1'b1;
                lb_n_out = 1'b1;
                ub_n_out = 1'b1;
            end
            
            S_ACC1: begin
                addr_out = addr[19:1]; // Word address
                if (mem_write) begin
                    we_n_out = 1'b0;
                    oe_n_out = 1'b1;
                    dq_en    = 1'b1;
                    if (is_word) begin
                        dq_out   = wdata[15:0];
                        lb_n_out = 1'b0;
                        ub_n_out = 1'b0;
                    end else if (is_half) begin
                        dq_out   = wdata[15:0];
                        lb_n_out = 1'b0;
                        ub_n_out = 1'b0;
                    end else if (is_byte) begin
                        if (addr[0] == 1'b0) begin
                            dq_out   = {8'h00, wdata[7:0]};
                            lb_n_out = 1'b0;
                            ub_n_out = 1'b1;
                        end else begin
                            dq_out   = {wdata[7:0], 8'h00};
                            lb_n_out = 1'b1;
                            ub_n_out = 1'b0;
                        end
                    end
                end else if (mem_read) begin
                    we_n_out = 1'b1;
                    oe_n_out = 1'b0;
                    dq_en    = 1'b0;
                    if (is_word || is_half) begin
                        lb_n_out = 1'b0;
                        ub_n_out = 1'b0;
                    end else if (is_byte) begin
                        lb_n_out = addr[0];
                        ub_n_out = ~addr[0];
                    end
                end
            end
            
            S_ACC2: begin // Only reached for WORD access
                addr_out = addr[19:1] + 19'd1;
                if (mem_write) begin
                    we_n_out = 1'b0;
                    oe_n_out = 1'b1;
                    dq_en    = 1'b1;
                    dq_out   = wdata[31:16];
                    lb_n_out = 1'b0;
                    ub_n_out = 1'b0;
                end else if (mem_read) begin
                    we_n_out = 1'b1;
                    oe_n_out = 1'b0;
                    dq_en    = 1'b0;
                    lb_n_out = 1'b0;
                    ub_n_out = 1'b0;
                end
            end
            
            S_DONE: begin
                ready = 1'b1;
                we_n_out = 1'b1;
                oe_n_out = 1'b1;
                
                // Format read output based on funct3
                if (is_word) begin
                    rdata = {read_buffer[31:16], read_buffer[15:0]};
                end else if (is_half) begin
                    if (size == 3'b101) // LHU
                        rdata = {16'd0, read_buffer[15:0]};
                    else              // LH
                        rdata = {{16{read_buffer[15]}}, read_buffer[15:0]};
                end else if (is_byte) begin
                    wire [7:0] b_val = addr[0] ? read_buffer[15:8] : read_buffer[7:0];
                    if (size == 3'b100) // LBU
                        rdata = {24'd0, b_val};
                    else              // LB
                        rdata = {{24{b_val[7]}}, b_val};
                end
            end
        endcase
    end

endmodule

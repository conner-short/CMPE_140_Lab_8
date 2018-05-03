`timescale 1ns / 1ps

module factorial_top(
    input wire clk,
    input wire reset,
    input wire [1:0] addr,
    input wire we,
    input wire [3:0] wd,
    output reg [31:0] rd);
    wire go_pulse_cmb, go_pulse, go;
    wire done, err;
    wire [31:0] result, result_read;
    wire res_done, res_err;
    wire we1, we2;
    wire [1:0] rd_sel;
    wire [3:0] n_read;
    
    // Address decoder
    fact_addr_dec addr_dec(.addr(addr), .we(we), .we1(we1), .we2(we2), .rd_sel(rd_sel));
    
    // Input registers
    factorial_dreg #(.WIDTH(4)) reg_n(.clk(clk), .reset(reset), .load(we1), .d(wd), .q(n_read));
    factorial_dreg #(.WIDTH(1)) reg_go(.clk(clk), .reset(reset), .load(we2), .d(wd[0]), .q(go));
    
    // Go pulse register
    factorial_dreg #(.WIDTH(1)) reg_go_pulse(.clk(clk), .reset(reset), .load(1'b1), .d(go_pulse_cmb), .q(go_pulse));
    
    // Result register
    factorial_dreg #(.WIDTH(32)) reg_result(.clk(clk), .reset(reset), .load(done), .d(result), .q(result_read));
    
    // Status regsiters
    factorial_dreg #(.WIDTH(1)) reg_done(.clk(clk), .reset(reset), .load(1'b1), .d((~go_pulse_cmb) & (done | res_done)), .q(res_done));
    factorial_dreg #(.WIDTH(1)) reg_err(.clk(clk), .reset(reset), .load(1'b1), .d((~go_pulse_cmb) & (err | res_err)), .q(res_err));
    
    // Accelerator core
    factorial fact_accel(.clk(clk), .reset(reset), .go(go_pulse), .d(n_read), .q(result), .done(done), .err(err));
    
    // Read data logic
    always@(*)
    begin
        case(rd_sel)
        2'b00: rd = {{28{1'b0}}, n_read};
        2'b01: rd = {{31{1'b0}}, go};
        2'b10: rd = {{30{1'b0}}, res_err, res_done};
        2'b11: rd = result_read;
        default: rd = {32{1'bx}};
        endcase
    end
    
    assign go_pulse_cmb = we2 & wd[0];
endmodule

`timescale 1ns / 1ps

module gpio_top(
    input wire clk,
    input wire reset,
    input wire [1:0] addr,
    input wire we,
    input wire [31:0] gpi1,
    input wire [31:0] gpi2,
    input wire [31:0] wd,
    output wire [31:0] gpo1,
    output wire [31:0] gpo2,
    output reg [31:0] rd
);
    wire we1, we2;
    wire [1:0] rd_sel;
    
    // Address decoder
    gpio_addr_dec addr_dec(.addr(addr), .we(we), .we1(we1), .we2(we2), .rd_sel(rd_sel));
    
    // Output registers
    factorial_dreg reg_gpo1(.clk(clk), .reset(reset), .load(we1), .d(wd), .q(gpo1));
    factorial_dreg reg_gpo2(.clk(clk), .reset(reset), .load(we2), .d(wd), .q(gpo2));
    
    // Read data logic
    always@(*)
    begin
        case(rd_sel)
        2'b00:   rd = gpi1;
        2'b01:   rd = gpi2;
        2'b10:   rd = gpo1;
        2'b11:   rd = gpo2;
        default: rd = {32{1'bx}};
        endcase
    end
endmodule

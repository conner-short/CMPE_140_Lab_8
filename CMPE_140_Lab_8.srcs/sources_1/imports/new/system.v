`timescale 1ns / 1ps

module system(
    input wire clk,
    input wire reset,
    input wire [31:0] gpi1,
    input wire [31:0] gpi2,
    output wire [31:0] gpo1,
    output wire [31:0] gpo2,
    output wire [31:0] pc);
    reg [31:0] rd;
    wire [31:0] instr, rd_dm, rd_f, rd_gpio, alu_out, wd, pc_current;
    wire [1:0] rd_sel;
    wire we, we_gpio, we_f, we_dm;
    
    assign pc = pc_current;
    
    // CPU
    mips cpu(.clk(clk), .rst(reset), .ra3(5'b00000), .instr(instr), .rd_dm(rd), .we_dm(we), .pc_current(pc_current), .alu_out(alu_out), .wd_dm(wd), .rd3());
    
    // Address decoder
    addr_dec dec(.addr(alu_out), .we(we), .we_gpio(we_gpio), .we_f(we_f), .we_dm(we_dm), .rd_sel(rd_sel));
        
    // Read data multiplexer
    always@(*)
    begin
        case(rd_sel)
        2'b00:   begin rd = rd_dm; end
        2'b01:   begin rd = rd_f; end
        2'b10:   begin rd = rd_gpio; end
        default: begin rd = {32{1'bx}}; end
        endcase
    end
        
    // Instruction memory
    imem instr_mem(pc_current[7:2], instr);
    
    // Main memory
    dmem          dmem  (.clk(clk), .we(we_dm), .a(alu_out[7:2]), .d(wd), .q(rd_dm));
    factorial_top fact  (.clk(clk), .reset(reset), .addr(alu_out[3:2]), .we(we_f), .wd(wd[3:0]), .rd(rd_f));
    gpio_top      gpio  (.clk(clk), .reset(reset), .addr(alu_out[3:2]), .we(we_gpio), .gpi1(gpi1), .gpi2(gpi2), .wd(wd), .gpo1(gpo1), .gpo2(gpo2), .rd(rd_gpio));
endmodule

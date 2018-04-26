`timescale 1ns / 1ps

module factorial_dp #(
    parameter D_WIDTH = 4,
    parameter Q_WIDTH = 32
) (
    input wire clk,
    input wire reset,
    input wire counter_load,
    input wire counter_en,
    input wire register_d_mux_sel,
    input wire output_en,
    input wire register_load,
    input wire [D_WIDTH - 1 : 0] d,
    output wire counter_gt_1,
    output wire [Q_WIDTH - 1 : 0] q,
    output wire d_gt_12
);
    wire [D_WIDTH - 1 : 0] counter_q;
    wire [Q_WIDTH - 1 : 0] multiplier_q;
    wire [Q_WIDTH - 1 : 0] register_q;
    wire [Q_WIDTH - 1 : 0] register_d;
    
    cmp #(.WIDTH(D_WIDTH)) d_gt_12_cmp(.a(d), .b('hC), .gt(d_gt_12));
    
    cnt #(.WIDTH(D_WIDTH)) counter (.clk(clk), .en(counter_en), .load(counter_load), .d(d), .q(counter_q));
    mul #(.WIDTH(Q_WIDTH)) multiplier (.a({{(Q_WIDTH - D_WIDTH){1'b0}}, counter_q}), .b(register_q), .q(multiplier_q));
    
    cmp #(.WIDTH(D_WIDTH)) counter_gt_1_cmp (.a(counter_q), .b({{(D_WIDTH - 1){1'b0}}, 1'b1}), .gt(counter_gt_1));
    
    mux #(.WIDTH(Q_WIDTH)) register_d_mux (.a('d1), .b(multiplier_q), .sel(register_d_mux_sel), .q(register_d));
    mux #(.WIDTH(Q_WIDTH)) output_mux (.a('d0), .b(register_q), .sel(output_en), .q(q));
    
    dreg #(.WIDTH(Q_WIDTH)) register (.clk(clk), .reset(reset), .load(register_load), .d(register_d), .q(register_q));
endmodule

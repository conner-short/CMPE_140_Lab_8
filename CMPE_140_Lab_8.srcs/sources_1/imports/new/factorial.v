`timescale 1ns / 1ps

module factorial #(
    parameter D_WIDTH = 4,
    parameter Q_WIDTH = 32
) (
    input wire clk,
    input wire reset,
    input wire go,
    input wire [D_WIDTH - 1 : 0] d,
    output wire [Q_WIDTH - 1 : 0] q,
    output wire done,
    output wire err
);
    wire counter_gt_1, counter_load, counter_en, register_d_mux_sel, output_en, register_load, d_gt_12;
    
    factorial_cu cu (
        .clk(clk),
        .reset(reset),
        .go(go),
        .counter_gt_1(counter_gt_1),
        .d_gt_12(d_gt_12),
        .counter_load(counter_load),
        .counter_en(counter_en),
        .register_d_mux_sel(register_d_mux_sel),
        .output_en(output_en),
        .register_load(register_load),
        .done(done),
        .err(err)
    );
    
    factorial_dp #(.D_WIDTH(D_WIDTH), .Q_WIDTH(Q_WIDTH)) dp (
        .clk(clk),
        .reset(reset),
        .counter_load(counter_load),
        .counter_en(counter_en),
        .register_d_mux_sel(register_d_mux_sel),
        .output_en(output_en),
        .register_load(register_load),
        .d(d),
        .counter_gt_1(counter_gt_1),
        .q(q),
        .d_gt_12(d_gt_12)
    );
endmodule

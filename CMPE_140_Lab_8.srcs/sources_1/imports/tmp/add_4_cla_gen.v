`timescale 1ns / 1ps

module add_4_cla_gen(input [3:0] ha_carry_bits, input [3:0] ha_sum_bits, input carry_in, output [4:0] cla_bits);
    assign cla_bits[0] = carry_in;
    assign cla_bits[1] = ha_carry_bits[0] ^ (ha_sum_bits[0] & carry_in);
    assign cla_bits[2] = ha_carry_bits[1] ^ (ha_sum_bits[1] & (ha_carry_bits[0] ^ (ha_sum_bits[0] & carry_in)));
    assign cla_bits[3] = ha_carry_bits[2]
        ^ (ha_sum_bits[2] & (ha_carry_bits[1]
        ^ (ha_sum_bits[1] & (ha_carry_bits[0]
        ^ (ha_sum_bits[0] & carry_in)))));
    assign cla_bits[4] = ha_carry_bits[3]
        ^ (ha_sum_bits[3] & (ha_carry_bits[2]
        ^ (ha_sum_bits[2] & (ha_carry_bits[1]
        ^ (ha_sum_bits[1] & (ha_carry_bits[0]
        ^ (ha_sum_bits[0] & carry_in)))))));
endmodule

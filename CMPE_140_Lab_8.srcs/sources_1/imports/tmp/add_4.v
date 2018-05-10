`timescale 1ns / 1ps

module add_4(input [3:0] a, input [3:0] b, input carry_in, output [3:0] sum, output carry_out);
    wire [3:0] ha_sum;
    wire [3:0] ha_carry;
    wire [4:0] cla_bits;
    
    add_4_ha_array U0(a, b, ha_sum, ha_carry);
    
    add_4_cla_gen U1(ha_carry, ha_sum, carry_in, cla_bits);
    
    add_4_xor U2(ha_sum, cla_bits, {carry_out, sum});
endmodule
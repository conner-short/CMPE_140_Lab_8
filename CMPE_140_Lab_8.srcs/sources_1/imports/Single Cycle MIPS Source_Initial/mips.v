module mips
(input clk, rst, [4:0] ra3, [31:0] instr, rd_dm, output we_dm, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire       pc_src, jump, we_reg, alu_src, mult_en, mf_ctrl, pc_ovr, zero;
    wire [1:0] reg_dst, wd_ctrl, dm2reg;
    wire [2:0] alu_ctrl;
    datapath    dp (clk, rst, pc_src, jump, we_reg, alu_src, pc_ovr, mult_en, mf_ctrl, dm2reg, reg_dst, alu_ctrl, ra3, instr, rd_dm, wd_ctrl, zero, pc_current, alu_out, wd_dm, rd3);
    controlunit cu (zero, instr[31:26], instr[5:0], pc_src, jump, we_reg, alu_src, we_dm, mult_en, mf_ctrl, pc_ovr, dm2reg, wd_ctrl, reg_dst, alu_ctrl);
endmodule
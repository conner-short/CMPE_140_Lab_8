module controlunit
(input zero, [5:0] opcode, funct, output pc_src, jump, we_reg, alu_src, we_dm, mult_en, mf_ctrl, pc_ovr, [1:0] dm2reg, [1:0] wd_ctrl, [1:0] reg_dst, [2:0] alu_ctrl);
    wire [1:0] alu_op;
    assign pc_src = branch & zero;
    maindec md (opcode, branch, jump, we_reg, alu_src, we_dm, dm2reg, alu_op, reg_dst);
    auxdec  ad (alu_op, funct, mult_en, mf_ctrl, pc_ovr, wd_ctrl, alu_ctrl);
endmodule
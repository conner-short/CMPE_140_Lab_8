module datapath
(input clk, rst, pc_src, jump, we_reg, alu_src, pc_ovr, mult_en, mf_ctrl, [1:0] dm2reg, [1:0] reg_dst, [2:0] alu_ctrl, [4:0] ra3, [31:0] instr, rd_dm, [1:0] wd_ctrl, output zero, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire [4:0]  rf_wa;
    wire [31:0] pc_plus4, pc_pre, pc_next, sext_imm, ba, bta, jta, alu_pa, alu_pb, wd_rf, pc_final, jal_wa, mult_lo, mult_hi, lo_reg_out, hi_reg_out, mf_mux_out, rf_wd_out;
    wire [63:0] mult_out;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    assign jal_wa = {5'b11111};
    
    assign mult_lo = {mult_out[31:0]};
    assign mult_hi = {mult_out[63:32]};
    
    // --- PC Logic --- //
    dreg       pc_reg     (clk, rst, pc_final, pc_current);
    adder      pc_plus_4  (pc_current, 4, pc_plus4);
    adder      pc_plus_br (pc_plus4, ba, bta);
    mux2 #(32) pc_src_mux (pc_src, pc_plus4, bta, pc_pre);
    mux2 #(32) pc_jmp_mux (jump, pc_pre, jta, pc_next);
    
    // EXTENDED DESIGN
    mux2 #(32) pc_ovr_mux (pc_ovr, pc_next, alu_pa, pc_final); // jr -  
    
    // --- RF Logic --- //
    mux4 #(5)  rf_wa_mux  (reg_dst, instr[20:16], instr[15:11], jal_wa, 5'b00000, rf_wa); // supports JAL write address
    regfile    rf         (clk, we_reg, instr[25:21], instr[20:16], ra3, rf_wa, rf_wd_out, alu_pa, wd_dm, rd3);
    signext    se         (instr[15:0], sext_imm);
    
    mux4 #(32) rf_wd_mux4 (wd_ctrl, wd_rf, mf_mux_out,  5'b00000, 5'b00000, rf_wd_out); 
    
    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (alu_src, wd_dm, sext_imm, alu_pb);
    alu        alu        (alu_ctrl, alu_pa, alu_pb, zero, alu_out);
    // --- MEM Logic --- //
    mux4 #(32) rf_wd_mux  (dm2reg, alu_out, rd_dm, pc_plus4, 5'b00000, wd_rf);
    
    // --- MULT Logic --- // 
    mult              mult       (alu_pa, wd_dm, mult_out);
    dreg2 #(32)       lo_reg     (clk, mult_en, mult_lo, lo_reg_out);
    dreg2 #(32)       hi_reg     (clk, mult_en, mult_hi, hi_reg_out);
    mux2 #(32)        mf_mux     (mf_ctrl, lo_reg_out, hi_reg_out, mf_mux_out);
    
endmodule
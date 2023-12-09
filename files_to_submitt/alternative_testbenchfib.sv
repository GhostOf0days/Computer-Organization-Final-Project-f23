`timescale 1 ns / 1 ps

module test_cpu
    Computer cpu();
    initial begin
        cpu.instr_mem.ram['h100] = 'h2128;
        cpu.instr_mem.ram['h102] = 'h312A;
        cpu.instr_mem.ram['h104] = 'h2122;
        cpu.instr_mem.ram['h106] = 'h3124;
        cpu.instr_mem.ram['h108] = 'h2124;
        cpu.instr_mem.ram['h10A] = 'h0122;
        cpu.instr_mem.ram['h10C] = 'h3126;
        cpu.instr_mem.ram['h10E] = 'h2124;
        cpu.instr_mem.ram['h110] = 'h3122;
        cpu.instr_mem.ram['h112] = 'h2126;
        cpu.instr_mem.ram['h114] = 'h3124;
        cpu.instr_mem.ram['h116] = 'h212A;
        cpu.instr_mem.ram['h118] = 'h012C;
        cpu.instr_mem.ram['h11A] = 'h312A;
        cpu.instr_mem.ram['h11C] = 'h5400;
        cpu.instr_mem.ram['h11E] = 'h6108;
        cpu.instr_mem.ram['h120] = 'h1000;
        cpu.instr_mem.ram['h122] = 'h0000;
        cpu.instr_mem.ram['h124] = 'h0001;
        cpu.instr_mem.ram['h126] = 'h0000;
        cpu.instr_mem.ram['h128] = 'h0009;
        cpu.instr_mem.ram['h12A] = 'h0000;
        cpu.instr_mem.ram['h12C] = 'hFFFF;
    end
endmodule
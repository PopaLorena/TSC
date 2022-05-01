/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  `include "first_class.sv"

module instr_register_test
  import instr_register_pkg::*;
    (
      tb_ifc.TEST lab2_if 
    );
 
 //initializeza inceputul unui block temporar
  initial begin 
  
    first_class fs;
    fs = new(lab2_if);
    fs.run();
  
  end
  //timeunit 1ns/1ns;

endmodule: instr_register_test
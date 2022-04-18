class first_class;
  
  virtual tb_ifc.TEST lab2_if;
  parameter NUMBER_Of_TR = 100;

  covergroup my_funct_coverage;
    coverpoint  lab2_if.cb.operand_a{
      bins  operand_a_values_neg[] = {[-15:-1]};
      bins  operand_a_values_zero[] = {0};
      bins  operand_a_values_pos[] = {[1:15]};
    }
    coverpoint lab2_if.cb.operand_b{
      bins operand_b_values_zero[]  = {0};
      bins operand_b_values_pos[]  = {[1:15]};
    }
    coverpoint lab2_if.cb.opcode{
      bins opcode_values_zero[]  = {0};
      bins opcode_values_pos[]  = {[1:7]};
    }
  endgroup

 function new(virtual tb_ifc _lab2_if);
    lab2_if= _lab2_if;
    my_funct_coverage = new();
 endfunction

  // int seed = 777;
  int k = 0;

  //initial begin
  task run();
    $display("\n\n******************FIRST DISPLAY**************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    lab2_if.cb.write_pointer  <= 5'h00;         // initialize write pointer 5 biti in heza cu valoarea 0
    lab2_if.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    lab2_if.cb.load_en        <= 1'b0;          // initialize load control line
    lab2_if.cb.reset_n        <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge lab2_if.cb) ;     // hold in reset for 2 clock cycles
    lab2_if.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge lab2_if.cb) lab2_if.cb.load_en <= 1'b1;  // enable writing to register
    repeat (NUMBER_Of_TR) begin
      @(posedge lab2_if.cb) randomize_transaction;
      my_funct_coverage.sample();
      @(negedge lab2_if.cb) print_transaction;
      my_funct_coverage.sample();
    end
    @(posedge lab2_if.cb) lab2_if.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=NUMBER_Of_TR-1; i>=0; i--) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      k = $unsigned($urandom)%10;
      @(posedge lab2_if.cb) lab2_if.cb.read_pointer <= k;
      my_funct_coverage.sample();
      @(negedge lab2_if.cb) print_results;
      my_funct_coverage.sample();
    end

    @( posedge lab2_if.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  endtask 
 // end


  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    lab2_if.cb.operand_a     <= ($signed($urandom))%16;                 // between -15 and 15 // random genereaza valori pe 32 de biti.
    lab2_if.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    lab2_if.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    lab2_if.cb.write_pointer <= temp++;
    
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2_if.cb.write_pointer);
    $display("  opcode = %0d (%s)", lab2_if.cb.opcode, lab2_if.cb.opcode.name);
    $display("  operand_a = %0d",   lab2_if.cb.operand_a);
    $display("  operand_b = %0d\n", lab2_if.cb.operand_b);
  endfunction: print_transaction
 // functia returneaza o valoarem, Task-ul nu
 // task-ul consuma timp de simulare, functia nu
  function void print_results;
    $display("Read from register location %0d: ", lab2_if.cb.read_pointer);
    $display("  opcode = %0d (%s)", lab2_if.cb.instruction_word.opc, lab2_if.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   lab2_if.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", lab2_if.cb.instruction_word.op_b);
    $display("  result    = %0d\n", lab2_if.cb.instruction_word.result);
  endfunction: print_results

endclass

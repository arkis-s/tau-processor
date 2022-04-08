module execution_driver (
    input wire clock, enable, instruction_finish_control_line,
    output reg microcode_sequencer_load_n, microcode_sequencer_enable, microcode_rom_read_enable, program_counter_enable
);

    reg [4:0] state = 0;

    // set values at t = 0
    initial begin
        microcode_sequencer_load_n <= 1;
        microcode_sequencer_enable <= 0;
        microcode_rom_read_enable <= 0;
        program_counter_enable <= 0;
    end


    always @ (negedge clock) begin

        case(state)

                0: begin
                    // cold boot, can't rely on the instruction to be ready
                    // so we buffer for a clock cycle
                    state++;
                    $display("(%t) STATE 0 - COLD BOOT", $time);
                end

                1: begin
                    // load the opcode from the current instruction into the microcode counter
                    // and set to rom to be readable
                    microcode_sequencer_load_n <= 0;
                    microcode_rom_read_enable <= 1;
                    state++;
                    $display("(%t) STATE 1 - LOADED INSTRUCTION", $time);
                end

                2: begin
                    // return load signal back to normal
                    microcode_sequencer_load_n <= 1;

                    // because 1-cycle opcodes exist, we must first check that we haven't
                    // already finished executing the instruction ever since the rom read
                    // enable had gone high
                    // 
                    // if we finished - we can already fetch the next instruction
                    // if not - enable the microcode counter
                    if (instruction_finish_control_line) begin
                        program_counter_enable <= 1;
                        state = state + 2; // skip state 3 which loops until finished
                        $display("(%t) STATE 2 - SHORT INSTRUCTION", $time);
                    end else begin
                        microcode_sequencer_enable <= 1;
                        state++;
                        $display("(%t) STATE 2 - LONG INSTRUCTION", $time);
                    end

                end

                3: begin
                    // if the instruction has finished...
                    if(instruction_finish_control_line) begin
                        // ...set the appropriate control lines
                        microcode_sequencer_enable <= 0;
                        microcode_rom_read_enable <= 0;
                        program_counter_enable <= 1;
                        state++;
                        $display("(%t) STATE 3 - INSTRUCTION FINISHED", $time);
                    end else begin
                        // ...otherwise remain at the same state
                        state <= state;
                        $display("(%t) STATE 3 - INSTRUCTION ON GOING", $time);
                    end
                end

                4: begin
                    // disable the program counter and jump to state 0 on next clock
                    program_counter_enable <= 0;
                    state <= 1;
                    $display("(%t) STATE 4 - EXECUTION FINISHED\n", $time);
                end
        endcase
    end
endmodule
/*module execution_driver (
    input wire clock, enable, instruction_finish_control_line, halt, jump_flag, reset,
    output wire microcode_sequencer_load_n, microcode_sequencer_enable, 
                microcode_rom_read_enable, 
                program_counter_enable, program_counter_load_n
);

    //logic [4:0] state <= 0;
    //logic already_jumping <= 0;

    reg [4:0] state;
    reg already_jumping;

    reg reg_microcode_sequencer_load_n, reg_microcode_sequencer_enable, reg_microcode_rom_read_enable,
        reg_program_counter_enable, reg_program_counter_load_n;

    assign microcode_sequencer_load_n = reg_microcode_sequencer_load_n;
    assign microcode_sequencer_enable = reg_microcode_sequencer_enable;
    assign microcode_rom_read_enable = reg_microcode_rom_read_enable;
    assign program_counter_enable = reg_program_counter_enable;
    assign program_counter_load_n = reg_program_counter_load_n;

    // set values at t = 0
    initial begin
        reg_microcode_sequencer_load_n <= 1;
        reg_microcode_sequencer_enable <= 0;
        reg_microcode_rom_read_enable <= 0;
        reg_program_counter_enable <= 0;
        reg_program_counter_load_n <= 1;
    end

    //always @ (posedge halt) begin
    //    state = 5;
    //    reg_microcode_sequencer_load_n <= 1;
    //    reg_microcode_sequencer_enable <= 0;
    //    reg_microcode_rom_read_enable <= 0;
    //    reg_program_counter_enable <= 0;
    //end
//
    //always @ (posedge jump_flag) begin
    //    state = 6;
    //    reg_microcode_sequencer_load_n <= 1;
    //    reg_microcode_sequencer_enable <= 0;
    //    reg_microcode_rom_read_enable <= 0;
    //    reg_program_counter_load_n <= 0;
    //    $display("(%g) JUMP INSTRUCTION STARTED", $time);
    //end

    //always @ (negedge clock or halt or jump_flag) begin
    always @ (negedge clock or posedge reset) begin

        if (reset) begin
            state <= 0;
        end else begin

            if (halt) begin
                state <= 5;
                reg_microcode_sequencer_load_n <= 1;
                reg_microcode_sequencer_enable <= 0;
                reg_microcode_rom_read_enable <= 0;
                reg_program_counter_enable <= 0;
            end

            if (jump_flag & !already_jumping & !halt) begin
                if (state != 1) begin
                    $display("STATE %h - HIT IF STATEMENT", state);
                    state <= 6;
                    already_jumping <= 1;
                end else begin
                    state <= state;
                end
            end else if (!clock) begin
                case(state)

                        0: begin
                            // cold boot, can't rely on the instruction to be ready
                            // so we buffer for a clock cycle
                            //state++;
                            state <= 1;
                            already_jumping <= 0;
                            $display("(%g) STATE 0 - COLD BOOT", $time);
                            reg_microcode_sequencer_load_n <= 1;
                            reg_microcode_sequencer_enable <= 0;
                            reg_microcode_rom_read_enable <= 0;
                            reg_program_counter_enable <= 0;
                            reg_program_counter_load_n <= 1;
                        end

                        1: begin
                            // load the opcode from the current instruction into the microcode counter
                            // and set to rom to be readable
                            reg_microcode_sequencer_load_n <= 0;
                            reg_microcode_rom_read_enable <= 1;
                            //state++;
                            state <= state + 1;
                            $display("(%g) STATE 1 - LOADED INSTRUCTION", $time);
                        end

                        2: begin
                            // return load signal back to normal
                            reg_microcode_sequencer_load_n <= 1;

                            // because 1-cycle opcodes exist, we must first check that we haven't
                            // already finished executing the instruction ever since the rom read
                            // enable had gone high
                            // 
                            // if we finished - we can already fetch the next instruction
                            // if not - enable the microcode counter
                            if (instruction_finish_control_line) begin
                                reg_program_counter_enable <= 1;
                                state <= state + 2; // skip state 3 which loops until finished
                                $display("(%g) STATE 2 - SHORT INSTRUCTION", $time);
                            end else begin
                                reg_microcode_sequencer_enable <= 1;
                                //state++;
                                state <= state + 1;
                                $display("(%g) STATE 2 - LONG INSTRUCTION", $time);
                            end

                        end

                        3: begin
                            // if the instruction has finished...
                            if(instruction_finish_control_line) begin
                                // ...set the appropriate control lines
                                reg_microcode_sequencer_enable <= 0;
                                reg_microcode_rom_read_enable <= 0;
                                reg_program_counter_enable <= 1;
                                //state++;
                                state <= state + 1;
                                $display("(%g) STATE 3 - INSTRUCTION FINISHED", $time);
                            end else begin
                                // ...otherwise remain at the same state
                                state <= state;
                                $display("(%g) STATE 3 - INSTRUCTION ON GOING", $time);
                            end
                        end

                        4: begin
                            // disable the program counter and jump to state 1 on next clock
                            reg_program_counter_enable <= 0;
                            state <= 1;
                            $display("(%g) STATE 4 - EXECUTION FINISHED\n", $time);
                        end

                        5: begin
                            reg_microcode_sequencer_load_n <= 1;
                            reg_microcode_sequencer_enable <= 0;
                            reg_microcode_rom_read_enable <= 0;
                            reg_program_counter_enable <= 0;
                            $display("(%g) STATE 5 - HALT.\n", $time);
                        end

                        6: begin
                            //reg_program_counter_load_n <= 1;
                            //state <= 1;
                            reg_microcode_sequencer_load_n <= 1;
                            reg_microcode_sequencer_enable <= 0;
                            reg_microcode_rom_read_enable <= 0;
                            reg_program_counter_load_n <= 0;  
                            state <= 7;
                            $display("(%g) STATE 6 - JUMP INSTRUCTION STARTED\n", $time);
                        end
                        
                        7: begin
                            reg_program_counter_load_n <= 1;
                            already_jumping <= 0;
                            state <= 1;
                            $display("(%g) STATE 7 - JUMP INSTRUCTION FINISHED\n", $time);
                        end

                        default: state <= 0;

                endcase
            end
        end
    end
endmodule*/


module execution_driver (
    input wire clock, enable, instruction_finish_control_line, halt, jump_flag, reset,
    output wire microcode_sequencer_load_n, microcode_sequencer_enable, 
                microcode_rom_read_enable, 
                program_counter_enable, program_counter_load_n
);

    logic [4:0] state = 0;

    reg reg_microcode_sequencer_load_n, reg_microcode_sequencer_enable, reg_microcode_rom_read_enable,
        reg_program_counter_enable, reg_program_counter_load_n;

    assign microcode_sequencer_load_n = reg_microcode_sequencer_load_n;
    assign microcode_sequencer_enable = reg_microcode_sequencer_enable;
    assign microcode_rom_read_enable = reg_microcode_rom_read_enable;
    assign program_counter_enable = reg_program_counter_enable;
    assign program_counter_load_n = reg_program_counter_load_n;

    // set values at t = 0
    initial begin
        reg_microcode_sequencer_load_n <= 1;
        reg_microcode_sequencer_enable <= 0;
        reg_microcode_rom_read_enable <= 0;
        reg_program_counter_enable <= 0;
        reg_program_counter_load_n <= 1;
    end

    always @ (posedge halt) begin
        state = 5;
        reg_microcode_sequencer_load_n <= 1;
        reg_microcode_sequencer_enable <= 0;
        reg_microcode_rom_read_enable <= 0;
        reg_program_counter_enable <= 0;
    end

    always @ (posedge jump_flag) begin
        state = 6;
        reg_microcode_sequencer_load_n <= 1;
        reg_microcode_sequencer_enable <= 0;
        reg_microcode_rom_read_enable <= 0;
        reg_program_counter_load_n <= 0;
        $display("(%g) JUMP INSTRUCTION STARTED", $time);
    end

    always @ (negedge clock) begin

        case(state)

                0: begin
                    // cold boot, can't rely on the instruction to be ready
                    // so we buffer for a clock cycle
                    state++;
                    $display("(%g) STATE 0 - COLD BOOT", $time);
                end

                1: begin
                    // load the opcode from the current instruction into the microcode counter
                    // and set to rom to be readable
                    reg_microcode_sequencer_load_n <= 0;
                    reg_microcode_rom_read_enable <= 1;
                    state++;
                    $display("(%g) STATE 1 - LOADED INSTRUCTION", $time);
                end

                2: begin
                    // return load signal back to normal
                    reg_microcode_sequencer_load_n <= 1;

                    // because 1-cycle opcodes exist, we must first check that we haven't
                    // already finished executing the instruction ever since the rom read
                    // enable had gone high
                    // 
                    // if we finished - we can already fetch the next instruction
                    // if not - enable the microcode counter
                    if (instruction_finish_control_line) begin
                        reg_program_counter_enable <= 1;
                        state = state + 2; // skip state 3 which loops until finished
                        $display("(%g) STATE 2 - SHORT INSTRUCTION", $time);
                    end else begin
                        reg_microcode_sequencer_enable <= 1;
                        state++;
                        $display("(%g) STATE 2 - LONG INSTRUCTION", $time);
                    end

                end

                3: begin
                    // if the instruction has finished...
                    if(instruction_finish_control_line) begin
                        // ...set the appropriate control lines
                        reg_microcode_sequencer_enable <= 0;
                        reg_microcode_rom_read_enable <= 0;
                        reg_program_counter_enable <= 1;
                        state++;
                        $display("(%g) STATE 3 - INSTRUCTION FINISHED", $time);
                    end else begin
                        // ...otherwise remain at the same state
                        state <= state;
                        $display("(%g) STATE 3 - INSTRUCTION ON GOING", $time);
                    end
                end

                4: begin
                    // disable the program counter and jump to state 1 on next clock
                    reg_program_counter_enable <= 0;
                    state <= 1;
                    $display("(%g) STATE 4 - EXECUTION FINISHED\n", $time);
                end

                5: begin
                    reg_microcode_sequencer_load_n <= 1;
                    reg_microcode_sequencer_enable <= 0;
                    reg_microcode_rom_read_enable <= 0;
                    reg_program_counter_enable <= 0;
                    $display("(%g) STATE 5 - HALT.\n", $time);
                end

                6: begin
                    reg_program_counter_load_n <= 1;
                    state <= 1;
                    $display("(%g) STATE 6 - JUMP INSTRUCTION FINISHED\n", $time);
                end

        endcase
    end
endmodule
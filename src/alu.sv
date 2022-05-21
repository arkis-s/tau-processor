module alu # (
    parameter WORD_SIZE = 8
) (
    input wire [WORD_SIZE-1:0] input_A, input_B,
    input wire [3:0] mode_select,
    output reg [7:0] flags = 0,
    output reg [WORD_SIZE-1:0] output_C
);

    // FLAGS REGISTER:
    // [7] - Zero Flag -- 1 if result is 0, else 0
    // [6] - Sign Flag -- 1 if MSB is 1, else 0
    // [5] - Carry Flag -- 1 if unsigned overflow, else 0  --> make addition wider than the input bus and concatenate them together
    //
    // VVV http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt - OF = C6 XOR C7
    // [4] - Overflow Flag -- 1 if signed overflow, else 0 --> overflow happens when there is a carry into the sign but, but no carry out of the sign bit
    // [3]:[0] - undef

    typedef enum {ZERO=7, SIGN=6, CARRY=5, OVERFLOW=4} FLAG_NAME_ENUM;

    // input -- final value for evaluation
    function is_zero (input [WORD_SIZE-1:0] A); begin
        is_zero = (A == {WORD_SIZE-1{1'b0}});
    end
    endfunction

    // input -- final value for evaluation
    function is_signed (input [WORD_SIZE-1:0] A); begin
        is_signed = A[7];
    end
    endfunction

    // input -- both original values
    function has_carry_add (input [WORD_SIZE-1:0] A, B); begin
        automatic logic [WORD_SIZE:0] temp_add = A + B;
        has_carry_add = temp_add[WORD_SIZE];
    end
    endfunction

    function has_carry_subtract (input [WORD_SIZE-1:0] A, B); begin
        // https://retrocomputing.stackexchange.com/questions/5953/carry-flag-in-8080-8085-subtraction
        if (B > A) begin
            has_carry_subtract = 1;
        end else begin
            has_carry_subtract = 0;
        end
    end
    endfunction

    function has_carry_shift (input [WORD_SIZE:0] temp_in); begin
        has_carry_shift = temp_in[WORD_SIZE];
    end
    endfunction

    // input -- both original values
    function has_overflow (input [WORD_SIZE-1:0] A, B); begin

        // if word = 8 then word-2 = 6
        // a[word-2:0] + b[word-2:0] + cin
        // 7th bit is C6 carry

        // a+b+cin
        // 8th bit is C7 carry

        // if wordsize = 8 then wordsize-1 = 7 and wordsize-2 = 6
        // so size 6 will generate carry into bit 7

        // do we need to add the carry flag? unsure
        // http://www.righto.com/2012/12/the-6502-overflow-flag-explained.html
        automatic logic [WORD_SIZE-1:0] add_low = A[WORD_SIZE-2:0] + B[WORD_SIZE-2:0] + flags[CARRY];
        automatic logic [WORD_SIZE:0] add_all = A + B + flags[CARRY];

        has_overflow = add_low[WORD_SIZE-1] ^ add_all[WORD_SIZE];
    end
    endfunction

        // input -- both original values
    function has_overflow_subtract (input [WORD_SIZE-1:0] A, B); begin 
        //https://stackoverflow.com/questions/8034566/overflow-and-carry-flags-on-z80/8037485#8037485
        //https://en.wikipedia.org/wiki/Carry_flag
        //https://stackoverflow.com/questions/8053053/how-does-an-adder-perform-unsigned-integer-subtraction/8061989#8061989
        //https://stackoverflow.com/questions/8965923/carry-overflow-subtraction-in-x86
        automatic logic [WORD_SIZE-1:0] add_low = A[WORD_SIZE-2:0] - (B[WORD_SIZE-2:0] + ~flags[CARRY]);
        automatic logic [WORD_SIZE:0] add_all = A - (B + ~flags[CARRY]);

        has_overflow_subtract = add_low[WORD_SIZE-1] ^ add_all[WORD_SIZE];
    end
    endfunction

    logic [WORD_SIZE-1:0] temp;
    logic [WORD_SIZE:0] temp_plus_one;

    always_comb begin
        case(mode_select)
            
            // do nothing
            0: output_C = output_C;
            
            // move B into C
            1: output_C = input_B;

            // compare a & b
            2:  begin
                temp = input_A - input_B;
                $display("ALU CMP TEMP A - B = C --- %h - %h = %h", input_A, input_B, temp);
                flags[ZERO] = is_zero(temp);
                flags[SIGN] = is_signed(temp);
                flags[CARRY] = has_carry_subtract(input_A, input_B);
                flags[OVERFLOW] = has_overflow_subtract(input_A, input_B);
            end

            // test a & b
            3:  begin
                temp = input_A & input_B;
                flags[OVERFLOW] = 0;
                flags[CARRY] = 0;
                flags[ZERO] = is_zero(temp);
                flags[SIGN] = is_signed(temp);
            end

            //shift a left b times
            4:  begin
                temp_plus_one = input_A << input_B;
                output_C = temp_plus_one[WORD_SIZE-1:0];

                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
                // flags[CARRY] = has_carry_shift(temp_plus_one);
                flags[CARRY] = temp_plus_one[WORD_SIZE];
            end
            
            //shift a right b times
            5:  begin

                temp_plus_one[WORD_SIZE:1] = input_A;
                temp_plus_one = temp_plus_one >> input_B;
                output_C = temp_plus_one[WORD_SIZE:1];

                flags[CARRY] = temp_plus_one[0];
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
            end

            // add =  a + b
            6:  begin
                //temp = a + b;
                output_C = input_A + input_B;
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
                flags[CARRY] = has_carry_add(input_A, input_B);
                flags[OVERFLOW] = has_overflow(input_A, input_B); 
            end

            // adc = a + b + carry
            7:  begin
                output_C = input_A + input_B + flags[CARRY];
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
                flags[CARRY] = has_carry_add(input_A, input_B);
                flags[OVERFLOW] = has_overflow(input_A, input_B); 
            end

            // sub = a - b
            8:  begin
                output_C = input_A - input_B;
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
                flags[CARRY] = has_carry_add(input_A, input_B);
                flags[OVERFLOW] = has_overflow_subtract(input_A, input_B); 
            end

            // sbb = a - (b + carry)
            9:  begin
                output_C = input_A - (input_B + flags[CARRY]);
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
                flags[CARRY] = has_carry_add(input_A, input_B);
                flags[OVERFLOW] = has_overflow_subtract(input_A, input_B); 
            end

            // mul = a * b
            10: begin
                output_C = input_A * input_B;
                flags[ZERO] = is_zero(output_C);
                flags[SIGN] = is_signed(output_C);
            end

            // and = a and b
            11: begin
                output_C = input_A & input_B;
                flags[OVERFLOW] = 0;
                flags[CARRY] = 0;
                flags[SIGN] = is_signed(output_C);
                flags[ZERO] = is_zero(output_C);
            end

            // or
            12: begin
                output_C = input_A | input_B;
                flags[OVERFLOW] = 0;
                flags[CARRY] = 0;
                flags[SIGN] = is_signed(output_C);
                flags[ZERO] = is_zero(output_C);
            end

            // xor
            13: begin
                output_C = input_A ^ input_B;
                flags[OVERFLOW] = 0;
                flags[CARRY] = 0;
                flags[SIGN] = is_signed(output_C);
                flags[ZERO] = is_zero(output_C);
            end

            // not
            14: begin
                output_C = ~input_A;
                //flags[OVERFLOW] = 0;
                //flags[CARRY] = 0;
                //flags[SIGN] = is_signed(output_C);
                //flags[ZERO] = is_zero(output_C);

            end

            15: begin
                flags = 0;
            end

            default: output_C = output_C;
        endcase
    end


endmodule

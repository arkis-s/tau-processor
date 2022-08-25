//module seg_decode (
//    input wire [3:0] input_values,
//    output 
//)
// https://www.nandland.com/vhdl/modules/binary-to-7-segment.html#:~:text=A%20Seven-Segment%20Display%20is,Alarm%20Clock



module seg_decode (
    input wire [3:0] index,
    output logic [7:0] output_value
);

    // element-pos index:
    // 
    //  7   6   5   4   3   2   1   0
    //  A   B   C   D   E   F   G   DP


    always_comb begin

        case (index)

            0: output_value = 8'b11111100; // 0
            1: output_value = 8'b01100000; // 1
            2: output_value = 8'b11011010; // 2
            3: output_value = 8'b11110010; // 3
            4: output_value = 8'b01100110; // 4
            5: output_value = 8'b10110110; // 5
            6: output_value = 8'b10111110; // 6
            7: output_value = 8'b11100000; // 7
            8: output_value = 8'b11111110; // 8
            9: output_value = 8'b11110110; // 9
            10: output_value = 8'b11101110; // A
            11: output_value = 8'b00111110; // B
            12: output_value = 8'b10011100; // C
            13: output_value = 8'b01111010; // D
            14: output_value = 8'b10011110; // E
            15: output_value = 8'b10001110; // F

            default: output_value = 8'b00000001;

        endcase 
    end

endmodule


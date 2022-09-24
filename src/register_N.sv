module register_N # (
    parameter WORD_SIZE = 8
) (
    // inputs: clock, enable, read (onto bus), write (into register), reset, value
    // output: register content
    input wire clock, enable, read, write, reset,
    input wire [WORD_SIZE-1:0] input_value,
    output logic [WORD_SIZE-1:0] output_value
);

    reg [WORD_SIZE-1:0] register_val;

    always_ff @(posedge clock) begin
        if (reset) begin
            register_val <= 0;
        end else if (enable) begin
            if (read) begin
                // read the value of the register onto the bus
                output_value <= register_val; 
            end else if (write) begin
                // write the value of the bus into the register
                register_val <= input_value;
            end
        end 
    end
    
endmodule
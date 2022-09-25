module counter_loadable # (
    parameter WIDTH = 8
) (
    // inputs: clock, enable, count, load, reset, load_value
    // outputs: counter_value

    input wire clock, enable, reset, count, load,
    input wire [WIDTH-1:0] load_value,
    output reg [WIDTH-1:0] counter_value
);

    always_ff @(posedge clock) begin

        if (reset) begin
            counter_value <= 0;
        end else if (enable) begin
            if (count) begin
                counter_value <= counter_value + 1;
            end else if (load) begin
                counter_value <= load_value;
            end
        end

    end

endmodule
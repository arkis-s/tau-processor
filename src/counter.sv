module counter_w_load # (
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 8
) (
    input wire clock, load, enable,
    input wire [ADDRESS_WIDTH-1:0] address,
    output reg [DATA_WIDTH-1:0] data 
);

    initial begin
        data = 0;
    end

    always @ (posedge clock or negedge load or negedge enable) begin

        // load is active low, so only perform action when load = 0
        // but if statement fires when !0 = 1
        if (!load) begin
            if (ADDRESS_WIDTH != DATA_WIDTH) begin
                // TODO: do i need to specify this?
                // apparently this was for loading due to mismatched
                // sizes on the microcode example
                data <= {{DATA_WIDTH-ADDRESS_WIDTH{1'b0}}, address};
            end else begin
                data <= address;
            end
        end else if (enable) begin
            data++;
        end else begin
            data = data;
        end
    end
endmodule

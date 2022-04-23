module vga_driver (
    input wire clock_25mhz,
    output reg [9:0] x, y,
    output reg hsync, vsync, in_active_area
);

    initial begin
        x <= 0; y <= 0;
    end

    assign in_active_area = (x <= 639 && y <= 479);
    assign hsync = ~(x >= 655 & x <= 751);
    assign vsync = ~(y >= 489 & y <= 491);

    always @ (posedge clock_25mhz) begin

        if (x == 799) begin
            x <= 0;
            y <= (y == 524) ? 0 : y + 1;
        end else begin
            x++;
        end

    end

endmodule
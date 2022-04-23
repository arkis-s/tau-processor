module vga_vram_interface ( 
    input wire [8:0] x, y,
    input wire [15:0] vram_in,
    input wire in_active_area,
    output reg [15:0] vram_addr = 0,
    output reg [3:0] pixel_data
);

    // 12 bits wide because the first 4 are directly indexed
    reg [11:0] vram_buffer;

    reg [1:0] state = 0;
    
    reg [15:0] current_vga_addr;
    assign current_vga_addr = (y * 320 + x);

    always @ (x or y or in_active_area) begin
        if (in_active_area) begin
            case (state)
                0: begin
                    vram_buffer <= vram_in[11:0];
                    //pixel data is output directly from the vram datalines because
                    // the buffer will not be ready in time for this pixel
                    pixel_data <= vram_in[15:12];
                    state++;
                end

                1: begin
                    vram_addr++;
                    pixel_data <= vram_buffer[11:8];
                    state++;
                end

                2: begin
                    pixel_data <= vram_buffer[7:4];
                    state++;
                end

                3: begin
                    pixel_data <= vram_buffer[3:0];
                    state++;
                end

            endcase
        end else begin
            pixel_data <= 0;
        end
    end








    // always_comb begin
    // always @ (x or y or in_active_area) begin

    //     if (in_active_area) begin
    //         if (buffer_pointer + 1 == 4) begin
    //             vram_addr++;
    //             buffer_pointer <= 0;
    //         end else begin
    //             if (cold_boot) begin
    //                 buffer_pointer <= 0;
    //                 cold_boot <= 0;
    //             end else begin
    //                 buffer_pointer++;
    //             end 
    //         end
    //     end else begin
    //         buffer_pointer <= 0;
    //     end
    // end

    // always @ (in_active_area or buffer_pointer) begin
    //     if (in_active_area) begin
    //         case (buffer_pointer[1:0])
    //             0: pixel_data <= vram_in[15:12];
    //             1: pixel_data <= vram_in[11:8];
    //             2: pixel_data <= vram_in[7:4];
    //             3: pixel_data <= vram_in[3:0];
    //         endcase
    //     end else begin
    //         pixel_data <= 0;
    //     end
    // end

endmodule
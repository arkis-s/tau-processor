module vga_vram_interface (
	 input wire clock,
    input wire [8:0] x, y,
    input wire [15:0] vram_in,
    input wire in_active_area,
    output reg [15:0] vram_addr = 0,
    output reg [3:0] pixel_data
);

    // 12 bits wide because the first 4 are directly indexed
    reg [11:0] vram_buffer;

    reg [2:0] state = 0;
    reg [6:0] used_word_count = 0;
    reg [9:0] vram_line_tracker = 0;

    // reg [15:0] current_vga_addr;
    // assign current_vga_addr = (y * 320 + x);

    // always_comb begin
    // always @ (x) begin
    always @ (posedge clock) begin

        if (in_active_area) begin

            case (state)
                0: begin
                    vram_buffer <= vram_in[11:0];
                    pixel_data <= vram_in[15:12];
                    state++;
                end

                1: begin pixel_data <= pixel_data; state++; end

                2: begin
                    pixel_data <= vram_buffer[11:8];
                    state++;
                end

                3: begin pixel_data <= pixel_data; state++; end

                4: begin
                    pixel_data <= vram_buffer[7:4];
                    state++;
                end

                5: begin pixel_data <= pixel_data; state++; end

                6: begin
                    pixel_data <= vram_buffer[3:0];
                    state++;
                    vram_addr++;
                end

                7: begin pixel_data <= pixel_data; state <= 0; end

                default: pixel_data <= 0;

            endcase

        end else if (in_active_area == 0 & y >= 240) begin
            // pixel_data <= 0;
            vram_addr <= 0;
        end else begin
            // pixel_data <= 0;
            vram_addr <= y * 80;
        end
        
        if (~in_active_area) begin
            pixel_data <= 0;
        end

        
        //else begin
            //pixel_data <= 0;
            //state <= 0;

            //if (y == 239) begin
            //    vram_addr <= 0;
            //end else begin
            //    vram_addr <= y * 80;
            //end
        //end

    end


    /*always @ (posedge clock) begin
    // always @ (x or y) begin

        if (in_active_area) begin

            case (state)

                0: begin
                    vram_buffer <= vram_in[11:0];
                    pixel_data <= vram_in[15:12];
                    state++;
                end

                1: begin pixel_data <= pixel_data; state++; end

                2: begin
                    pixel_data <= vram_buffer[11:8];
                    state++;
                end

                3: begin pixel_data <= pixel_data; state++; end

                4: begin
                    pixel_data <= vram_buffer[7:4];
                    state++;
                end

                5: begin pixel_data <= pixel_data; state++; end

                6: begin

                    if (used_word_count == 79) begin

                        if (y[0] == 1) begin
                            if (y == 0) begin
                                vram_addr <= 0;
                                used_word_count = 0;
                            end else begin
                                vram_addr <= (vram_line_tracker * 320) / 4;
                                used_word_count = 0;
                            end
                        end else if (y[0] == 1) begin
                            vram_line_tracker++;
                        end
                    end else begin
                        vram_addr++;
                        used_word_count++;
                    end

                    pixel_data <= vram_buffer[3:0];
                    state++;

                end

                7: begin pixel_data <= pixel_data; state <= 0; end

            endcase

        end

    end*/



    /*always @ (posedge clock) begin

        if (in_active_area) begin    

            case(state)

                0: begin
                    vram_buffer <= vram_in[11:0];
                    pixel_data <= vram_in[15:12];
                    // used_word_count++;
                    state++;
                end

                1: begin
                    
                    if (used_word_count == 80) begin

                        // if y is even...
                        if (y[0] == 0) begin
                            // if we are at the very beginning of the active area..
                            if (y == 0 & x == 319) begin
                                // we want to repeat the same 80 words so
                                vram_addr <= 0;
                                vram_line_tracker <= 0;
                                used_word_count = 0;
                            end else begin
                                vram_addr <= (vram_line_tracker * 320 ) / 4;
                                used_word_count = 0;
                            end
                        end else if (y[0] == 1) begin
                            vram_addr <= ((vram_line_tracker + 1) * 320) / 4;
                            // vram_line_tracker++;
                            used_word_count = 0;
                        end

                    end else begin
                        vram_addr++;
                    end

                    pixel_data <= vram_buffer[11:8];
                    // used_word_count++;
                    state++;

                end

                2: begin
                    pixel_data <= vram_buffer[7:4];
                    // used_word_count++;
                    state++;
                end

                3: begin
                    pixel_data <= vram_buffer[3:0];
                    used_word_count++;
                    state <= 0;
                end


            endcase

        end else begin
            pixel_data <= 0;
        end

    end*/




	// always @ (posedge clock) begin
    //     if (in_active_area) begin
    //         case (state)
    //             0: begin
    //                 vram_buffer <= vram_in[11:0];
    //                 //pixel data is output directly from the vram datalines because
    //                 // the buffer will not be ready in time for this pixel
    //                 pixel_data <= vram_in[15:12];
    //                 state <= 1;
    //             end

    //             1: begin
    //                  //if (vram_addr == 19199) begin
    //                  //    vram_addr <= 0;
    //                  //end else begin
    //                   //   vram_addr++;
    //                  //end
	// 					  vram_addr++;
    //                 pixel_data <= vram_buffer[11:8];
    //                 state <= 2;
    //             end

    //             2: begin
    //                 pixel_data <= vram_buffer[7:4];
    //                 state <= 3;
    //             end

    //             3: begin
	// 					  if (vram_addr == 19200) begin
	// 							vram_addr <= 0;
	// 					  end
    //                 pixel_data <= vram_buffer[3:0];
    //                 state <= 0;
    //             end

    //         endcase
    //     end else begin
    //         pixel_data <= 0;
    //     end
    // end

endmodule
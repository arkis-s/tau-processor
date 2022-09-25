module testbench_counter_loadable;

    localparam CLOCK = 2;
    localparam CYCLE = CLOCK * 2;
    reg clk = 0;
    always #CLOCK clk = ~clk;

    localparam WORD = 8;


    reg [WORD-1:0] load_value;
    wire [WORD-1:0] output_counter_val;

    reg en, rst, count_up, count_down, load = 0;

    counter_loadable # (.WIDTH(WORD)) uut_counter_loadable (
        .clock(clk), .enable(en), .reset(rst), .count_up(count_up), .count_down(count_down), .load(load),
        .load_value(load_value), .counter_value(output_counter_val)
    );

    initial begin
        //$monitor("(%g) enable: %b, reset: %b, count up?: %b, count_down?: %b load?: %b\nload_value: %h\toutput_value: %h", $time, en, rst, count_up, count_down, load, load_value, output_counter_val);
        load_value = 'hDE;
        #CLOCK;

        // reset - change reg from x to 0
        rst = 1; #CYCLE; rst = 0;
        assert (output_counter_val == 0) $display("RST OK.");

        // count up no enable - no change expected
        count_up = 1; #CYCLE; count_up = 0;
        assert (output_counter_val == 0) $display("count up no enable OK.");
        
        // count down no enable - no change expected
        count_down = 1; #CYCLE; count_down = 0;
        assert (output_counter_val == 0) $display("count down no enable OK.");

        // count up with enable - 0 to 2
        count_up = 1; en = 1; #CYCLE; #CYCLE; count_up = 0;
        assert (output_counter_val == 2) $display("count up with enable OK.");

        // count down with enable - 2 to 0
        count_down = 1; #CYCLE; #CYCLE; count_down = 0;
        assert (output_counter_val == 0) $display("count down with enable OK.");

        // load no enable - remains at 0
        en = 0; load = 1; #CYCLE;
        assert (output_counter_val == 0) $display("load no enable OK.");

        // load with enable - value becomes loaded val
        en = 1; #CYCLE; load = 0;
        assert (output_counter_val == load_value) $display("value loaded correctly OK.");

        // count up with loaded val
        count_up = 1; #CYCLE; count_up = 0;
        assert (output_counter_val == load_value + 1) $display("counted up OK.");

        // count down with loaded val
        count_down = 1; #CYCLE; #CYCLE; count_down = 0; en = 0;
        assert (output_counter_val == load_value - 1) $display("counted down OK.");

        #4; $stop;
    end

endmodule
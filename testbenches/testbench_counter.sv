module testbench_counter_loadable;

    localparam CLOCK = 2;
    localparam CYCLE = CLOCK * 2;
    reg clk = 0;
    always #CLOCK clk = ~clk;

    localparam WORD = 8;


    reg [WORD-1:0] load_value;
    wire [WORD-1:0] output_counter_val;

    reg en, rst, count, load = 0;

    counter_loadable # (.WIDTH(WORD)) uut_counter_loadable (
        .clock(clk), .enable(en), .reset(rst), .count(count), .load(load),
        .load_value(load_value), .counter_value(output_counter_val)
    );

    initial begin
        $monitor("(%g) enable: %b, reset: %b, count?: %b, load?: %b\nload_value: %h\toutput_value: %h", $time, en, rst, count, load, load_value, output_counter_val);
        load_value = 'hDE;
        #CLOCK;

        // reset - change reg from x to 0
        rst = 1; #CYCLE; rst = 0;

        // count no enable - does not change from 0
        count = 1; #CYCLE;

        // count w enable - changes from 0 to 2
        en = 1; #CYCLE; #CYCLE;

        // load no enable - remains at 2
        count = 0; en = 0; load = 1; #CYCLE;

        // load w enable - changes to load_value value
        en = 1; #CYCLE;

        // count with loaded value - example: DE + 2 = E0
        load = 0; count = 1; #CYCLE; #CYCLE; en = 0;

        #4; $stop;


    end

endmodule
module testbench_registerN;


    localparam CLOCK = 2;
    localparam CYCLE = CLOCK * 2;
    reg clk = 0;
    always #CLOCK clk = ~clk;

    localparam WORD_SIZE = 8;

    reg [WORD_SIZE-1:0] input_bus = 0;
    wire [WORD_SIZE-1:0] output_bus;

    reg en, r, w, rst = 0;

    register_N # (.WORD_SIZE(WORD_SIZE) ) uut_reg (
        .clock(clk), .enable(en), .read(r), .write(w), .reset(rst),
        .input_value(input_bus), .output_value(output_bus)
    );


    initial begin

        $monitor("(%g) enable: %b, reset: %b, read: %b, write: %b\ninput: %h\toutput: %h", $time, en, rst, r, w, input_bus, output_bus);
        input_bus = 'hDE;  
        #CLOCK; 
        
        // reset test - sets internal register value to 0
        rst = 1; #CYCLE;
        rst = 0; #CYCLE;
 
        // read with no enable - should not do anything
        r = 1; #CYCLE;

        //read with enable - read the value stored (0) in the register onto the bus
        en = 1; #CYCLE;

        // write with no enable - should not do anything
        en = 0; r = 0; w = 1; #CYCLE;

        // write with enable - read the input bus value and store in internal register
        en = 1; #CYCLE;

        // read with enable - updates output bus with new value
        r = 1; w = 0; #CYCLE;

        // write uncertain bus
        r = 0; w = 1; input_bus = 'hxx; #CYCLE;

        // reset
        w = 0; rst = 1; #CYCLE; rst = 0; #CYCLE;

        #4; $stop;


    end
endmodule
`include ".\\src\\memory_controller.sv"

module testbench_memory_controller;

    localparam WORD_SIZE = 16;
    localparam PERIOD = 5;

    typedef enum logic [2:0] {
        // load = load from memory into reg
        // store = store from reg into memory
        LOAD = 1, STORE = 2,
        LOADV = 3, STOREV = 4,
        PEEK = 5, OTHER = 'x
    } load_store_op_set;

    load_store_op_set instruction;

    reg [WORD_SIZE-1:0] pc_addr, input_addr_ef, input_data_gh;
    wire p_ram_rw, v_ram_rw;
    wire [WORD_SIZE-1:0] p_ram_addr, v_ram_addr, p_ram_data, v_ram_data;

    memory_controller # (
        .INPUT_ADDRESS_WIDTH(WORD_SIZE), .INPUT_DATA_WIDTH(WORD_SIZE)
    ) uut_memory_controller (
        .program_counter_address(pc_addr), .input_address(input_addr_ef),
        .input_data(input_data_gh), .microcode_control(instruction),
        .p_ram_rw(p_ram_rw), .v_ram_rw(v_ram_rw),
        .p_ram_address(p_ram_addr), .v_ram_address(v_ram_addr),
        .p_ram_data(p_ram_data), .v_ram_data(v_ram_data)
    );

    initial begin

        $monitor("(%g) operation: %s\npc: %h, input_addr: %h, input_data: %h\nprogram ram:\n\tr(0)w(1): %b\n\taddr: %h\n\tdata: %h\nvideo ram:\n\tr(0)w(1): %b\n\taddr: %h\n\tdata: %h",
        $time, instruction.name(), pc_addr, input_addr_ef, input_data_gh, p_ram_rw, p_ram_addr, p_ram_data, v_ram_rw, v_ram_addr, v_ram_data);

        instruction = OTHER;
        pc_addr = 'hFEEB;
        input_addr_ef = 'hF000;
        input_data_gh = 'h9999;
        #PERIOD;

        pc_addr = 'hBEEF; #PERIOD;

        instruction = LOAD; #PERIOD;
        instruction = OTHER; #PERIOD;
        instruction = STORE; #PERIOD;
        instruction = OTHER; pc_addr++; #PERIOD;

        instruction = LOADV; input_addr_ef = 'hEEEE; #PERIOD;
        instruction = STOREV; input_addr_ef = 'hAEAE; input_data_gh = 'hBBBB; #PERIOD;

        instruction = OTHER; #PERIOD;
        pc_addr = 'h0001; instruction = PEEK; #PERIOD;
        
    end



endmodule
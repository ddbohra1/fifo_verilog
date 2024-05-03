module data_processor_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clk = 0;                // Clock
    reg rst_n = 1;              // Active low reset
    reg fifo1_write_en = 1;     // FIFO 1 write enable
    reg fifo1_read_en = 1;      // FIFO 1 read enable
    reg [7:0] fifo1_data_in;    // FIFO 1 data input
    wire [19:0] fifo1_data_out; // FIFO 1 data output
    wire fifo1_ready;           // FIFO 1 ready signal
    wire fifo1_empty;           // FIFO 1 empty flag
    reg fifo2_write_en = 1;     // FIFO 2 write enable
    reg fifo2_read_en = 1;      // FIFO 2 read enable
    reg [7:0] fifo2_data_in;    // FIFO 2 data input
    wire [19:0] fifo2_data_out; // FIFO 2 data output
    wire fifo2_ready;           // FIFO 2 ready signal
    wire fifo2_empty;           // FIFO 2 empty flag
    wire [7:0] recovered_data_item; // Recovered data item
    
    // Instantiate the data_processor module
    data_processor dut (
        .clk(clk),
        .rst_n(rst_n),
        .fifo1_write_en(fifo1_write_en),
        .fifo1_read_en(fifo1_read_en),
        .fifo1_data_in(fifo1_data_in),
        .fifo1_data_out(fifo1_data_out),
        .fifo1_ready(fifo1_ready),
        .fifo1_empty(fifo1_empty),
        .fifo2_write_en(fifo2_write_en),
        .fifo2_read_en(fifo2_read_en),
        .fifo2_data_in(fifo2_data_in),
        .fifo2_data_out(fifo2_data_out),
        .fifo2_ready(fifo2_ready),
        .fifo2_empty(fifo2_empty),
        .recovered_data_item(recovered_data_item)
    );
    
    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Initial stimulus
    initial begin
        // Reset
        rst_n = 0;
        #20;
        rst_n = 1;
        
        // FIFO 1 initial data
        fifo1_data_in = 8'hAB;
        #10;
        fifo1_data_in = 8'hCD;
        #10;
        fifo1_data_in = 8'hEF;
        
        // FIFO 2 initial data
        fifo2_data_in = 8'h12;
        #10;
        fifo2_data_in = 8'h34;
        #10;
        fifo2_data_in = 8'h56;
        
        // Test Case 1: FIFO 1 Greater Magnitude
        //#10;
        //fifo1_data_in = 8'hFF; // Higher magnitude
        //#10;
        //fifo2_data_in = 8'h7F; // Lower magnitude
        
        
        //$finish;
        // Further test stimulus can be added here
    end

    // Monitor
    always @(posedge clk) begin
        // Display outputs
        $display("Time=%0t: FIFO1 Data=%h, FIFO2 Data=%h, Recovered Data=%h", $time, fifo1_data_out, fifo2_data_out, recovered_data_item);
    end
    
endmodule

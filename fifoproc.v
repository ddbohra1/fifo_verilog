module data_processor (
    input wire clk,               // Clock
    input wire rst_n,             // Active Low Reset
    
    // FIFO 1 Interface
    input wire fifo1_write_en,    // FIFO 1 Write Enable
    input wire fifo1_read_en,     // FIFO 1 Read Enable
    input wire [7:0] fifo1_data_in,  // FIFO 1 Data Input
    output wire [19:0] fifo1_data_out, // FIFO 1 Data Output
    output wire fifo1_ready,      // FIFO 1 Ready Signal
    output wire fifo1_empty,      // FIFO 1 Empty Flag
    
    // FIFO 2 Interface
    input wire fifo2_write_en,    // FIFO 2 Write Enable
    input wire fifo2_read_en,     // FIFO 2 Read Enable
    input wire [7:0] fifo2_data_in, // FIFO 2 Data Input
    output wire [19:0] fifo2_data_out, // FIFO 2 Data Output
    output wire fifo2_ready,      // FIFO 2 Ready Signal
    output wire fifo2_empty,      // FIFO 2 Empty Flag
    
    // Output for recovering original data item
    output reg [7:0] recovered_data_item
);

reg [19:0] packet1;
reg [19:0] packet2;
reg packet1_greater_than_packet2;
reg [15:0] decomposed_data_item;

// FIFO 1 Depth of 18
parameter FIFO1_DEPTH = 18;
reg [7:0] fifo1_mem [0:FIFO1_DEPTH-1];
reg [4:0] fifo1_ptr_wr;
reg [4:0] fifo1_ptr_rd;

// FIFO 2 Depth of 24
parameter FIFO2_DEPTH = 24;
reg [7:0] fifo2_mem [0:FIFO2_DEPTH-1];
reg [4:0] fifo2_ptr_wr;
reg [4:0] fifo2_ptr_rd;

// Logic to compare the magnitude of successive packets
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        packet1 <= 20'h00000;
        packet2 <= 20'h00000;
    end else begin
        if (fifo1_ready && fifo2_ready) begin
            packet1 <= fifo1_data_out;
            packet2 <= fifo2_data_out;
        end
    end
end

// Compare magnitudes
always @* begin
    packet1_greater_than_packet2 = (&packet1 > &packet2);
end

// Decompose packet 1 and recover original data item if magnitude of packet 1 is greater than packet 2
always @(posedge clk) begin
    if (packet1_greater_than_packet2 && ~fifo1_empty) begin
        decomposed_data_item = packet1[15:0] ^ packet1[19:16];
        recovered_data_item <= decomposed_data_item;
    end
end

// FIFO 1 Read and Write Logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo1_ptr_wr <= 0;
        fifo1_ptr_rd <= 0;
    end else begin
        if (fifo1_write_en && ~fifo1_ready) begin
            fifo1_mem[fifo1_ptr_wr] <= fifo1_data_in;
            fifo1_ptr_wr <= fifo1_ptr_wr + 1;
        end
        if (fifo1_read_en && ~fifo1_empty) begin
            fifo1_ptr_rd <= fifo1_ptr_rd + 1;
        end
    end
end

// FIFO 2 Read and Write Logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo2_ptr_wr <= 0;
        fifo2_ptr_rd <= 0;
    end else begin
        if (fifo2_write_en && ~fifo2_ready) begin
            fifo2_mem[fifo2_ptr_wr] <= fifo2_data_in;
            fifo2_ptr_wr <= fifo2_ptr_wr + 1;
        end
        if (fifo2_read_en && ~fifo2_empty) begin
            fifo2_ptr_rd <= fifo2_ptr_rd + 1;
        end
    end
end

// FIFO 1 Full and Empty Logic
assign fifo1_ready = (fifo1_ptr_wr - fifo1_ptr_rd < FIFO1_DEPTH);
assign fifo1_empty = (fifo1_ptr_wr == fifo1_ptr_rd);

// FIFO 2 Full and Empty Logic
assign fifo2_ready = (fifo2_ptr_wr - fifo2_ptr_rd < FIFO2_DEPTH);
assign fifo2_empty = (fifo2_ptr_wr == fifo2_ptr_rd);

// Assign the packet to the output
assign fifo1_data_out = (fifo1_ready) ? packet1 : 20'h00000; // Output packet from FIFO 1 if ready
assign fifo2_data_out = (fifo2_ready) ? packet2 : 20'h00000; // Output packet from FIFO 2 if ready

endmodule

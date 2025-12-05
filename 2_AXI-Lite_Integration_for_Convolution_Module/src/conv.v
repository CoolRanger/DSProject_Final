module conv #(
    parameter IMG_WIDTH  = 256,
    parameter IMG_HEIGHT = 256
)(
    input clk,
    input rst_n,

    input  start,
    output done,

    // BRAM0 Ports
    output reg [31:0] bram0_addr,
    input      [31:0] bram0_dout,
    output            bram0_en,

    // BRAM1 Ports
    output reg [31:0] bram1_addr,
    output reg [31:0] bram1_din,
    output reg [3:0]  bram1_we
);

// state
localparam IDLE          = 3'd0;
localparam READ_9_PIXELS = 3'd1;
localparam READ_3_PIXELS = 3'd2;
localparam MULTIPLY      = 3'd3;
localparam ACCUMULATE    = 3'd4;
localparam WRITE         = 3'd5;
localparam DONE          = 3'd6;

integer i;

reg [2:0] state, next_state;

reg [7:0] kernel1 [8:0];             // vertical Sobel kernel
reg [7:0] kernel2 [8:0];             // horizontal Sobel kernel

reg [$clog2(IMG_WIDTH)-1:0]  x;      // current x position
reg [$clog2(IMG_HEIGHT)-1:0] y;      // current y position
reg [$clog2(IMG_WIDTH)-1:0]  next_x; // next x position
reg [$clog2(IMG_HEIGHT)-1:0] next_y; // next y position

reg [3:0] counter;                   // counter to control reading pixels

reg [7:0] buffer [0:8];              // pixel buffer

reg signed [15:0] mul1 [8:0];        // MUL result of vertical Sobel filter
reg signed [15:0] mul2 [8:0];        // MUL result of horizontal Sobel filter
reg signed [15:0] acc1;              // accumulated result of vertical Sobel filter
reg signed [15:0] acc2;              // accumulated result of horizontal Sobel filter

reg [15:0] mag;                      // magnitude
reg [7:0]  mag_clipped;              // clipped magnitude

////////////////////////////////////////////////////////////////////////////////
// Sobel Kernel Initialization
////////////////////////////////////////////////////////////////////////////////

/*
 * Initialize Sobel kernels
 *
 * The vertical Sobel kernel:
 *  [  1  0 -1 ]
 *  [  2  0 -2 ]
 *  [  1  0 -1 ]
 *
 * The horizontal Sobel kernel:
 *  [  1  2  1 ]
 *  [  0  0  0 ]
 *  [ -1 -2 -1 ]
 */

 // Todo : Fill in the Sobel kernel values
initial begin
    kernel1[0] =  ???;
    kernel1[1] =  ???;
    kernel1[2] =  ???;
    kernel1[3] =  ???;
    kernel1[4] =  ???;
    kernel1[5] =  ???;
    kernel1[6] =  ???;
    kernel1[7] =  ???;
    kernel1[8] =  ???;

    kernel2[0] =  ???;
    kernel2[1] =  ???;
    kernel2[2] =  ???;
    kernel2[3] =  ???;
    kernel2[4] =  ???;
    kernel2[5] =  ???;
    kernel2[6] =  ???;
    kernel2[7] =  ???;
    kernel2[8] =  ???;
end

////////////////////////////////////////////////////////////////////////////////
// FSM
////////////////////////////////////////////////////////////////////////////////

// Todo : Complete the missing state transitions
always @(*) begin
    case (state)
        IDLE:
            next_state = start ? READ_9_PIXELS : IDLE;

        READ_9_PIXELS:
            next_state = ???;

        READ_3_PIXELS:
            next_state = ???;

        MULTIPLY:
            next_state = ACCUMULATE;

        ACCUMULATE:
            next_state = WRITE;

        WRITE:
            if (??? && ???)
                next_state = DONE;
            else
                next_state = (next_x == 0) ? READ_9_PIXELS : READ_3_PIXELS;

        DONE:
            next_state = start ? DONE : IDLE;
        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

////////////////////////////////////////////////////////////////////////////////
// Control
////////////////////////////////////////////////////////////////////////////////

// next_x, next_y
always @(*) begin
    next_x = (x == IMG_WIDTH - 1) ? 0 : x + 1;
    next_y = (x == IMG_WIDTH - 1) ? y + 1 : y;
end

// x, y
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x <= 0;
        y <= 0;
    end else if (state == WRITE) begin
        x <= next_x;
        y <= next_y;
    end
end

// bram0_addr
/*
 * Generate BRAM0 addresses to read pixel values based on the counter.
 *
 * The bram0_addr is updated on this clock edge and passed into BRAM on the next
 * cycle, and BRAM has a read latency of 1 cycle. Therefore, we can get the pixel
 * values after 2 cycles.
 *
 */

// Todo : Complete the missing BRAM0 address assignments.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bram0_addr <= 32'd0;
    end else if (state == READ_9_PIXELS) begin
        case (counter)
            4'd0: bram0_addr <= ???;
            4'd1: bram0_addr <= ???;
            4'd2: bram0_addr <= ???;
            4'd3: bram0_addr <= ???;
            4'd4: bram0_addr <= ???;
            4'd5: bram0_addr <= ???;
            4'd6: bram0_addr <= ???;
            4'd7: bram0_addr <= ???;
            4'd8: bram0_addr <= ???;
        endcase
    end else if (state == READ_3_PIXELS) begin
        case (counter)
            4'd0: bram0_addr <= ???;
            4'd1: bram0_addr <= ???;
            4'd2: bram0_addr <= ???;
        endcase
    end else begin
        bram0_addr <= 32'd0;
    end
end

// counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'd0;
    end else if (state == READ_9_PIXELS || state == READ_3_PIXELS) begin
        counter <= counter + 4'd1;
    end else begin
        counter <= 4'd0;
    end
end

////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////

// buffer
/*
 * Buffer the 3x3 pixel values, and handle border conditions by zero-padding.
 *
 * The buffer layout is as follows:
 * [0] [1] [2]
 * [3] [4] [5]
 * [6] [7] [8]
 * 
 */

// Todo : Complete the missing assignments for buffer[1] to buffer[7].
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 9; i = i + 1) begin
            buffer[i] <= 8'd0;
        end
    end else if (state == READ_9_PIXELS) begin
        case (counter)
            4'd2:  buffer[0] <= (x == 0 || y == 0)                          ? 8'd0 : bram0_dout[7:0];
            4'd3:  buffer[1] <= ???;
            4'd4:  buffer[2] <= ???;
            4'd5:  buffer[3] <= ???;
            4'd6:  buffer[4] <= ???;
            4'd7:  buffer[5] <= ???;
            4'd8:  buffer[6] <= ???;
            4'd9:  buffer[7] <= ???;
            4'd10: buffer[8] <= (x == IMG_WIDTH - 1 || y == IMG_HEIGHT - 1) ? 8'd0 : bram0_dout[7:0];
        endcase
    end else if (state == READ_3_PIXELS) begin
        case (counter)
            4'd2: buffer[?] <= (x == IMG_WIDTH - 1 || y == 0)              ? 8'd0 : bram0_dout[7:0];
            4'd3: buffer[?] <= (x == IMG_WIDTH - 1)                        ? 8'd0 : bram0_dout[7:0];
            4'd4: buffer[?] <= (x == IMG_WIDTH - 1 || y == IMG_HEIGHT - 1) ? 8'd0 : bram0_dout[7:0];
        endcase
    end else if (state == WRITE) begin
        buffer[0] <= buffer[1];
        buffer[1] <= buffer[2];
        buffer[3] <= buffer[4];
        buffer[4] <= buffer[5];
        buffer[6] <= buffer[7];
        buffer[7] <= buffer[8];
    end
end

// mul1, mul2
always @(posedge clk) begin
    for (i = 0; i < 9; i = i + 1) begin
        mul1[i] <= $signed({ 1'b0, buffer[i] }) * $signed(kernel1[i]);
        mul2[i] <= $signed({ 1'b0, buffer[i] }) * $signed(kernel2[i]);
    end
end


// acc1, acc2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        acc1 <= 16'd0;
        acc2 <= 16'd0;
    end else if (state == ???) begin
        acc1 <= mul1[0] + mul1[1] + mul1[2]
                + mul1[3] + mul1[4] + mul1[5]
                + mul1[6] + mul1[7] + mul1[8];

        acc2 <= mul2[0] + mul2[1] + mul2[2]
                + mul2[3] + mul2[4] + mul2[5]
                + mul2[6] + mul2[7] + mul2[8];
    end else begin
        acc1 <= 16'd0;
        acc2 <= 16'd0;
    end
end

// Magnitude Calculation
always @(*) begin
    // abs(acc1) + abs(acc2)
    mag = ((acc1 < 0) ? -acc1 : acc1) + ((acc2 < 0) ? -acc2 : acc2);

    // Clip to 8 bits
    mag_clipped = (mag > 16'd255) ? 8'd255 : mag[7:0];
end

////////////////////////////////////////////////////////////////////////////////
// Output Logic
////////////////////////////////////////////////////////////////////////////////

// Todo : Complete the missing BRAM1 write enable and address assignments.
// bram1_we
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bram1_we <= 4'd0;
    end else if (state == ???) begin
        bram1_we <= 4'b1111;
    end else begin
        bram1_we <= 4'd0;
    end
end

// bram1_addr
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bram1_addr <= 32'd0;
    end else if (state == WRITE) begin
        bram1_addr <= ???;
        end
    end

// bram1_din
always  @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bram1_din <= 32'd0;
    end else if (state == WRITE) begin
        bram1_din <= { 24'd0, mag_clipped };
    end else begin
        bram1_din <= 32'd0;
    end
end

// Todo : Complete the missing bram0_en and done assignments.
// bram0_en, done
assign bram0_en = (state == ??? || state == ???) ? 1'b1 : 1'b0;
assign done = (state == DONE) ? 1'b1 : 1'b0;

endmodule

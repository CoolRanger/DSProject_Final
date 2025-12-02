# 1. IP Functional Description

In this Final Project, students are required to design and implement a custom hardware IP capable of performing `Sobel convolution` and integrate it into the complete system architecture. The provided example includes an input stimulus file input.hex, a reference output file golden.hex, and a testbench to verify the correctness of the designed IP.

The input `grayscale image` (with a resolution of 256 × 256 pixels) is stored in `Bram0`. The IP must read the original pixel data from `Bram0`, perform the Sobel convolution, and write the processed results to `Bram1`.

| Original Image | Edge-detection |
|----------------|------------|
| ![Original](./pic/original.png) | ![Edge-detection](./pic/edge-detection.png) |


# 2. Sobel Convolution Algorithm

The main intention of convolution is to extract information from the local neighborhood of each pixel. Instead of looking at a pixel by itself, convolution examines the surrounding region and computes a weighted combination. By choosing different kernels, convolution can emphasize certain features—such as edges, textures, or smooth regions—while suppressing others.

The Sobel operator is a gradient-based edge detection algorithm widely used in image processing. It computes the rate of intensity change at each pixel by applying two 3×3 convolution kernels: Gx, which detects horizontal edges, and Gy, which detects vertical edges.

### 1. Sobel Kernels
$$
G_x =
\begin{bmatrix}
-1 & 0 & +1 \\
-2 & 0 & +2 \\
-1 & 0 & +1
\end{bmatrix}
$$

$$
G_y =
\begin{bmatrix}
+1 & +2 & +1 \\
0  &  0 &  0 \\
-1 & -2 & -1
\end{bmatrix}
$$

### 2. Gradient Computation 
For each pixel, the 3×3 window centered on that pixel is multiplied with Gx and Gy:

$$G_xvalue = Σ (window[i][j] * Gx[i][j]) $$
$$G_yvalue = Σ (window[i][j] * Gy[i][j])$$

These two results represent the horizontal and vertical gradients of the image.

### 3. Edge Magnitude

A simplified hardware-friendly version

$$Edge ≈ |G_xvalue| + |G_yvalue|$$

### 4. Purpose

Pixels with large gradient magnitudes correspond to significant intensity changes—i.e., edges in the image. Sobel convolution therefore highlights boundaries and structural features while providing a slight smoothing effect due to its kernel design.

---


# 3. IP Interface Specification


### Input/Output Signals

| Signal Name | I/O | Width | Simple Description |
|-------------|-----|-------|--------------------|
| clk         | I   | 1     | System clock signal. The IP operates synchronously on the rising edge of the clock. |
| rst_n       | I   | 1     | Active-low system reset. Resets the internal state machine and registers to their initial values. |
| start       | I   | 1     | Control signal that initiates the Sobel convolution operation. When asserted, the IP begins reading input data and performing computations. |
| done        | O   | 1     | Indicates the completion of the Sobel convolution. Asserted when the entire image has been processed and results have been written to BRAM1. |
| bram0_addr  | O   | 32    | Address signal for BRAM0, specifying the location of the input grayscale image data to be read. |
| bram0_dout  | I   | 32    | Data bus from BRAM0 (32-bit word), carrying the input grayscale pixel data. |
| bram0_en    | O   | 1     | Enable signal for BRAM0. When high, BRAM0 is allowed to perform a read operation. |
| bram1_addr  | O   | 32    | Address signal for BRAM1, specifying the memory location where the Sobel output result will be stored. |
| bram1_din   | O   | 32    | Data bus to BRAM1, carrying the processed Sobel convolution output results. |
| bram1_we    | O   | 4     | Write-enable signal for BRAM1. Each bit corresponds to one byte lane; a high bit enables writing to that byte. |

> [!NOTE]
> Although the BRAM interfaces (bram0_dout and bram1_din) are 32-bit wide, only 8 bits of each word represent the actual grayscale pixel value used in the Sobel convolution. The remaining bits are unused in this project and are simply carried along due to the fixed BRAM word width. Therefore, each 32-bit word contains one valid 8-bit grayscale pixel.

# 4. Functional and Behavioral Description

### Sobel convolution

Sobel convolution is a widely used `edge-detection` technique in image processing. It applies `two 3×3 kernels—one` for detecting horizontal intensity changes (Gx) and one for vertical changes (Gy)—to estimate the gradient at each pixel. By highlighting areas where brightness changes sharply, Sobel convolution identifies the edges and structural outlines of an image. The final edge magnitude is typically computed by combining the horizontal and vertical gradients, producing a result that emphasizes boundaries and key visual features.

---

### Padding

Sobel convolution requires a 3×3 window for every output pixel. However, pixels located at the borders of the image do not have enough neighboring pixels to form a complete 3×3 region. To ensure that convolution can still be performed at the edges, padding is applied. Padding artificially extends the image boundary so that every pixel, including those on the edges, has a full neighborhood for computation.

In this project, `zero padding` is used, meaning the added boundary pixels are set to zero. Zero padding is simple to `implement in hardware`, avoids additional memory overhead, and ensures deterministic behavior without relying on values outside the valid image region. Although it may slightly darken the output edges, it provides a consistent and straightforward way to support Sobel convolution across the entire image.

> [!WARNING]
> The padding functionality in the provided template is not fully implemented and needs to be completed by the students.

---

### Controller

- Operation Start: After the reset initialization is complete, the IP can request the grayscale image data from Bram0.

- Core Logic: The FSM is responsible for driving the overall Sobel convolution computation.

- Result Output: The convolution result will be output and written back to Bram1 in the WRITE state.

- Reset Condition: The FSM is forced back to the IDLE state when the asynchronous active-low reset signal (rst_n) is low.

> [!TIP]
> Sobel Operator Requirement: The Sobel operator requires two separate convolution kernels because it measures image intensity changes in two orthogonal directions: horizontal and vertical.

---

| State Name | Function Description |
| :--- | :--- |
| **IDLE** | **Wait for Start:** The circuit waits for the `start` signal to be high. |
| **READ_9_PIXELS** | **Read 9 Pixels:** Used at the start of a new image row. It reads 9 pixels to form the initial $3 \times 3$ convolution window. |
| **READ_3_PIXELS** | **Read 3 Pixels:** Used for subsequent pixel positions within the same row (when the window slides right). It reads only 3 new pixels to update the $3 \times 3$ window. |
| **MULTIPLY** | **Multiplication:** Completes the multiplication of the $3 \times 3$ kernel coefficients with the corresponding pixel values. |
| **ACCUMULATE** | **Accumulation:** Completes the summation of the multiplication results. |
| **WRITE** | **Write Result:** Outputs the convolution result and writes it back to `Bram1`. |
| **DONE** | **Operation Complete:** Indicates that the processing of the entire image is finished. |

> [!TIP]
> Design Efficiency Note: The separation into READ_9_PIXELS (for new rows) and READ_3_PIXELS (for shifting right) is designed to reduce redundant memory access by only reading the necessary 3 new pixels for the sliding window operation.

---

### BRAM Read/Write Operations

1. Read Operation (Read Request):
To perform a read operation, the signal `R_req` must be asserted to `1'b1` to indicate a read request. The target address should be placed on the addr bus. The requested data will appear on R_data one clock cycle later.

2. Write Operation (Write Request):
To perform a write operation, `R_req` should still be set to 1'b1, while `W_req` must be set to 4'b1111, indicating that all byte lanes are enabled for writing. On the rising edge of the clock, the data on W_data will be written into the memory location specified by addr.

![Bram](./pic/Bram.png)
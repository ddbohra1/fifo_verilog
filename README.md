LAb exam question of IIT jodhpur |
Course : HW SW CO DESIGN |

Question asked about to design the system such that there are two FIFOs with different depths. Input stream of each FIFO is of size 8 bits.
check the ready signal of both FIFO. Offloading the value from the FIFO which ready signal appears first.
Data will be of 8 bits and make square of this 8 bit data.
After squaring, we need to send the data to parity generator which outputs a packet of 20 bit. (appending of zeros should be at last)
Compare magnitude of successive packets. If magnitude of packet 1 is greater then packet 2 then decompose packet 1 otherwise packet2.
original data item should be recovered as output.

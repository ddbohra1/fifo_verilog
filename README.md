LAb exam question of IIT jodhpur <br/>
Course : HW SW CO DESIGN<br/>

Question asked about to design the system such that there are two FIFOs with different depths. Input stream of each FIFO is of size 8 bits.<br/>
<br/>check the ready signal of both FIFO. Offloading the value from the FIFO whose "ready" signal appears first.
<br/>Data will be of 8 bits and make square of this 8 bit data.
<br/ > After squaring, we need to send the data to parity generator which outputs a packet of 20 bit. (appending of zeros should be at last)
Compare magnitude of successive packets. If magnitude of packet 1 is greater then packet 2 then decompose packet 1 otherwise packet2.
original data item should be recovered as output.

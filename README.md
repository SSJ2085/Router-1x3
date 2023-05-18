# Router-3X1

A router is a networking device that forwards data packets between computer 
networks. A router is connected to two or more data lines from different networks 
(as opposed to a network switch, which connects data lines from one single 
network). When a data packet comes in on one of the lines, the router reads the 
address information in the packet to determine its ultimate destination. Then, 
using information in its routing table or routing policy, it directs the packet to 
the next network on its journey. This creates an overlay internetwork. Routers 
perform the "traffic directing" functions on the Internet. A data packet is typically 
forwarded from one router to another through the networks that constitute the 
internetwork until it reaches its destination node.
Routing is the process of moving a packet of data from source to destination and 
enables messages to pass from one computer to another and eventually reach the 
target machine. A router is a networking device that forwards data packets 
between computer networks. It is connected to two or more data lines from 
different networks (as opposed to a network switch, which connects data lines 
from one single network). This project mainly emphasizes upon the study of 
router device, its top-level architecture, and how various sub-modules of router 
i.e., Register, FIFO, FSM, and Synchronizer are synthesized, and simulated and 
finally connected to its top module

Modules in Router Design
•	FIFO- First-in First-out
There are 3 FIFO used in the Router design.
The module includes. 
RTL design. 
Testbench
Simulation 
Synthesis

•	FSM controller – Finite State Machine
There are 3 FIFO used in the Router design.
The module includes. 
RTL design. 
Testbench
Simulation 
Synthesis

•	Register Block 
This module has 4 internal registers namely. 
hold_header_byte,
fifo_full_state_byte,
internal_parity,
packet_parity
The module includes. 
RTL design. 
Testbench
Simulation 
Synthesis

•	Synchronizer Block
This block synchronize the clock signals of all the module.
The module includes. 
RTL design. 
Testbench
Simulation 
Synthesis

•	Top Module
This is the interconnected circuit of all the Blocking creating a Router.
This block synchronizes the clock signals of all the module.
The module includes. 
RTL design. 
Testbench
Simulation 
Synthesis

top module
![image](https://github.com/SSJ2085/Router-1x3/assets/67045170/10e6e750-1b0c-4f16-b95a-16b969bc6df8)


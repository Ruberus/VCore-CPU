`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 17:48:55
// Design Name: 
// Module Name: tb_VCore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_VCore();

    // 1. Declare signals to connect to the Unit Under Test (UUT)
    // Inputs are declared as 'reg' because we drive them in procedural blocks
    reg clk;
    reg reset;
    
    // Outputs are declared as 'wire'
    wire [3:0] led;

    // 2. Instantiate the VCore module
    VCore uut (
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    // 3. Clock Generation
    // This creates a 100 MHz clock (10ns period: 5ns high, 5ns low)
    // This is the critical piece that prevents zero-delay loops!
    always #5 clk = ~clk;

    // 4. Stimulus Block
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1; // Assuming active-high reset

        // Wait 100 ns for global reset to finish
        #100;
        
        // De-assert reset to let the CPU start running
        reset = 0;

        // Let the simulation run for enough clock cycles to fetch, decode, and execute
        // For your test addition instruction, it will take a few cycles.
        #600; 

        // Stop the simulation cleanly
        $display("Simulation complete.");
        $finish;
    end

endmodule

`timescale 10ns / 1ps



module Washing_Machine_tb();
    // Testbench signals
    reg clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout;
    wire door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash;

    // Instantiate the washing machine module
    Washing_Machine uut (
        .clk(clk), .reset(reset), .door_close(door_close), .start(start), .filled(filled),
        .detergent_added(detergent_added), .cycle_timeout(cycle_timeout), .drained(drained),
        .spin_timeout(spin_timeout), .door_lock(door_lock), .motor_on(motor_on), 
        .fill_valve_on(fill_valve_on), .drain_valve_on(drain_valve_on), .done(done), 
        .soap_wash(soap_wash), .water_wash(water_wash)
    );

    // Generate the clock signal
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Initial block to apply test vectors
    initial 
      begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;
        door_close = 0;
        filled = 0;
        drained = 0;
        detergent_added = 0;
        cycle_timeout = 0;
        spin_timeout = 0;

        // Apply test vectors
        #5 reset = 0; // Release reset
        #5 start = 1; door_close = 1; // Start the machine with the door closed
        #10 filled = 1; // Water is filled
        #10 detergent_added = 1; // Detergent is added
        #10 cycle_timeout = 1; // Washing cycle is complete
        #10 drained = 1; // Water is drained
        #10 spin_timeout = 1; // Spinning cycle is complete
    end

endmodule

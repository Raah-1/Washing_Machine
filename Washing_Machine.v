`timescale 10ns / 1ps



module Washing_Machine(
    input clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout,
    output reg door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash
);

    // State encoding
    parameter CHECK_DOOR    = 3'b000;
    parameter FILL_WATER    = 3'b001;
    parameter ADD_DETERGENT = 3'b010;
    parameter CYCLE         = 3'b011;
    parameter DRAIN_WATER   = 3'b100;
    parameter SPIN          = 3'b101;

    // State variables
    reg [2:0] current_state, next_state;

    // Combinational logic for state transition and output control
    always @(*) begin
     
        case (current_state)
            CHECK_DOOR:
           begin
                if (start==1 && door_close==1) 
                begin
                    next_state = FILL_WATER;
                    door_lock = 1;
                    motor_on = 0;
				    fill_valve_on = 0;
				    drain_valve_on = 0;
				    soap_wash = 0;
			    	water_wash = 0;
			    	done = 0;
                end 
                else
                 begin
                    next_state = current_state;
                    door_lock = 0;
                    motor_on = 0;
				    fill_valve_on = 0;
				    drain_valve_on = 0;
			    	soap_wash = 0;
				    water_wash = 0;
				    done = 0;
                end
            end

            FILL_WATER: begin
                if (filled==1) 
                begin
                    if (soap_wash==0) 
                       begin
                        next_state = ADD_DETERGENT;
                        door_lock = 1;
                        motor_on = 0;
					    fill_valve_on = 0;
					    drain_valve_on = 0;
					    soap_wash = 1;
					    water_wash = 0;
					    done = 0;
                       end
                    else
                     begin
                        next_state = CYCLE;
                        door_lock = 1;
                        motor_on = 0;
                        fill_valve_on = 0;
                        drain_valve_on = 0;
                        soap_wash = 1;
                        water_wash = 1;
                        done = 0;
                    end
                end 
                else 
                  begin
                    next_state = current_state;
                    door_lock = 1;
                    motor_on = 0;
                    fill_valve_on = 1;
			    	drain_valve_on = 0;
			    	done=0;
                  end
               end

            ADD_DETERGENT: begin
                if (detergent_added==1) 
                begin
                    next_state = CYCLE;
                    door_lock = 1;
                   	motor_on = 0;
				   fill_valve_on = 0;
				   drain_valve_on = 0;
				   soap_wash = 1;
				   done = 0;
                end 
                else 
                 begin
                    next_state = current_state;
                    motor_on = 0;
			    	fill_valve_on = 0;
				   drain_valve_on = 0;
				   door_lock = 1;
				   soap_wash = 1;
				   water_wash = 0;
				   done = 0;
                 end
            end

            CYCLE: begin
                if (cycle_timeout==1) 
                begin
                    next_state = DRAIN_WATER;
                   motor_on = 0;
				   fill_valve_on = 0;
				   drain_valve_on = 0;
				   door_lock = 1;
				   //soap_wash = 1;
				   done = 0;
               end 
                else
                 begin
                    next_state = current_state;
                   motor_on = 1;
				   fill_valve_on = 0;
				   drain_valve_on = 0;
				   door_lock = 1;
				  // soap_wash = 1;
				   done = 0;
                end
            end

            DRAIN_WATER: begin
                if (drained==1) 
                begin
                    if (water_wash==0)
                     begin
                        next_state = FILL_WATER;
                        motor_on = 0;
					    fill_valve_on = 0;
					    drain_valve_on = 0;
					    door_lock = 1;
					    soap_wash = 1;
					    //water_wash = 1;
					    done = 0;
					 end
                    else
                     begin
                        next_state = SPIN;
                        motor_on = 0;
					   fill_valve_on = 0;
					   drain_valve_on = 0;
					   door_lock = 1;
					   soap_wash = 1;
					   water_wash = 1;
				       done = 0;
                    end
                end
                 else
                  begin
                    next_state = current_state;
                    motor_on = 0;
				    fill_valve_on = 0;
				    drain_valve_on = 1;
				    door_lock = 1;
				    soap_wash = 1;
				    //water_wash = 1;
				    done = 0;
                end
            end

            SPIN: begin
                if (spin_timeout==1)
                 begin
                    next_state = CHECK_DOOR;
                    motor_on = 0;
				    fill_valve_on = 0;
				    drain_valve_on = 0;
				    door_lock = 1;
				    soap_wash = 1;
				    water_wash = 1;
				    done = 1;
                    done = 1;
                end 
                else 
                 begin
                    next_state = current_state;
                   	motor_on = 0;
				    fill_valve_on = 0;
				    drain_valve_on = 1;
				    door_lock = 1;
				    soap_wash = 1;
				    water_wash = 1;
				    done = 0;
                 end
            end

            default: next_state = CHECK_DOOR;
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) 
          begin
            current_state <= CHECK_DOOR;
        end 
        else
         begin
            current_state <= next_state;
        end
    end
endmodule



module main_module (
            input clk,
            input resetn,
            input enablen,
            input open,
            input shut,
            input[4:0] btn_outer,
            input[4:0] btn_inner,
            output[4:0] story_indicator 
    );

    // Register or wire or parameter
    wire timerin;
    wire timerout;
    reg[2:0] dest;
    wire[2:0] car_location;
    

    car_indicator car(
        .clk(clk),
        .resetn(resetn), 
        .enable(enable), 
        .timerin(start),
        .dest(dest),
        .open(open),
        .shut(shut),
        .timerrst(timerrst),
        .location(car_location) 
        );

    counter_1s timer(
        .clk(clk), 
        .resetn(start), 
        .enable(enable), 
        .carryOut(timerin), 
        .countVal(            )
        );
    
    // // Module Instantiation
    // pushbutton btn_car1      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_car2      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_car3      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_car4      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_car5      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    
    // pushbutton btn_out1      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_out2      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_out3      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_out4      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    // pushbutton btn_out5      (.clk(clk), .resetn(resetn), .pushn(enablen), .push(enable));
    
endmodule

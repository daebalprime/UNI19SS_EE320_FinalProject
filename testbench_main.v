

// // Define initial state
// initial begin

//     counter_1s timer(
//         .clk(clk), 
//         .resetn(timerout), 
//         .enable(enable), 
//         .carryOut(timerin), 
//         .countVal(decimal_point)
//         );



// endmodule 

`timescale 1ns / 100ps
`define half_clock 1

module testbench;

    reg  clk;
    reg  resetn;
    reg  enable;
    wire [3:0] decimal_point;
    wire onesecsig;
    wire[2:0] dest;
    wire[2:0] car_location;
    wire[1:0] state;
    wire[2:0] doorcnt;
    wire[1:0] movecnt;
    reg open;
    wire timerin;
    wire timerrst;

    reg[4:0] btncar;
    reg[4:0] btnout;
    wire[4:0] btnidccar;
    wire[4:0] btnidcout;
    
// Testbench 작성시에는 output을 wire로 받고, input을 reg로 넣어야함.




// Clock Generation
initial begin
    clk = 0;
    forever begin
        #(`half_clock) clk = ~clk;
        end
end

// Define initial state
initial begin
    open <= 0;
    resetn <= 1'b0;
    enable <= 1'b1;
    #(200*`half_clock);
    open <= 1;
    resetn <= 1'b1;
    #(200*`half_clock);
    #(200*`half_clock);
    enable <= 1'b1;
    #(2000*`half_clock);
    #(400*`half_clock);
    enable <= 1'b1;
    #(200*`half_clock);
    enable <= 1'b0;
    enable <= 1'b0;
    enable <= 1'b0;
    enable <= 1'b0;
    #(200*`half_clock);
    enable <= 1'b1;
    
    #(2000*`half_clock);
    open <= 0;
    #(1000*`half_clock);
    open <= 1;
    enable <= 1'b1;
    #(200*`half_clock);

    #(20000*`half_clock);
    $stop;
end

    car_indicator car(
        .clk(clk),
        .resetn(resetn), 
        .enable(enable), 
        .timerin(onesecsig),
        .dest(dest),
        .open(open),
        .shut(shut),
        .timerrst(timerrst),
        .location(car_location),
        .state(state),//debugging
        .doorcnt(doorcnt),
        .movecnt(movecnt)
        );

    counter_1s uut(
        .clk(clk),
        .resetn(timer_out),
        .enable(enable),
        .carryOut(onesecsig),
        .countVal(decimal_point)
    );
    assign timer_out = (!timerrst)&&(resetn);

dest_setter mcds(
    .clk(clk),
    .resetn(resetn), 
    .enable(enable), 
    .btncar(btncar),
    .btnout(btncar),
    .state(state),
    .location(car_location),
    .dest(dest),
    .btnidccar(btnidccar),
    .btnidcout(btnidcout)
);
endmodule 

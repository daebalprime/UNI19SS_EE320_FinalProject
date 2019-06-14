
module main_module (
            input clk,
            input resetn,
            input open,
            input shut,
            input enable,
            input[4:0] btncar,
            input[4:0] btnout,
            output[2:0] car_location,
            output[2:0] dest,
            output[2:0] state,
            output[4:0] btnidccar,
            output[4:0] btnidcout,
            output[2:0] doorcnt,
            output[1:0] movecnt
    );
    // Register or wire or parameter
    assign open__ = (btncar[car_location-1]&&btnout[car_location-1]&&open);
    
    
    // 엘리베이터 정지시, 해당층의 버튼 or 열림 버튼으로 문 열기
    // ex 엘리베이터가 3층에 서있을 때, 3층 버튼을 누른다면 open으로 들어감)
    car_indicator car(
        .clk(clk),
        .resetn(resetn), 
        .enable(enable), 
        .timerin(incr_second),
        .dest(dest),
        .open(open__),
        .shut(shut),
        .timerrst(timerrst),
        .location(car_location),
        .state(state),
        .doorcnt(doorcnt), // LED1, LED2 on board
        .movecnt(movecnt), // LED3, LED4 on board
        .btnidccar(btnidccar),
        .btnidcout(btnidcout)
        );

    counter_1s uut(
        .clk(clk),
        .resetn(resetn),
        .enable(enable),
        .carryOut(incr_second),
        .countVal(decimal_point)
    );

    dest_setter mcds(
        .clk(clk),
        .resetn(resetn), 
        .enable(enable), 
        .btncar(btncar),
        .btnout(btnout),
        .state(state),
        .location(car_location),
        .dest(dest),
        .btnidccar(btnidccar),
        .btnidcout(btnidcout)
    );

endmodule

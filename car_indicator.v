module car_indicator (
    input clk, resetn, enable,
    input timerin,
    input [2:0] dest,
    input open,
    input shut,
    input [4:0] btnidccar,
    input [4:0] btnidcout,
    output timerrst, 
    output reg [2:0] location,
    output reg [1:0] state,
    output reg [2:0] doorcnt,
    output reg [1:0] movecnt
);

    // state: 0 for open, 1 for stop, 2 for upward, 3 for downward

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            location <= 1;
            state <= 1;
            doorcnt<= 5;
            movecnt<=0;
        end
        else if (state == 0) begin
            if(doorcnt == 0 || !shut)begin // 2초경과후 문 닫기 or 닫힘버튼
                state <= 1;
                doorcnt <=5; // 다음 문 열릴떄 카운트 미리 초기화
            end
                //Todo : when we close the door, recalculate dest.
            else if (!open) begin // 열려있는 상태에서 open 버튼 누르기
                if (doorcnt < 2)
                    doorcnt <= 2;
            end
            else if(doorcnt != 0) begin// door is still opening... open 버튼 안눌린 상태
                if(timerin) // 1초 경과시 1초씩 차감
                    doorcnt <= doorcnt - 1;
                location <= location;
            end
        end

        else if (state == 1) begin
            if (location == dest) begin// stopped with no request.
                location <= location;
                if (!open)
                    state <= 0;
            end
            else begin
                if (location < dest) // upward
                    state <= 2;
                else // downward
                    state <= 3;
                movecnt <= 2; // 2초시작
            end
        end
        
        // 별도 요청이 있는 상태를  location != dest라고 본다.
        else begin // upward or downward
            if (location == dest ||(btnidccar[location-1]||btnidcout[location-1])) begin
                state <= 0;
                doorcnt <= 5;
            end
            else if (movecnt == 0) begin            
                if (state == 2) begin
                    if (location < dest)begin
                        location <= location + 1;
                        movecnt <= 2;
                    end
                    else 
                        state <= 0;
                end
                else begin
                    if (location > dest) begin
                        location <= location - 1;
                        movecnt <= 2;
                    end
                    else 
                        state <= 0;
                end
            end
            else if(timerin)
                movecnt <= movecnt - 1;            
        end
    end
    assign timerrst = !open && (state == 0);
    // timerrst은 timer를 리셋하는 output
    // 엘리베이터가 이동중일 때 open 버튼에 의해 리셋되는 것을 방지
endmodule
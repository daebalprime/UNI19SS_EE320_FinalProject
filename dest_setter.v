module dest_setter (
    input clk, resetn, enable,
    input [4:0] btncar,
    input [4:0] btnout,
    input [1:0] state,
    input [2:0] location,
    output reg [2:0] dest,
    output [4:0] btnidccar,
    output [4:0] btnidcout
);
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            dest <= 1;
        end
        // 정지상태에서의 dest 설
        else if((state==0||state==1)) begin
            if(btnidcout[0] || btnidccar[0])
                dest<=1;
            if(btnidcout[1] || btnidccar[1])
                dest<=2;
            if(btnidcout[2] || btnidccar[2])
                dest<=3;
            if(btnidcout[3] || btnidccar[3])
                dest<=4;
            if(btnidcout[4] || btnidccar[4])
                dest<=5;
        end
        else begin //목적지의 버튼이 도착하기도 전에 꺼진다면 dest 재탐색.
            if (((state == 2) && (btnidcout[dest-1] || btnidccar[dest-1])) || ((state == 3) && !(btnidcout[dest-1] || btnidccar[dest-1])))begin // 목적지보다 고층의 버튼이 눌렸는지 체크
                if (dest<2)begin
                    if(btnidcout[1] || btnidccar[1])
                        dest<=2;
                end
                if (dest<3)begin
                    if(btnidcout[2] || btnidccar[2])
                        dest<=3;
                end
                if (dest<4)begin
                    if(btnidcout[3] || btnidccar[3])
                        dest<=4;
                end
                if (dest<5)begin
                    if(btnidcout[4] || btnidccar[4])
                        dest<=5;
                end
                //for문 사용이 안되어서 지저분하게 작성...
            end
            else if (( (state == 3) && (btnidcout[dest-1] || btnidccar[dest-1])) || ((state == 2) && !(btnidcout[dest-1] || btnidccar[dest-1])))begin
                if (dest>4)begin
                    if(btnidcout[3] || btnidccar[3])
                        dest<=4;
                end
                if (dest>3)begin
                    if(btnidcout[2] || btnidccar[2])
                        dest<=3;
                end
                if (dest>2)begin
                    if(btnidcout[1] || btnidccar[1])
                        dest<=2;
                end
                if (dest>1)begin
                    if(btnidcout[0] || btnidccar[0])
                        dest<=1;
                end
            end
        end
    end
    // when the car arrive that floor, turn off the switches.
    assign btnoff1 = (((location==1)&&(state == 0 || state == 1))||!resetn);
    assign btnoff2 = (((location==2)&&(state == 0 || state == 1))||!resetn);
    assign btnoff3 = (((location==3)&&(state == 0 || state == 1))||!resetn);
    assign btnoff4 = (((location==4)&&(state == 0 || state == 1))||!resetn);
    assign btnoff5 = (((location==5)&&(state == 0 || state == 1))||!resetn);
    
    // button
    pushbutton btn_car1(.clk(clk), .resetn(!btnoff1), .pushn(btncar[0]), .push(btnidccar[0]));
    pushbutton btn_car2(.clk(clk), .resetn(!btnoff2), .pushn(btncar[1]), .push(btnidccar[1]));
    pushbutton btn_car3(.clk(clk), .resetn(!btnoff3), .pushn(btncar[2]), .push(btnidccar[2]));
    pushbutton btn_car4(.clk(clk), .resetn(!btnoff4), .pushn(btncar[3]), .push(btnidccar[3]));
    pushbutton btn_car5(.clk(clk), .resetn(!btnoff5), .pushn(btncar[4]), .push(btnidccar[4]));

    pushbutton btn_out1(.clk(clk), .resetn(!btnoff1), .pushn(btnout[0]), .push(btnidcout[0]));
    pushbutton btn_out2(.clk(clk), .resetn(!btnoff2), .pushn(btnout[1]), .push(btnidcout[1]));
    pushbutton btn_out3(.clk(clk), .resetn(!btnoff3), .pushn(btnout[2]), .push(btnidcout[2]));
    pushbutton btn_out4(.clk(clk), .resetn(!btnoff4), .pushn(btnout[3]), .push(btnidcout[3]));
    pushbutton btn_out5(.clk(clk), .resetn(!btnoff5), .pushn(btnout[4]), .push(btnidcout[4]));
endmodule

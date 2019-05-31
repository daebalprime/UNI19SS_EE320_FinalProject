module dest_setter (
    input clk, resetn, enable,
    input [4:0] btncar,
    input [4:0] btnout,
    input [1:0] state,
    input reg [2:0] location,
    output reg [2:0] dest,
    output reg open1,
    output reg [4:0] btnidccar,
    output reg [4:0] btnidcout,
);
    integer index;
    integer prevdest;

    reg [4:0] btnoff;

    always @(posedge clk) begin
        if (state == 0 || state == 1)begin
            if (btncar[location-1] || btnout[location-1])   
                open1<=0;
            else
                open1<=1;
        end
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            dest <= 1;
        end
        else if (btnout[dest-1] || btncar[dest-1])begin //목적지 버튼이 켜져있을 때
            if (state == 2)begin // 목적지보다 고층의 버튼이 눌렸는지 체크
                for(index = dest+1; index < 6; index = index + 1) begin
                    if (btncar[index-1] || btnout[index-1])
                        dest <= index;
                end
            end
            else if (state == 3)begin
                for(index = dest-1; index > 0; index = index - 1) begin
                    if (btncar[index-1] || btnout[index-1])
                        dest <= index;
                end
            end
        end
        else begin // 목적지 버튼이 꺼졌을 때
            prevdest<= dest;
            if (state==2)begin //올라갈 때
                for(index = dest-1; index > location; index = index-1) begin
                    if (btncar[index-1] || btnout[index-1])
                        dest <= index;
                end
                if (dest == prevdest)begin
                    dest <= location;
                    for(index = 1; index < location; index = index+1) begin
                        if (btncar[index-1] || btnout[index-1])
                            dest <= index;
                    end
                end
            end
            else if (state==3)begin // 내려갈 때
                for(index = dest+1; index < location; index = index+1) begin
                    if (btncar[index-1] || btnout[index-1])
                        dest <= index;
                end
                if (dest == prevdest)begin
                    dest <= location;
                    for(index = 5; index > location; index = index-1) begin
                        if (btncar[index-1] || btnout[index-1])
                            dest <= index;
                    end
                end
            end
        end
    end
    assign btnoff1 = (location==1)&&(state == 0 || state == 1);
    assign btnoff2 = (location==2)&&(state == 0 || state == 1);
    assign btnoff3 = (location==3)&&(state == 0 || state == 1);
    assign btnoff4 = (location==4)&&(state == 0 || state == 1);
    assign btnoff5 = (location==5)&&(state == 0 || state == 1);
    pushbutton btn_car1(.clk(clk), .resetn(!btnoff1), .pushn(btncar[0]), .push(btnidccar[0]));
    pushbutton btn_car2(.clk(clk), .resetn(!btnoff2), .pushn(btncar[1]), .push(btnidccar[1]));
    pushbutton btn_car3(.clk(clk), .resetn(!btnoff3), .pushn(btncar[2]), .push(btnidccar[2]));
    pushbutton btn_car4(.clk(clk), .resetn(!btnoff4), .pushn(btncar[3]), .push(btnidccar[3]));
    pushbutton btn_car5(.clk(clk), .resetn(!btnoff5), .pushn(btncar[4]), .push(btnidccar[4]));
endmodule

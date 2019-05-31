
module counter_1s (
    input clk,
    input resetn,
    input enable,
    output carryOut,
    output reg [3:0] countVal
);

    reg [5:0] countClk;
    reg [9:0] count1000;
    reg [6:0] count100;
    wire countClk_exp;
    wire count1000_exp;
    wire count100_exp;

    parameter par_num_clk = 3; // 65
    parameter par_num_1000 = 3; // 999
    parameter par_num_100 = 3; // 99
    parameter par_100ms = 9;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) countClk <= 0;
        else if (enable) begin
            if (countClk_exp) countClk <= 0;
            else countClk <= countClk + 1;
        end
        else countClk <= countClk;
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) count1000 <= 0;
        else if (enable) begin
            if (count1000_exp) count1000 <= 0;
            else if (countClk_exp) count1000 <= count1000 + 1;
            else count1000 <= count1000;
        end
        else count1000 <= count1000;
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) count100 <= 0;
        else if (enable) begin
            if (count100_exp) count100 <= 0;
            else if (count1000_exp) count100 <= count100 + 1;
            else count100 <= count100;
        end
        else count100 <= count100;
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) countVal <= 0;
        else if (enable) begin
            if (carryOut) countVal <= 0;
            else if (count100_exp) countVal <= countVal + 1;
            else countVal <= countVal;
        end
        else countVal <= countVal;
    end

    assign countClk_exp = (countClk == par_num_clk);
    assign count1000_exp = countClk_exp & (count1000 == par_num_1000);
    assign count100_exp = count1000_exp & (count100 == par_num_100);
    assign carryOut = count100_exp & (countVal == par_100ms);
    
endmodule

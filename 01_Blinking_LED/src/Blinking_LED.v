module top (
    input clk,       // Onboard clock (usually 50MHz on GW5A-LV25)
    output reg led,
   // Your breadboard LED
    output rst,
    output pwd
    
);

// 25,000,000 cycles = 0.5 seconds at 50MHz
localparam WAIT_TIME = 1;

reg [24:0] clockCounter = 0;

always @(posedge clk) begin
    if (clockCounter < WAIT_TIME) begin
        clockCounter <= clockCounter + 1'b1;
    end else begin
        clockCounter <= 0;
        led <= ~led; // This flips the LED state every 0.5 seconds
    end
end

assign rst = 0;
assign pwd = 0 ;

endmodule
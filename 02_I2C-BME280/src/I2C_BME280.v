module I2C_BME280 (
    input clk,          // 27MHz clock
    output reg scl,     // I2C Clock
    inout sda           // I2C Data
);

    // 1. Timing: Create a slow pulse (100kHz)
    reg [8:0] clk_count = 0;
    wire i2c_tick = (clk_count == 500);
    always @(posedge clk) clk_count <= i2c_tick ? 0 : clk_count + 1;

    // 2. State Control
    reg [7:0] step = 0;
    reg sda_out = 1;
    reg sda_en  = 1; 

    // The Physical Wire Logic (Tri-state)
    assign sda = (sda_en) ? (sda_out ? 1'bz : 1'b0) : 1'bz;

    // 3. The Address (0x76 + Write Bit 0 = 11101100)
    parameter [7:0] ADDR = 8'b11101100;

    always @(posedge clk) begin
        if (i2c_tick) begin
            case (step)
                // START: SDA drops while SCL is High
                0: begin sda_out <= 1; scl <= 1; sda_en <= 1; end
                1: begin sda_out <= 0; end 
                2: begin scl <= 0; end     

                // BITS 7 to 0: Sending the Address
                // Each bit follows: Set SDA -> SCL Up -> SCL Down
                3:  begin sda_out <= ADDR[7]; end 4: begin scl <= 1; end 5: begin scl <= 0; end
                6:  begin sda_out <= ADDR[6]; end 7: begin scl <= 1; end 8: begin scl <= 0; end
                9:  begin sda_out <= ADDR[5]; end 10:begin scl <= 1; end 11:begin scl <= 0; end
                12: begin sda_out <= ADDR[4]; end 13:begin scl <= 1; end 14:begin scl <= 0; end
                15: begin sda_out <= ADDR[3]; end 16:begin scl <= 1; end 17:begin scl <= 0; end
                18: begin sda_out <= ADDR[2]; end 19:begin scl <= 1; end 20:begin scl <= 0; end
                21: begin sda_out <= ADDR[1]; end 22:begin scl <= 1; end 23:begin scl <= 0; end
                24: begin sda_out <= ADDR[0]; end 25:begin scl <= 1; end 26:begin scl <= 0; end

                // THE ACK: Master listens, Slave speaks
                27: begin sda_en <= 0; end // FPGA stops driving SDA
                28: begin scl <= 1;    end // Lift clock to let sensor talk
                29: begin scl <= 0;    end // Drop clock

                // STOP: SDA rises while SCL is High
                30: begin sda_en <= 1; sda_out <= 0; end
                31: begin scl <= 1; end
                32: begin sda_out <= 1; end
                
                default: ; // Stay idle
            endcase

            if (step < 35) step <= step + 1;
        end
    end
endmodule
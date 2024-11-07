 // Nisanur Yüksel 20220701021, Eren Nikbay 20210701090, Yaðýz Oflu 20220701074 241 project
      module fire_alarm_system (
    input wire clk,       
    input wire reset,     
    input wire smoke,    
    input wire reset_button, 
    output wire alarm,    
    output wire water     
);

// Parameters for timer (1-minute timeout)
parameter TIMER_MAX = 60_000_000; 

// Internal signals
reg [25:0] timer_count; 
reg timer_expired;      
reg alarm_state;        

// Timer logic (simple counter for 1-minute timeout)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        timer_count <= 0;
        timer_expired <= 0;
    end
    else if (smoke && !reset_button && !timer_expired) begin
        if (timer_count == TIMER_MAX) begin
            timer_expired <= 1;
        end
        else begin
            timer_count <= timer_count + 1;
        end
    end
    else if (reset_button) begin
        timer_count <= 0;
        timer_expired <= 0;
    end
end

// Alarm logic: Trigger alarm when smoke is detected
always @(posedge clk or posedge reset) begin
    if (reset) begin
        alarm_state <= 0;
    end
    else if (smoke) begin
        alarm_state <= 1;
    end
    else if (reset_button) begin
        alarm_state <= 0;
    end
end

// Water system logic: Activate if timer expired and no reset
assign water = (timer_expired && !reset_button) ? 1'b1 : 1'b0;

// Alarm output
assign alarm = alarm_state;

endmodule
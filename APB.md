# BHARAT


module APB(
  input                        clk,
  input                        rst_n,
  input        [7:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  output                       pready,
  input        [31:0] pwdata,
  output reg   [31:0] prdata
);

reg slave_busy;
reg [31:0] mem [255:0];
reg[1:0] next_state;
reg[1:0] present_state;

parameter IDLE   = 2'b00;
parameter SETUP  = 2'b01;
parameter ACCESS = 2'b10;

assign pready =(present_state==SETUP)? !slave_busy : 'b0;

always @(posedge rst_n or posedge clk)
begin
  if (rst_n == 0) 
   begin
      prdata <= 0;
		present_state <= IDLE;
  end
  else
 present_state <= next_state;
 end

always @(*) 
   begin
    case (present_state)
      IDLE  : begin
	    // slave_busy =0;
	    if((psel==0) && (penable==0))
	    next_state = IDLE;
		  else if((psel==1) && (penable==0))
		  next_state = SETUP;
		  end
	  
	  SETUP : begin
		     next_state = ACCESS;  
		end
	  ACCESS : begin
           if ((psel ==1) && (penable==0) && pready) begin
//              mem[paddr] = pwdata;
              next_state = SETUP;
          end

/*         else if (psel && penable && !pwrite && pready) begin
            prdata = mem[paddr];
           next_state = SETUP;
          end*/
		  else if((psel==0) && (penable==0))
           next_state = IDLE;
        else  if(pready == 0)
           next_state = ACCESS;			  
        end
    endcase
  end
  
  always @(*)
  begin
  case(next_state)
   IDLE : begin
          slave_busy = 0;
         end	
			
	SETUP :begin
//	       slave_busy <= 0;
	       end
	
	ACCESS : begin
	    if(!pwrite)
		 begin
		 prdata = mem[paddr];
	    end
		 else
		 begin
		 mem[paddr] = pwdata;
	   end
		end

endcase
end	
endmodule

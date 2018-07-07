# BHARAT

module apb_slave_tb;

	// Inputs
	reg clk;
	reg [7:0] paddr;
	reg pwrite;
	reg psel;
	reg penable;
	reg [31:0] pwdata;
	reg rst_n;

	// Outputs
	wire [31:0] prdata;
   wire pready;
	// Instantiate the Unit Under Test (UUT)
	APB apb_ins(
		.clk(clk),
      .rst_n(rst_n),		
		.paddr(paddr), 
		.pwrite(pwrite), 
		.psel(psel), 
		.penable(penable),
      .pready(pready),		
		.pwdata(pwdata),  
		.prdata(prdata) 
	);

task initial_values();
 begin
		// Initialize Inputs
        clk = 0;
		rst_n = 1;
		paddr = 0;
		pwrite = 0;
		psel = 0;
		penable = 0;
		pwdata = 0;
	end	
endtask
	
	
always     
begin	
 #5 clk= ~clk;		
end

task rst();
begin
@(posedge clk);
@(posedge clk);
rst_n = 0;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
rst_n = 1;
end
endtask

task apb_write();
begin
paddr = 'd64;
pwrite = 1;
psel  = 1;
penable = 0;
pwdata = {$random};
@(posedge clk);
penable = 1;
wait(pready);
@(posedge clk);
psel=0;
penable =0;
pwrite = 0;
pwdata = 32'b0;

@(posedge clk);
@(posedge clk);

paddr = 'd16;
pwrite = 1;
psel  = 1;
penable = 0;
pwdata = {$random};
@(posedge clk);
penable = 1;
wait(pready);
@(posedge clk);
psel=0;
penable =0;
pwrite = 0;
pwdata = 32'b0;
end
endtask


task apb_read();
begin
@(posedge clk);
paddr = 'd64;
pwrite = 0;
psel  = 1;
penable = 0;
@(posedge clk);
penable = 1;
wait(pready);
@(posedge clk);
psel=0;
penable =0;
pwrite = 1;

@(posedge clk);
@(posedge clk);

paddr = 'd16;
pwrite = 0;
psel  = 1;
penable = 0;
@(posedge clk);
penable = 1;
wait(pready);
@(posedge clk);
psel=0;
penable =0;
pwrite = 1;


end
endtask


initial
begin
initial_values();
rst();
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
apb_write();
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
apb_read();

$finish();
end

endmodule

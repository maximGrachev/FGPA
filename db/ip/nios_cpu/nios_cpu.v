// nios_cpu.v


`timescale 1 ps / 1 ps
module nios_cpu (
		input  wire  uart_rxd,      //  uart.rxd
		output wire  uart_txd,      //      .txd
		input  wire  reset_reset_n, // reset.reset_n
		input  wire  clk_clk        //   clk.clk
	);

	wire         nios_cpu_instruction_master_waitrequest;                                                         // nios_cpu_instruction_master_translator:av_waitrequest -> nios_cpu:i_waitrequest
	wire  [15:0] nios_cpu_instruction_master_address;                                                             // nios_cpu:i_address -> nios_cpu_instruction_master_translator:av_address
	wire         nios_cpu_instruction_master_read;                                                                // nios_cpu:i_read -> nios_cpu_instruction_master_translator:av_read
	wire  [31:0] nios_cpu_instruction_master_readdata;                                                            // nios_cpu_instruction_master_translator:av_readdata -> nios_cpu:i_readdata
	wire         nios_cpu_data_master_waitrequest;                                                                // nios_cpu_data_master_translator:av_waitrequest -> nios_cpu:d_waitrequest
	wire  [31:0] nios_cpu_data_master_writedata;                                                                  // nios_cpu:d_writedata -> nios_cpu_data_master_translator:av_writedata
	wire  [15:0] nios_cpu_data_master_address;                                                                    // nios_cpu:d_address -> nios_cpu_data_master_translator:av_address
	wire         nios_cpu_data_master_write;                                                                      // nios_cpu:d_write -> nios_cpu_data_master_translator:av_write
	wire         nios_cpu_data_master_read;                                                                       // nios_cpu:d_read -> nios_cpu_data_master_translator:av_read
	wire  [31:0] nios_cpu_data_master_readdata;                                                                   // nios_cpu_data_master_translator:av_readdata -> nios_cpu:d_readdata
	wire         nios_cpu_data_master_debugaccess;                                                                // nios_cpu:jtag_debug_module_debugaccess_to_roms -> nios_cpu_data_master_translator:av_debugaccess
	wire   [3:0] nios_cpu_data_master_byteenable;                                                                 // nios_cpu:d_byteenable -> nios_cpu_data_master_translator:av_byteenable
	wire  [31:0] nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata;                             // nios_cpu_jtag_debug_module_translator:av_writedata -> nios_cpu:jtag_debug_module_writedata
	wire   [8:0] nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_address;                               // nios_cpu_jtag_debug_module_translator:av_address -> nios_cpu:jtag_debug_module_address
	wire         nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect;                            // nios_cpu_jtag_debug_module_translator:av_chipselect -> nios_cpu:jtag_debug_module_select
	wire         nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_write;                                 // nios_cpu_jtag_debug_module_translator:av_write -> nios_cpu:jtag_debug_module_write
	wire  [31:0] nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata;                              // nios_cpu:jtag_debug_module_readdata -> nios_cpu_jtag_debug_module_translator:av_readdata
	wire         nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer;                         // nios_cpu_jtag_debug_module_translator:av_begintransfer -> nios_cpu:jtag_debug_module_begintransfer
	wire         nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess;                           // nios_cpu_jtag_debug_module_translator:av_debugaccess -> nios_cpu:jtag_debug_module_debugaccess
	wire   [3:0] nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable;                            // nios_cpu_jtag_debug_module_translator:av_byteenable -> nios_cpu:jtag_debug_module_byteenable
	wire  [15:0] uart_0_s1_translator_avalon_anti_slave_0_writedata;                                              // uart_0_s1_translator:av_writedata -> uart_0:writedata
	wire   [2:0] uart_0_s1_translator_avalon_anti_slave_0_address;                                                // uart_0_s1_translator:av_address -> uart_0:address
	wire         uart_0_s1_translator_avalon_anti_slave_0_chipselect;                                             // uart_0_s1_translator:av_chipselect -> uart_0:chipselect
	wire         uart_0_s1_translator_avalon_anti_slave_0_write;                                                  // uart_0_s1_translator:av_write -> uart_0:write_n
	wire         uart_0_s1_translator_avalon_anti_slave_0_read;                                                   // uart_0_s1_translator:av_read -> uart_0:read_n
	wire  [15:0] uart_0_s1_translator_avalon_anti_slave_0_readdata;                                               // uart_0:readdata -> uart_0_s1_translator:av_readdata
	wire         uart_0_s1_translator_avalon_anti_slave_0_begintransfer;                                          // uart_0_s1_translator:av_begintransfer -> uart_0:begintransfer
	wire         sysid_control_slave_translator_avalon_anti_slave_0_address;                                      // sysid_control_slave_translator:av_address -> sysid:address
	wire  [31:0] sysid_control_slave_translator_avalon_anti_slave_0_readdata;                                     // sysid:readdata -> sysid_control_slave_translator:av_readdata
	wire  [31:0] on_chip_ram_s1_translator_avalon_anti_slave_0_writedata;                                         // on_chip_RAM_s1_translator:av_writedata -> on_chip_RAM:writedata
	wire  [11:0] on_chip_ram_s1_translator_avalon_anti_slave_0_address;                                           // on_chip_RAM_s1_translator:av_address -> on_chip_RAM:address
	wire         on_chip_ram_s1_translator_avalon_anti_slave_0_chipselect;                                        // on_chip_RAM_s1_translator:av_chipselect -> on_chip_RAM:chipselect
	wire         on_chip_ram_s1_translator_avalon_anti_slave_0_clken;                                             // on_chip_RAM_s1_translator:av_clken -> on_chip_RAM:clken
	wire         on_chip_ram_s1_translator_avalon_anti_slave_0_write;                                             // on_chip_RAM_s1_translator:av_write -> on_chip_RAM:write
	wire  [31:0] on_chip_ram_s1_translator_avalon_anti_slave_0_readdata;                                          // on_chip_RAM:readdata -> on_chip_RAM_s1_translator:av_readdata
	wire   [3:0] on_chip_ram_s1_translator_avalon_anti_slave_0_byteenable;                                        // on_chip_RAM_s1_translator:av_byteenable -> on_chip_RAM:byteenable
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_waitrequest;                    // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_waitrequest -> nios_cpu_instruction_master_translator:uav_waitrequest
	wire   [2:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_burstcount;                     // nios_cpu_instruction_master_translator:uav_burstcount -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_burstcount
	wire  [31:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_writedata;                      // nios_cpu_instruction_master_translator:uav_writedata -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_writedata
	wire  [15:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_address;                        // nios_cpu_instruction_master_translator:uav_address -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_address
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_lock;                           // nios_cpu_instruction_master_translator:uav_lock -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_lock
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_write;                          // nios_cpu_instruction_master_translator:uav_write -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_write
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_read;                           // nios_cpu_instruction_master_translator:uav_read -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_read
	wire  [31:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_readdata;                       // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_readdata -> nios_cpu_instruction_master_translator:uav_readdata
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_debugaccess;                    // nios_cpu_instruction_master_translator:uav_debugaccess -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_debugaccess
	wire   [3:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_byteenable;                     // nios_cpu_instruction_master_translator:uav_byteenable -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_byteenable
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid;                  // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:av_readdatavalid -> nios_cpu_instruction_master_translator:uav_readdatavalid
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_waitrequest;                           // nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_waitrequest -> nios_cpu_data_master_translator:uav_waitrequest
	wire   [2:0] nios_cpu_data_master_translator_avalon_universal_master_0_burstcount;                            // nios_cpu_data_master_translator:uav_burstcount -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_burstcount
	wire  [31:0] nios_cpu_data_master_translator_avalon_universal_master_0_writedata;                             // nios_cpu_data_master_translator:uav_writedata -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_writedata
	wire  [15:0] nios_cpu_data_master_translator_avalon_universal_master_0_address;                               // nios_cpu_data_master_translator:uav_address -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_address
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_lock;                                  // nios_cpu_data_master_translator:uav_lock -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_lock
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_write;                                 // nios_cpu_data_master_translator:uav_write -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_write
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_read;                                  // nios_cpu_data_master_translator:uav_read -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_read
	wire  [31:0] nios_cpu_data_master_translator_avalon_universal_master_0_readdata;                              // nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_readdata -> nios_cpu_data_master_translator:uav_readdata
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_debugaccess;                           // nios_cpu_data_master_translator:uav_debugaccess -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_debugaccess
	wire   [3:0] nios_cpu_data_master_translator_avalon_universal_master_0_byteenable;                            // nios_cpu_data_master_translator:uav_byteenable -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_byteenable
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_readdatavalid;                         // nios_cpu_data_master_translator_avalon_universal_master_0_agent:av_readdatavalid -> nios_cpu_data_master_translator:uav_readdatavalid
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest;             // nios_cpu_jtag_debug_module_translator:uav_waitrequest -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount;              // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_burstcount -> nios_cpu_jtag_debug_module_translator:uav_burstcount
	wire  [31:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata;               // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_writedata -> nios_cpu_jtag_debug_module_translator:uav_writedata
	wire  [15:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address;                 // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_address -> nios_cpu_jtag_debug_module_translator:uav_address
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write;                   // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_write -> nios_cpu_jtag_debug_module_translator:uav_write
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_lock;                    // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_lock -> nios_cpu_jtag_debug_module_translator:uav_lock
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read;                    // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_read -> nios_cpu_jtag_debug_module_translator:uav_read
	wire  [31:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata;                // nios_cpu_jtag_debug_module_translator:uav_readdata -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid;           // nios_cpu_jtag_debug_module_translator:uav_readdatavalid -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess;             // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_debugaccess -> nios_cpu_jtag_debug_module_translator:uav_debugaccess
	wire   [3:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable;              // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_byteenable -> nios_cpu_jtag_debug_module_translator:uav_byteenable
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;      // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid;            // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_valid -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;    // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [71:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data;             // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_data -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready;            // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;   // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;         // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket; // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [71:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;          // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;         // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_ready -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;       // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;        // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;       // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest;                              // uart_0_s1_translator:uav_waitrequest -> uart_0_s1_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] uart_0_s1_translator_avalon_universal_slave_0_agent_m0_burstcount;                               // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_burstcount -> uart_0_s1_translator:uav_burstcount
	wire  [31:0] uart_0_s1_translator_avalon_universal_slave_0_agent_m0_writedata;                                // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_writedata -> uart_0_s1_translator:uav_writedata
	wire  [15:0] uart_0_s1_translator_avalon_universal_slave_0_agent_m0_address;                                  // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_address -> uart_0_s1_translator:uav_address
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_write;                                    // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_write -> uart_0_s1_translator:uav_write
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_lock;                                     // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_lock -> uart_0_s1_translator:uav_lock
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_read;                                     // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_read -> uart_0_s1_translator:uav_read
	wire  [31:0] uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdata;                                 // uart_0_s1_translator:uav_readdata -> uart_0_s1_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                            // uart_0_s1_translator:uav_readdatavalid -> uart_0_s1_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess;                              // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_debugaccess -> uart_0_s1_translator:uav_debugaccess
	wire   [3:0] uart_0_s1_translator_avalon_universal_slave_0_agent_m0_byteenable;                               // uart_0_s1_translator_avalon_universal_slave_0_agent:m0_byteenable -> uart_0_s1_translator:uav_byteenable
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;                       // uart_0_s1_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_valid;                             // uart_0_s1_translator_avalon_universal_slave_0_agent:rf_source_valid -> uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;                     // uart_0_s1_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [71:0] uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_data;                              // uart_0_s1_translator_avalon_universal_slave_0_agent:rf_source_data -> uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_ready;                             // uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> uart_0_s1_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;                    // uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;                          // uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> uart_0_s1_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;                  // uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [71:0] uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                           // uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> uart_0_s1_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;                          // uart_0_s1_translator_avalon_universal_slave_0_agent:rf_sink_ready -> uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;                        // uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;                         // uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;                        // uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> uart_0_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest;                    // sysid_control_slave_translator:uav_waitrequest -> sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_burstcount;                     // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_burstcount -> sysid_control_slave_translator:uav_burstcount
	wire  [31:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_writedata;                      // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_writedata -> sysid_control_slave_translator:uav_writedata
	wire  [15:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_address;                        // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_address -> sysid_control_slave_translator:uav_address
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_write;                          // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_write -> sysid_control_slave_translator:uav_write
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_lock;                           // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_lock -> sysid_control_slave_translator:uav_lock
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_read;                           // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_read -> sysid_control_slave_translator:uav_read
	wire  [31:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdata;                       // sysid_control_slave_translator:uav_readdata -> sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                  // sysid_control_slave_translator:uav_readdatavalid -> sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess;                    // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_debugaccess -> sysid_control_slave_translator:uav_debugaccess
	wire   [3:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_byteenable;                     // sysid_control_slave_translator_avalon_universal_slave_0_agent:m0_byteenable -> sysid_control_slave_translator:uav_byteenable
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;             // sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_valid;                   // sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_source_valid -> sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;           // sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [71:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_data;                    // sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_source_data -> sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_ready;                   // sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;          // sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;                // sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;        // sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [71:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                 // sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;                // sysid_control_slave_translator_avalon_universal_slave_0_agent:rf_sink_ready -> sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;              // sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;               // sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;              // sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest;                         // on_chip_RAM_s1_translator:uav_waitrequest -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount;                          // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_burstcount -> on_chip_RAM_s1_translator:uav_burstcount
	wire  [31:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata;                           // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_writedata -> on_chip_RAM_s1_translator:uav_writedata
	wire  [15:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address;                             // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_address -> on_chip_RAM_s1_translator:uav_address
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write;                               // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_write -> on_chip_RAM_s1_translator:uav_write
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_lock;                                // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_lock -> on_chip_RAM_s1_translator:uav_lock
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read;                                // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_read -> on_chip_RAM_s1_translator:uav_read
	wire  [31:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata;                            // on_chip_RAM_s1_translator:uav_readdata -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                       // on_chip_RAM_s1_translator:uav_readdatavalid -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess;                         // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_debugaccess -> on_chip_RAM_s1_translator:uav_debugaccess
	wire   [3:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable;                          // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:m0_byteenable -> on_chip_RAM_s1_translator:uav_byteenable
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;                  // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid;                        // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_source_valid -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;                // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [71:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data;                         // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_source_data -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready;                        // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;               // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;                     // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;             // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [71:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                      // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;                     // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rf_sink_ready -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;                   // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;                    // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;                   // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket;           // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_endofpacket -> addr_router:sink_endofpacket
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid;                 // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_valid -> addr_router:sink_valid
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket;         // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_startofpacket -> addr_router:sink_startofpacket
	wire  [70:0] nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data;                  // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_data -> addr_router:sink_data
	wire         nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready;                 // addr_router:sink_ready -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_ready
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket;                  // nios_cpu_data_master_translator_avalon_universal_master_0_agent:cp_endofpacket -> addr_router_001:sink_endofpacket
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid;                        // nios_cpu_data_master_translator_avalon_universal_master_0_agent:cp_valid -> addr_router_001:sink_valid
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket;                // nios_cpu_data_master_translator_avalon_universal_master_0_agent:cp_startofpacket -> addr_router_001:sink_startofpacket
	wire  [70:0] nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_data;                         // nios_cpu_data_master_translator_avalon_universal_master_0_agent:cp_data -> addr_router_001:sink_data
	wire         nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready;                        // addr_router_001:sink_ready -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:cp_ready
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket;             // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router:sink_endofpacket
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid;                   // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_valid -> id_router:sink_valid
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket;           // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router:sink_startofpacket
	wire  [70:0] nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data;                    // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_data -> id_router:sink_data
	wire         nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready;                   // id_router:sink_ready -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_ready
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket;                              // uart_0_s1_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_001:sink_endofpacket
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rp_valid;                                    // uart_0_s1_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_001:sink_valid
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket;                            // uart_0_s1_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_001:sink_startofpacket
	wire  [70:0] uart_0_s1_translator_avalon_universal_slave_0_agent_rp_data;                                     // uart_0_s1_translator_avalon_universal_slave_0_agent:rp_data -> id_router_001:sink_data
	wire         uart_0_s1_translator_avalon_universal_slave_0_agent_rp_ready;                                    // id_router_001:sink_ready -> uart_0_s1_translator_avalon_universal_slave_0_agent:rp_ready
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket;                    // sysid_control_slave_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_002:sink_endofpacket
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_valid;                          // sysid_control_slave_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_002:sink_valid
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket;                  // sysid_control_slave_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_002:sink_startofpacket
	wire  [70:0] sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_data;                           // sysid_control_slave_translator_avalon_universal_slave_0_agent:rp_data -> id_router_002:sink_data
	wire         sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_ready;                          // id_router_002:sink_ready -> sysid_control_slave_translator_avalon_universal_slave_0_agent:rp_ready
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket;                         // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_003:sink_endofpacket
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid;                               // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_003:sink_valid
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket;                       // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_003:sink_startofpacket
	wire  [70:0] on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data;                                // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rp_data -> id_router_003:sink_data
	wire         on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready;                               // id_router_003:sink_ready -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:rp_ready
	wire         addr_router_src_endofpacket;                                                                     // addr_router:src_endofpacket -> limiter:cmd_sink_endofpacket
	wire         addr_router_src_valid;                                                                           // addr_router:src_valid -> limiter:cmd_sink_valid
	wire         addr_router_src_startofpacket;                                                                   // addr_router:src_startofpacket -> limiter:cmd_sink_startofpacket
	wire  [70:0] addr_router_src_data;                                                                            // addr_router:src_data -> limiter:cmd_sink_data
	wire   [3:0] addr_router_src_channel;                                                                         // addr_router:src_channel -> limiter:cmd_sink_channel
	wire         addr_router_src_ready;                                                                           // limiter:cmd_sink_ready -> addr_router:src_ready
	wire         limiter_rsp_src_endofpacket;                                                                     // limiter:rsp_src_endofpacket -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_endofpacket
	wire         limiter_rsp_src_valid;                                                                           // limiter:rsp_src_valid -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_valid
	wire         limiter_rsp_src_startofpacket;                                                                   // limiter:rsp_src_startofpacket -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_startofpacket
	wire  [70:0] limiter_rsp_src_data;                                                                            // limiter:rsp_src_data -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_data
	wire   [3:0] limiter_rsp_src_channel;                                                                         // limiter:rsp_src_channel -> nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_channel
	wire         limiter_rsp_src_ready;                                                                           // nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_ready -> limiter:rsp_src_ready
	wire         addr_router_001_src_endofpacket;                                                                 // addr_router_001:src_endofpacket -> limiter_001:cmd_sink_endofpacket
	wire         addr_router_001_src_valid;                                                                       // addr_router_001:src_valid -> limiter_001:cmd_sink_valid
	wire         addr_router_001_src_startofpacket;                                                               // addr_router_001:src_startofpacket -> limiter_001:cmd_sink_startofpacket
	wire  [70:0] addr_router_001_src_data;                                                                        // addr_router_001:src_data -> limiter_001:cmd_sink_data
	wire   [3:0] addr_router_001_src_channel;                                                                     // addr_router_001:src_channel -> limiter_001:cmd_sink_channel
	wire         addr_router_001_src_ready;                                                                       // limiter_001:cmd_sink_ready -> addr_router_001:src_ready
	wire         limiter_001_rsp_src_endofpacket;                                                                 // limiter_001:rsp_src_endofpacket -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_endofpacket
	wire         limiter_001_rsp_src_valid;                                                                       // limiter_001:rsp_src_valid -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_valid
	wire         limiter_001_rsp_src_startofpacket;                                                               // limiter_001:rsp_src_startofpacket -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_startofpacket
	wire  [70:0] limiter_001_rsp_src_data;                                                                        // limiter_001:rsp_src_data -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_data
	wire   [3:0] limiter_001_rsp_src_channel;                                                                     // limiter_001:rsp_src_channel -> nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_channel
	wire         limiter_001_rsp_src_ready;                                                                       // nios_cpu_data_master_translator_avalon_universal_master_0_agent:rp_ready -> limiter_001:rsp_src_ready
	wire         rst_controller_reset_out_reset;                                                                  // rst_controller:reset_out -> [addr_router:reset, addr_router_001:reset, cmd_xbar_demux:reset, cmd_xbar_demux_001:reset, cmd_xbar_mux:reset, cmd_xbar_mux_001:reset, cmd_xbar_mux_002:reset, cmd_xbar_mux_003:reset, id_router:reset, id_router_001:reset, id_router_002:reset, id_router_003:reset, irq_mapper:reset, limiter:reset, limiter_001:reset, nios_cpu:reset_n, nios_cpu_data_master_translator:reset, nios_cpu_data_master_translator_avalon_universal_master_0_agent:reset, nios_cpu_instruction_master_translator:reset, nios_cpu_instruction_master_translator_avalon_universal_master_0_agent:reset, nios_cpu_jtag_debug_module_translator:reset, nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:reset, nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, on_chip_RAM:reset, on_chip_RAM_s1_translator:reset, on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:reset, on_chip_RAM_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, rsp_xbar_demux:reset, rsp_xbar_demux_001:reset, rsp_xbar_demux_002:reset, rsp_xbar_demux_003:reset, rsp_xbar_mux:reset, rsp_xbar_mux_001:reset, sysid:reset_n, sysid_control_slave_translator:reset, sysid_control_slave_translator_avalon_universal_slave_0_agent:reset, sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, uart_0:reset_n, uart_0_s1_translator:reset, uart_0_s1_translator_avalon_universal_slave_0_agent:reset, uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:reset]
	wire         cmd_xbar_demux_src0_endofpacket;                                                                 // cmd_xbar_demux:src0_endofpacket -> cmd_xbar_mux:sink0_endofpacket
	wire         cmd_xbar_demux_src0_valid;                                                                       // cmd_xbar_demux:src0_valid -> cmd_xbar_mux:sink0_valid
	wire         cmd_xbar_demux_src0_startofpacket;                                                               // cmd_xbar_demux:src0_startofpacket -> cmd_xbar_mux:sink0_startofpacket
	wire  [70:0] cmd_xbar_demux_src0_data;                                                                        // cmd_xbar_demux:src0_data -> cmd_xbar_mux:sink0_data
	wire   [3:0] cmd_xbar_demux_src0_channel;                                                                     // cmd_xbar_demux:src0_channel -> cmd_xbar_mux:sink0_channel
	wire         cmd_xbar_demux_src0_ready;                                                                       // cmd_xbar_mux:sink0_ready -> cmd_xbar_demux:src0_ready
	wire         cmd_xbar_demux_src1_endofpacket;                                                                 // cmd_xbar_demux:src1_endofpacket -> cmd_xbar_mux_001:sink0_endofpacket
	wire         cmd_xbar_demux_src1_valid;                                                                       // cmd_xbar_demux:src1_valid -> cmd_xbar_mux_001:sink0_valid
	wire         cmd_xbar_demux_src1_startofpacket;                                                               // cmd_xbar_demux:src1_startofpacket -> cmd_xbar_mux_001:sink0_startofpacket
	wire  [70:0] cmd_xbar_demux_src1_data;                                                                        // cmd_xbar_demux:src1_data -> cmd_xbar_mux_001:sink0_data
	wire   [3:0] cmd_xbar_demux_src1_channel;                                                                     // cmd_xbar_demux:src1_channel -> cmd_xbar_mux_001:sink0_channel
	wire         cmd_xbar_demux_src1_ready;                                                                       // cmd_xbar_mux_001:sink0_ready -> cmd_xbar_demux:src1_ready
	wire         cmd_xbar_demux_src2_endofpacket;                                                                 // cmd_xbar_demux:src2_endofpacket -> cmd_xbar_mux_002:sink0_endofpacket
	wire         cmd_xbar_demux_src2_valid;                                                                       // cmd_xbar_demux:src2_valid -> cmd_xbar_mux_002:sink0_valid
	wire         cmd_xbar_demux_src2_startofpacket;                                                               // cmd_xbar_demux:src2_startofpacket -> cmd_xbar_mux_002:sink0_startofpacket
	wire  [70:0] cmd_xbar_demux_src2_data;                                                                        // cmd_xbar_demux:src2_data -> cmd_xbar_mux_002:sink0_data
	wire   [3:0] cmd_xbar_demux_src2_channel;                                                                     // cmd_xbar_demux:src2_channel -> cmd_xbar_mux_002:sink0_channel
	wire         cmd_xbar_demux_src2_ready;                                                                       // cmd_xbar_mux_002:sink0_ready -> cmd_xbar_demux:src2_ready
	wire         cmd_xbar_demux_src3_endofpacket;                                                                 // cmd_xbar_demux:src3_endofpacket -> cmd_xbar_mux_003:sink0_endofpacket
	wire         cmd_xbar_demux_src3_valid;                                                                       // cmd_xbar_demux:src3_valid -> cmd_xbar_mux_003:sink0_valid
	wire         cmd_xbar_demux_src3_startofpacket;                                                               // cmd_xbar_demux:src3_startofpacket -> cmd_xbar_mux_003:sink0_startofpacket
	wire  [70:0] cmd_xbar_demux_src3_data;                                                                        // cmd_xbar_demux:src3_data -> cmd_xbar_mux_003:sink0_data
	wire   [3:0] cmd_xbar_demux_src3_channel;                                                                     // cmd_xbar_demux:src3_channel -> cmd_xbar_mux_003:sink0_channel
	wire         cmd_xbar_demux_src3_ready;                                                                       // cmd_xbar_mux_003:sink0_ready -> cmd_xbar_demux:src3_ready
	wire         cmd_xbar_demux_001_src0_endofpacket;                                                             // cmd_xbar_demux_001:src0_endofpacket -> cmd_xbar_mux:sink1_endofpacket
	wire         cmd_xbar_demux_001_src0_valid;                                                                   // cmd_xbar_demux_001:src0_valid -> cmd_xbar_mux:sink1_valid
	wire         cmd_xbar_demux_001_src0_startofpacket;                                                           // cmd_xbar_demux_001:src0_startofpacket -> cmd_xbar_mux:sink1_startofpacket
	wire  [70:0] cmd_xbar_demux_001_src0_data;                                                                    // cmd_xbar_demux_001:src0_data -> cmd_xbar_mux:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src0_channel;                                                                 // cmd_xbar_demux_001:src0_channel -> cmd_xbar_mux:sink1_channel
	wire         cmd_xbar_demux_001_src0_ready;                                                                   // cmd_xbar_mux:sink1_ready -> cmd_xbar_demux_001:src0_ready
	wire         cmd_xbar_demux_001_src1_endofpacket;                                                             // cmd_xbar_demux_001:src1_endofpacket -> cmd_xbar_mux_001:sink1_endofpacket
	wire         cmd_xbar_demux_001_src1_valid;                                                                   // cmd_xbar_demux_001:src1_valid -> cmd_xbar_mux_001:sink1_valid
	wire         cmd_xbar_demux_001_src1_startofpacket;                                                           // cmd_xbar_demux_001:src1_startofpacket -> cmd_xbar_mux_001:sink1_startofpacket
	wire  [70:0] cmd_xbar_demux_001_src1_data;                                                                    // cmd_xbar_demux_001:src1_data -> cmd_xbar_mux_001:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src1_channel;                                                                 // cmd_xbar_demux_001:src1_channel -> cmd_xbar_mux_001:sink1_channel
	wire         cmd_xbar_demux_001_src1_ready;                                                                   // cmd_xbar_mux_001:sink1_ready -> cmd_xbar_demux_001:src1_ready
	wire         cmd_xbar_demux_001_src2_endofpacket;                                                             // cmd_xbar_demux_001:src2_endofpacket -> cmd_xbar_mux_002:sink1_endofpacket
	wire         cmd_xbar_demux_001_src2_valid;                                                                   // cmd_xbar_demux_001:src2_valid -> cmd_xbar_mux_002:sink1_valid
	wire         cmd_xbar_demux_001_src2_startofpacket;                                                           // cmd_xbar_demux_001:src2_startofpacket -> cmd_xbar_mux_002:sink1_startofpacket
	wire  [70:0] cmd_xbar_demux_001_src2_data;                                                                    // cmd_xbar_demux_001:src2_data -> cmd_xbar_mux_002:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src2_channel;                                                                 // cmd_xbar_demux_001:src2_channel -> cmd_xbar_mux_002:sink1_channel
	wire         cmd_xbar_demux_001_src2_ready;                                                                   // cmd_xbar_mux_002:sink1_ready -> cmd_xbar_demux_001:src2_ready
	wire         cmd_xbar_demux_001_src3_endofpacket;                                                             // cmd_xbar_demux_001:src3_endofpacket -> cmd_xbar_mux_003:sink1_endofpacket
	wire         cmd_xbar_demux_001_src3_valid;                                                                   // cmd_xbar_demux_001:src3_valid -> cmd_xbar_mux_003:sink1_valid
	wire         cmd_xbar_demux_001_src3_startofpacket;                                                           // cmd_xbar_demux_001:src3_startofpacket -> cmd_xbar_mux_003:sink1_startofpacket
	wire  [70:0] cmd_xbar_demux_001_src3_data;                                                                    // cmd_xbar_demux_001:src3_data -> cmd_xbar_mux_003:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src3_channel;                                                                 // cmd_xbar_demux_001:src3_channel -> cmd_xbar_mux_003:sink1_channel
	wire         cmd_xbar_demux_001_src3_ready;                                                                   // cmd_xbar_mux_003:sink1_ready -> cmd_xbar_demux_001:src3_ready
	wire         rsp_xbar_demux_src0_endofpacket;                                                                 // rsp_xbar_demux:src0_endofpacket -> rsp_xbar_mux:sink0_endofpacket
	wire         rsp_xbar_demux_src0_valid;                                                                       // rsp_xbar_demux:src0_valid -> rsp_xbar_mux:sink0_valid
	wire         rsp_xbar_demux_src0_startofpacket;                                                               // rsp_xbar_demux:src0_startofpacket -> rsp_xbar_mux:sink0_startofpacket
	wire  [70:0] rsp_xbar_demux_src0_data;                                                                        // rsp_xbar_demux:src0_data -> rsp_xbar_mux:sink0_data
	wire   [3:0] rsp_xbar_demux_src0_channel;                                                                     // rsp_xbar_demux:src0_channel -> rsp_xbar_mux:sink0_channel
	wire         rsp_xbar_demux_src0_ready;                                                                       // rsp_xbar_mux:sink0_ready -> rsp_xbar_demux:src0_ready
	wire         rsp_xbar_demux_src1_endofpacket;                                                                 // rsp_xbar_demux:src1_endofpacket -> rsp_xbar_mux_001:sink0_endofpacket
	wire         rsp_xbar_demux_src1_valid;                                                                       // rsp_xbar_demux:src1_valid -> rsp_xbar_mux_001:sink0_valid
	wire         rsp_xbar_demux_src1_startofpacket;                                                               // rsp_xbar_demux:src1_startofpacket -> rsp_xbar_mux_001:sink0_startofpacket
	wire  [70:0] rsp_xbar_demux_src1_data;                                                                        // rsp_xbar_demux:src1_data -> rsp_xbar_mux_001:sink0_data
	wire   [3:0] rsp_xbar_demux_src1_channel;                                                                     // rsp_xbar_demux:src1_channel -> rsp_xbar_mux_001:sink0_channel
	wire         rsp_xbar_demux_src1_ready;                                                                       // rsp_xbar_mux_001:sink0_ready -> rsp_xbar_demux:src1_ready
	wire         rsp_xbar_demux_001_src0_endofpacket;                                                             // rsp_xbar_demux_001:src0_endofpacket -> rsp_xbar_mux:sink1_endofpacket
	wire         rsp_xbar_demux_001_src0_valid;                                                                   // rsp_xbar_demux_001:src0_valid -> rsp_xbar_mux:sink1_valid
	wire         rsp_xbar_demux_001_src0_startofpacket;                                                           // rsp_xbar_demux_001:src0_startofpacket -> rsp_xbar_mux:sink1_startofpacket
	wire  [70:0] rsp_xbar_demux_001_src0_data;                                                                    // rsp_xbar_demux_001:src0_data -> rsp_xbar_mux:sink1_data
	wire   [3:0] rsp_xbar_demux_001_src0_channel;                                                                 // rsp_xbar_demux_001:src0_channel -> rsp_xbar_mux:sink1_channel
	wire         rsp_xbar_demux_001_src0_ready;                                                                   // rsp_xbar_mux:sink1_ready -> rsp_xbar_demux_001:src0_ready
	wire         rsp_xbar_demux_001_src1_endofpacket;                                                             // rsp_xbar_demux_001:src1_endofpacket -> rsp_xbar_mux_001:sink1_endofpacket
	wire         rsp_xbar_demux_001_src1_valid;                                                                   // rsp_xbar_demux_001:src1_valid -> rsp_xbar_mux_001:sink1_valid
	wire         rsp_xbar_demux_001_src1_startofpacket;                                                           // rsp_xbar_demux_001:src1_startofpacket -> rsp_xbar_mux_001:sink1_startofpacket
	wire  [70:0] rsp_xbar_demux_001_src1_data;                                                                    // rsp_xbar_demux_001:src1_data -> rsp_xbar_mux_001:sink1_data
	wire   [3:0] rsp_xbar_demux_001_src1_channel;                                                                 // rsp_xbar_demux_001:src1_channel -> rsp_xbar_mux_001:sink1_channel
	wire         rsp_xbar_demux_001_src1_ready;                                                                   // rsp_xbar_mux_001:sink1_ready -> rsp_xbar_demux_001:src1_ready
	wire         rsp_xbar_demux_002_src0_endofpacket;                                                             // rsp_xbar_demux_002:src0_endofpacket -> rsp_xbar_mux:sink2_endofpacket
	wire         rsp_xbar_demux_002_src0_valid;                                                                   // rsp_xbar_demux_002:src0_valid -> rsp_xbar_mux:sink2_valid
	wire         rsp_xbar_demux_002_src0_startofpacket;                                                           // rsp_xbar_demux_002:src0_startofpacket -> rsp_xbar_mux:sink2_startofpacket
	wire  [70:0] rsp_xbar_demux_002_src0_data;                                                                    // rsp_xbar_demux_002:src0_data -> rsp_xbar_mux:sink2_data
	wire   [3:0] rsp_xbar_demux_002_src0_channel;                                                                 // rsp_xbar_demux_002:src0_channel -> rsp_xbar_mux:sink2_channel
	wire         rsp_xbar_demux_002_src0_ready;                                                                   // rsp_xbar_mux:sink2_ready -> rsp_xbar_demux_002:src0_ready
	wire         rsp_xbar_demux_002_src1_endofpacket;                                                             // rsp_xbar_demux_002:src1_endofpacket -> rsp_xbar_mux_001:sink2_endofpacket
	wire         rsp_xbar_demux_002_src1_valid;                                                                   // rsp_xbar_demux_002:src1_valid -> rsp_xbar_mux_001:sink2_valid
	wire         rsp_xbar_demux_002_src1_startofpacket;                                                           // rsp_xbar_demux_002:src1_startofpacket -> rsp_xbar_mux_001:sink2_startofpacket
	wire  [70:0] rsp_xbar_demux_002_src1_data;                                                                    // rsp_xbar_demux_002:src1_data -> rsp_xbar_mux_001:sink2_data
	wire   [3:0] rsp_xbar_demux_002_src1_channel;                                                                 // rsp_xbar_demux_002:src1_channel -> rsp_xbar_mux_001:sink2_channel
	wire         rsp_xbar_demux_002_src1_ready;                                                                   // rsp_xbar_mux_001:sink2_ready -> rsp_xbar_demux_002:src1_ready
	wire         rsp_xbar_demux_003_src0_endofpacket;                                                             // rsp_xbar_demux_003:src0_endofpacket -> rsp_xbar_mux:sink3_endofpacket
	wire         rsp_xbar_demux_003_src0_valid;                                                                   // rsp_xbar_demux_003:src0_valid -> rsp_xbar_mux:sink3_valid
	wire         rsp_xbar_demux_003_src0_startofpacket;                                                           // rsp_xbar_demux_003:src0_startofpacket -> rsp_xbar_mux:sink3_startofpacket
	wire  [70:0] rsp_xbar_demux_003_src0_data;                                                                    // rsp_xbar_demux_003:src0_data -> rsp_xbar_mux:sink3_data
	wire   [3:0] rsp_xbar_demux_003_src0_channel;                                                                 // rsp_xbar_demux_003:src0_channel -> rsp_xbar_mux:sink3_channel
	wire         rsp_xbar_demux_003_src0_ready;                                                                   // rsp_xbar_mux:sink3_ready -> rsp_xbar_demux_003:src0_ready
	wire         rsp_xbar_demux_003_src1_endofpacket;                                                             // rsp_xbar_demux_003:src1_endofpacket -> rsp_xbar_mux_001:sink3_endofpacket
	wire         rsp_xbar_demux_003_src1_valid;                                                                   // rsp_xbar_demux_003:src1_valid -> rsp_xbar_mux_001:sink3_valid
	wire         rsp_xbar_demux_003_src1_startofpacket;                                                           // rsp_xbar_demux_003:src1_startofpacket -> rsp_xbar_mux_001:sink3_startofpacket
	wire  [70:0] rsp_xbar_demux_003_src1_data;                                                                    // rsp_xbar_demux_003:src1_data -> rsp_xbar_mux_001:sink3_data
	wire   [3:0] rsp_xbar_demux_003_src1_channel;                                                                 // rsp_xbar_demux_003:src1_channel -> rsp_xbar_mux_001:sink3_channel
	wire         rsp_xbar_demux_003_src1_ready;                                                                   // rsp_xbar_mux_001:sink3_ready -> rsp_xbar_demux_003:src1_ready
	wire         limiter_cmd_src_endofpacket;                                                                     // limiter:cmd_src_endofpacket -> cmd_xbar_demux:sink_endofpacket
	wire         limiter_cmd_src_startofpacket;                                                                   // limiter:cmd_src_startofpacket -> cmd_xbar_demux:sink_startofpacket
	wire  [70:0] limiter_cmd_src_data;                                                                            // limiter:cmd_src_data -> cmd_xbar_demux:sink_data
	wire   [3:0] limiter_cmd_src_channel;                                                                         // limiter:cmd_src_channel -> cmd_xbar_demux:sink_channel
	wire         limiter_cmd_src_ready;                                                                           // cmd_xbar_demux:sink_ready -> limiter:cmd_src_ready
	wire         rsp_xbar_mux_src_endofpacket;                                                                    // rsp_xbar_mux:src_endofpacket -> limiter:rsp_sink_endofpacket
	wire         rsp_xbar_mux_src_valid;                                                                          // rsp_xbar_mux:src_valid -> limiter:rsp_sink_valid
	wire         rsp_xbar_mux_src_startofpacket;                                                                  // rsp_xbar_mux:src_startofpacket -> limiter:rsp_sink_startofpacket
	wire  [70:0] rsp_xbar_mux_src_data;                                                                           // rsp_xbar_mux:src_data -> limiter:rsp_sink_data
	wire   [3:0] rsp_xbar_mux_src_channel;                                                                        // rsp_xbar_mux:src_channel -> limiter:rsp_sink_channel
	wire         rsp_xbar_mux_src_ready;                                                                          // limiter:rsp_sink_ready -> rsp_xbar_mux:src_ready
	wire         limiter_001_cmd_src_endofpacket;                                                                 // limiter_001:cmd_src_endofpacket -> cmd_xbar_demux_001:sink_endofpacket
	wire         limiter_001_cmd_src_startofpacket;                                                               // limiter_001:cmd_src_startofpacket -> cmd_xbar_demux_001:sink_startofpacket
	wire  [70:0] limiter_001_cmd_src_data;                                                                        // limiter_001:cmd_src_data -> cmd_xbar_demux_001:sink_data
	wire   [3:0] limiter_001_cmd_src_channel;                                                                     // limiter_001:cmd_src_channel -> cmd_xbar_demux_001:sink_channel
	wire         limiter_001_cmd_src_ready;                                                                       // cmd_xbar_demux_001:sink_ready -> limiter_001:cmd_src_ready
	wire         rsp_xbar_mux_001_src_endofpacket;                                                                // rsp_xbar_mux_001:src_endofpacket -> limiter_001:rsp_sink_endofpacket
	wire         rsp_xbar_mux_001_src_valid;                                                                      // rsp_xbar_mux_001:src_valid -> limiter_001:rsp_sink_valid
	wire         rsp_xbar_mux_001_src_startofpacket;                                                              // rsp_xbar_mux_001:src_startofpacket -> limiter_001:rsp_sink_startofpacket
	wire  [70:0] rsp_xbar_mux_001_src_data;                                                                       // rsp_xbar_mux_001:src_data -> limiter_001:rsp_sink_data
	wire   [3:0] rsp_xbar_mux_001_src_channel;                                                                    // rsp_xbar_mux_001:src_channel -> limiter_001:rsp_sink_channel
	wire         rsp_xbar_mux_001_src_ready;                                                                      // limiter_001:rsp_sink_ready -> rsp_xbar_mux_001:src_ready
	wire         cmd_xbar_mux_src_endofpacket;                                                                    // cmd_xbar_mux:src_endofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_src_valid;                                                                          // cmd_xbar_mux:src_valid -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_src_startofpacket;                                                                  // cmd_xbar_mux:src_startofpacket -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [70:0] cmd_xbar_mux_src_data;                                                                           // cmd_xbar_mux:src_data -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_src_channel;                                                                        // cmd_xbar_mux:src_channel -> nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_src_ready;                                                                          // nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux:src_ready
	wire         id_router_src_endofpacket;                                                                       // id_router:src_endofpacket -> rsp_xbar_demux:sink_endofpacket
	wire         id_router_src_valid;                                                                             // id_router:src_valid -> rsp_xbar_demux:sink_valid
	wire         id_router_src_startofpacket;                                                                     // id_router:src_startofpacket -> rsp_xbar_demux:sink_startofpacket
	wire  [70:0] id_router_src_data;                                                                              // id_router:src_data -> rsp_xbar_demux:sink_data
	wire   [3:0] id_router_src_channel;                                                                           // id_router:src_channel -> rsp_xbar_demux:sink_channel
	wire         id_router_src_ready;                                                                             // rsp_xbar_demux:sink_ready -> id_router:src_ready
	wire         cmd_xbar_mux_001_src_endofpacket;                                                                // cmd_xbar_mux_001:src_endofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_001_src_valid;                                                                      // cmd_xbar_mux_001:src_valid -> uart_0_s1_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_001_src_startofpacket;                                                              // cmd_xbar_mux_001:src_startofpacket -> uart_0_s1_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [70:0] cmd_xbar_mux_001_src_data;                                                                       // cmd_xbar_mux_001:src_data -> uart_0_s1_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_001_src_channel;                                                                    // cmd_xbar_mux_001:src_channel -> uart_0_s1_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_001_src_ready;                                                                      // uart_0_s1_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_001:src_ready
	wire         id_router_001_src_endofpacket;                                                                   // id_router_001:src_endofpacket -> rsp_xbar_demux_001:sink_endofpacket
	wire         id_router_001_src_valid;                                                                         // id_router_001:src_valid -> rsp_xbar_demux_001:sink_valid
	wire         id_router_001_src_startofpacket;                                                                 // id_router_001:src_startofpacket -> rsp_xbar_demux_001:sink_startofpacket
	wire  [70:0] id_router_001_src_data;                                                                          // id_router_001:src_data -> rsp_xbar_demux_001:sink_data
	wire   [3:0] id_router_001_src_channel;                                                                       // id_router_001:src_channel -> rsp_xbar_demux_001:sink_channel
	wire         id_router_001_src_ready;                                                                         // rsp_xbar_demux_001:sink_ready -> id_router_001:src_ready
	wire         cmd_xbar_mux_002_src_endofpacket;                                                                // cmd_xbar_mux_002:src_endofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_002_src_valid;                                                                      // cmd_xbar_mux_002:src_valid -> sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_002_src_startofpacket;                                                              // cmd_xbar_mux_002:src_startofpacket -> sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [70:0] cmd_xbar_mux_002_src_data;                                                                       // cmd_xbar_mux_002:src_data -> sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_002_src_channel;                                                                    // cmd_xbar_mux_002:src_channel -> sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_002_src_ready;                                                                      // sysid_control_slave_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_002:src_ready
	wire         id_router_002_src_endofpacket;                                                                   // id_router_002:src_endofpacket -> rsp_xbar_demux_002:sink_endofpacket
	wire         id_router_002_src_valid;                                                                         // id_router_002:src_valid -> rsp_xbar_demux_002:sink_valid
	wire         id_router_002_src_startofpacket;                                                                 // id_router_002:src_startofpacket -> rsp_xbar_demux_002:sink_startofpacket
	wire  [70:0] id_router_002_src_data;                                                                          // id_router_002:src_data -> rsp_xbar_demux_002:sink_data
	wire   [3:0] id_router_002_src_channel;                                                                       // id_router_002:src_channel -> rsp_xbar_demux_002:sink_channel
	wire         id_router_002_src_ready;                                                                         // rsp_xbar_demux_002:sink_ready -> id_router_002:src_ready
	wire         cmd_xbar_mux_003_src_endofpacket;                                                                // cmd_xbar_mux_003:src_endofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_003_src_valid;                                                                      // cmd_xbar_mux_003:src_valid -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_003_src_startofpacket;                                                              // cmd_xbar_mux_003:src_startofpacket -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [70:0] cmd_xbar_mux_003_src_data;                                                                       // cmd_xbar_mux_003:src_data -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_003_src_channel;                                                                    // cmd_xbar_mux_003:src_channel -> on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_003_src_ready;                                                                      // on_chip_RAM_s1_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_003:src_ready
	wire         id_router_003_src_endofpacket;                                                                   // id_router_003:src_endofpacket -> rsp_xbar_demux_003:sink_endofpacket
	wire         id_router_003_src_valid;                                                                         // id_router_003:src_valid -> rsp_xbar_demux_003:sink_valid
	wire         id_router_003_src_startofpacket;                                                                 // id_router_003:src_startofpacket -> rsp_xbar_demux_003:sink_startofpacket
	wire  [70:0] id_router_003_src_data;                                                                          // id_router_003:src_data -> rsp_xbar_demux_003:sink_data
	wire   [3:0] id_router_003_src_channel;                                                                       // id_router_003:src_channel -> rsp_xbar_demux_003:sink_channel
	wire         id_router_003_src_ready;                                                                         // rsp_xbar_demux_003:sink_ready -> id_router_003:src_ready
	wire   [3:0] limiter_cmd_valid_data;                                                                          // limiter:cmd_src_valid -> cmd_xbar_demux:sink_valid
	wire   [3:0] limiter_001_cmd_valid_data;                                                                      // limiter_001:cmd_src_valid -> cmd_xbar_demux_001:sink_valid
	wire         irq_mapper_receiver0_irq;                                                                        // uart_0:irq -> irq_mapper:receiver0_irq
	wire  [31:0] nios_cpu_d_irq_irq;                                                                              // irq_mapper:sender_irq -> nios_cpu:d_irq

	nios_cpu_nios_cpu nios_cpu (
		.clk                                   (clk_clk),                                                                 //                       clk.clk
		.reset_n                               (~rst_controller_reset_out_reset),                                         //                   reset_n.reset_n
		.d_address                             (nios_cpu_data_master_address),                                            //               data_master.address
		.d_byteenable                          (nios_cpu_data_master_byteenable),                                         //                          .byteenable
		.d_read                                (nios_cpu_data_master_read),                                               //                          .read
		.d_readdata                            (nios_cpu_data_master_readdata),                                           //                          .readdata
		.d_waitrequest                         (nios_cpu_data_master_waitrequest),                                        //                          .waitrequest
		.d_write                               (nios_cpu_data_master_write),                                              //                          .write
		.d_writedata                           (nios_cpu_data_master_writedata),                                          //                          .writedata
		.jtag_debug_module_debugaccess_to_roms (nios_cpu_data_master_debugaccess),                                        //                          .debugaccess
		.i_address                             (nios_cpu_instruction_master_address),                                     //        instruction_master.address
		.i_read                                (nios_cpu_instruction_master_read),                                        //                          .read
		.i_readdata                            (nios_cpu_instruction_master_readdata),                                    //                          .readdata
		.i_waitrequest                         (nios_cpu_instruction_master_waitrequest),                                 //                          .waitrequest
		.d_irq                                 (nios_cpu_d_irq_irq),                                                      //                     d_irq.irq
		.jtag_debug_module_resetrequest        (),                                                                        //   jtag_debug_module_reset.reset
		.jtag_debug_module_address             (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_address),       //         jtag_debug_module.address
		.jtag_debug_module_begintransfer       (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer), //                          .begintransfer
		.jtag_debug_module_byteenable          (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable),    //                          .byteenable
		.jtag_debug_module_debugaccess         (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess),   //                          .debugaccess
		.jtag_debug_module_readdata            (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata),      //                          .readdata
		.jtag_debug_module_select              (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect),    //                          .chipselect
		.jtag_debug_module_write               (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_write),         //                          .write
		.jtag_debug_module_writedata           (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata),     //                          .writedata
		.no_ci_readra                          ()                                                                         // custom_instruction_master.readra
	);

	nios_cpu_on_chip_RAM on_chip_ram (
		.clk        (clk_clk),                                                  //   clk1.clk
		.address    (on_chip_ram_s1_translator_avalon_anti_slave_0_address),    //     s1.address
		.chipselect (on_chip_ram_s1_translator_avalon_anti_slave_0_chipselect), //       .chipselect
		.clken      (on_chip_ram_s1_translator_avalon_anti_slave_0_clken),      //       .clken
		.readdata   (on_chip_ram_s1_translator_avalon_anti_slave_0_readdata),   //       .readdata
		.write      (on_chip_ram_s1_translator_avalon_anti_slave_0_write),      //       .write
		.writedata  (on_chip_ram_s1_translator_avalon_anti_slave_0_writedata),  //       .writedata
		.byteenable (on_chip_ram_s1_translator_avalon_anti_slave_0_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset)                            // reset1.reset
	);

	nios_cpu_sysid sysid (
		.clock    (clk_clk),                                                     //           clk.clk
		.reset_n  (~rst_controller_reset_out_reset),                             //         reset.reset_n
		.readdata (sysid_control_slave_translator_avalon_anti_slave_0_readdata), // control_slave.readdata
		.address  (sysid_control_slave_translator_avalon_anti_slave_0_address)   //              .address
	);

	nios_cpu_uart_0 uart_0 (
		.clk           (clk_clk),                                                //                 clk.clk
		.reset_n       (~rst_controller_reset_out_reset),                        //               reset.reset_n
		.address       (uart_0_s1_translator_avalon_anti_slave_0_address),       //                  s1.address
		.begintransfer (uart_0_s1_translator_avalon_anti_slave_0_begintransfer), //                    .begintransfer
		.chipselect    (uart_0_s1_translator_avalon_anti_slave_0_chipselect),    //                    .chipselect
		.read_n        (~uart_0_s1_translator_avalon_anti_slave_0_read),         //                    .read_n
		.write_n       (~uart_0_s1_translator_avalon_anti_slave_0_write),        //                    .write_n
		.writedata     (uart_0_s1_translator_avalon_anti_slave_0_writedata),     //                    .writedata
		.readdata      (uart_0_s1_translator_avalon_anti_slave_0_readdata),      //                    .readdata
		.dataavailable (),                                                       //                    .dataavailable
		.readyfordata  (),                                                       //                    .readyfordata
		.rxd           (uart_rxd),                                               // external_connection.export
		.txd           (uart_txd),                                               //                    .export
		.irq           (irq_mapper_receiver0_irq)                                //                 irq.irq
	);

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (16),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (16),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (0),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (1),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) nios_cpu_instruction_master_translator (
		.clk                   (clk_clk),                                                                        //                       clk.clk
		.reset                 (rst_controller_reset_out_reset),                                                 //                     reset.reset
		.uav_address           (nios_cpu_instruction_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount        (nios_cpu_instruction_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read              (nios_cpu_instruction_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write             (nios_cpu_instruction_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest       (nios_cpu_instruction_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid     (nios_cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable        (nios_cpu_instruction_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata          (nios_cpu_instruction_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata         (nios_cpu_instruction_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock              (nios_cpu_instruction_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess       (nios_cpu_instruction_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address            (nios_cpu_instruction_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest        (nios_cpu_instruction_master_waitrequest),                                        //                          .waitrequest
		.av_read               (nios_cpu_instruction_master_read),                                               //                          .read
		.av_readdata           (nios_cpu_instruction_master_readdata),                                           //                          .readdata
		.av_burstcount         (1'b1),                                                                           //               (terminated)
		.av_byteenable         (4'b1111),                                                                        //               (terminated)
		.av_beginbursttransfer (1'b0),                                                                           //               (terminated)
		.av_begintransfer      (1'b0),                                                                           //               (terminated)
		.av_chipselect         (1'b0),                                                                           //               (terminated)
		.av_readdatavalid      (),                                                                               //               (terminated)
		.av_write              (1'b0),                                                                           //               (terminated)
		.av_writedata          (32'b00000000000000000000000000000000),                                           //               (terminated)
		.av_lock               (1'b0),                                                                           //               (terminated)
		.av_debugaccess        (1'b0),                                                                           //               (terminated)
		.uav_clken             (),                                                                               //               (terminated)
		.av_clken              (1'b1)                                                                            //               (terminated)
	);

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (16),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (16),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (1)
	) nios_cpu_data_master_translator (
		.clk                   (clk_clk),                                                                 //                       clk.clk
		.reset                 (rst_controller_reset_out_reset),                                          //                     reset.reset
		.uav_address           (nios_cpu_data_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount        (nios_cpu_data_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read              (nios_cpu_data_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write             (nios_cpu_data_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest       (nios_cpu_data_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid     (nios_cpu_data_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable        (nios_cpu_data_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata          (nios_cpu_data_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata         (nios_cpu_data_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock              (nios_cpu_data_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess       (nios_cpu_data_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address            (nios_cpu_data_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest        (nios_cpu_data_master_waitrequest),                                        //                          .waitrequest
		.av_byteenable         (nios_cpu_data_master_byteenable),                                         //                          .byteenable
		.av_read               (nios_cpu_data_master_read),                                               //                          .read
		.av_readdata           (nios_cpu_data_master_readdata),                                           //                          .readdata
		.av_write              (nios_cpu_data_master_write),                                              //                          .write
		.av_writedata          (nios_cpu_data_master_writedata),                                          //                          .writedata
		.av_debugaccess        (nios_cpu_data_master_debugaccess),                                        //                          .debugaccess
		.av_burstcount         (1'b1),                                                                    //               (terminated)
		.av_beginbursttransfer (1'b0),                                                                    //               (terminated)
		.av_begintransfer      (1'b0),                                                                    //               (terminated)
		.av_chipselect         (1'b0),                                                                    //               (terminated)
		.av_readdatavalid      (),                                                                        //               (terminated)
		.av_lock               (1'b0),                                                                    //               (terminated)
		.uav_clken             (),                                                                        //               (terminated)
		.av_clken              (1'b1)                                                                     //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (9),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (16),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (1),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) nios_cpu_jtag_debug_module_translator (
		.clk                   (clk_clk),                                                                               //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                                        //                    reset.reset
		.uav_address           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_lock              (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_lock),          //                         .lock
		.uav_debugaccess       (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_readdata           (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_begintransfer      (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer),               //                         .begintransfer
		.av_byteenable         (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable),                  //                         .byteenable
		.av_chipselect         (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_debugaccess        (nios_cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess),                 //                         .debugaccess
		.av_read               (),                                                                                      //              (terminated)
		.av_beginbursttransfer (),                                                                                      //              (terminated)
		.av_burstcount         (),                                                                                      //              (terminated)
		.av_readdatavalid      (1'b0),                                                                                  //              (terminated)
		.av_waitrequest        (1'b0),                                                                                  //              (terminated)
		.av_writebyteenable    (),                                                                                      //              (terminated)
		.av_lock               (),                                                                                      //              (terminated)
		.av_clken              (),                                                                                      //              (terminated)
		.uav_clken             (1'b0),                                                                                  //              (terminated)
		.av_outputenable       ()                                                                                       //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (3),
		.AV_DATA_W                      (16),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (1),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (16),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (1),
		.AV_WRITE_WAIT_CYCLES           (1),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) uart_0_s1_translator (
		.clk                   (clk_clk),                                                              //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                       //                    reset.reset
		.uav_address           (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_lock              (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_lock),          //                         .lock
		.uav_debugaccess       (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (uart_0_s1_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (uart_0_s1_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_read               (uart_0_s1_translator_avalon_anti_slave_0_read),                        //                         .read
		.av_readdata           (uart_0_s1_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (uart_0_s1_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_begintransfer      (uart_0_s1_translator_avalon_anti_slave_0_begintransfer),               //                         .begintransfer
		.av_chipselect         (uart_0_s1_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_beginbursttransfer (),                                                                     //              (terminated)
		.av_burstcount         (),                                                                     //              (terminated)
		.av_byteenable         (),                                                                     //              (terminated)
		.av_readdatavalid      (1'b0),                                                                 //              (terminated)
		.av_waitrequest        (1'b0),                                                                 //              (terminated)
		.av_writebyteenable    (),                                                                     //              (terminated)
		.av_lock               (),                                                                     //              (terminated)
		.av_clken              (),                                                                     //              (terminated)
		.uav_clken             (1'b0),                                                                 //              (terminated)
		.av_debugaccess        (),                                                                     //              (terminated)
		.av_outputenable       ()                                                                      //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (1),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (16),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (1),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) sysid_control_slave_translator (
		.clk                   (clk_clk),                                                                        //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                                 //                    reset.reset
		.uav_address           (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_lock              (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_lock),          //                         .lock
		.uav_debugaccess       (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (sysid_control_slave_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_readdata           (sysid_control_slave_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_write              (),                                                                               //              (terminated)
		.av_read               (),                                                                               //              (terminated)
		.av_writedata          (),                                                                               //              (terminated)
		.av_begintransfer      (),                                                                               //              (terminated)
		.av_beginbursttransfer (),                                                                               //              (terminated)
		.av_burstcount         (),                                                                               //              (terminated)
		.av_byteenable         (),                                                                               //              (terminated)
		.av_readdatavalid      (1'b0),                                                                           //              (terminated)
		.av_waitrequest        (1'b0),                                                                           //              (terminated)
		.av_writebyteenable    (),                                                                               //              (terminated)
		.av_lock               (),                                                                               //              (terminated)
		.av_chipselect         (),                                                                               //              (terminated)
		.av_clken              (),                                                                               //              (terminated)
		.uav_clken             (1'b0),                                                                           //              (terminated)
		.av_debugaccess        (),                                                                               //              (terminated)
		.av_outputenable       ()                                                                                //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (12),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (16),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) on_chip_ram_s1_translator (
		.clk                   (clk_clk),                                                                   //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                            //                    reset.reset
		.uav_address           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_lock              (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_lock),          //                         .lock
		.uav_debugaccess       (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (on_chip_ram_s1_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (on_chip_ram_s1_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_readdata           (on_chip_ram_s1_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (on_chip_ram_s1_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_byteenable         (on_chip_ram_s1_translator_avalon_anti_slave_0_byteenable),                  //                         .byteenable
		.av_chipselect         (on_chip_ram_s1_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_clken              (on_chip_ram_s1_translator_avalon_anti_slave_0_clken),                       //                         .clken
		.av_read               (),                                                                          //              (terminated)
		.av_begintransfer      (),                                                                          //              (terminated)
		.av_beginbursttransfer (),                                                                          //              (terminated)
		.av_burstcount         (),                                                                          //              (terminated)
		.av_readdatavalid      (1'b0),                                                                      //              (terminated)
		.av_waitrequest        (1'b0),                                                                      //              (terminated)
		.av_writebyteenable    (),                                                                          //              (terminated)
		.av_lock               (),                                                                          //              (terminated)
		.uav_clken             (1'b0),                                                                      //              (terminated)
		.av_debugaccess        (),                                                                          //              (terminated)
		.av_outputenable       ()                                                                           //              (terminated)
	);

	altera_merlin_master_agent #(
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.PKT_BEGIN_BURST           (63),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.ST_DATA_W                 (71),
		.ST_CHANNEL_W              (4),
		.AV_BURSTCOUNT_W           (3),
		.SUPPRESS_0_BYTEEN_RSP     (0),
		.ID                        (1),
		.BURSTWRAP_VALUE           (3)
	) nios_cpu_instruction_master_translator_avalon_universal_master_0_agent (
		.clk              (clk_clk),                                                                                 //       clk.clk
		.reset            (rst_controller_reset_out_reset),                                                          // clk_reset.reset
		.av_address       (nios_cpu_instruction_master_translator_avalon_universal_master_0_address),                //        av.address
		.av_write         (nios_cpu_instruction_master_translator_avalon_universal_master_0_write),                  //          .write
		.av_read          (nios_cpu_instruction_master_translator_avalon_universal_master_0_read),                   //          .read
		.av_writedata     (nios_cpu_instruction_master_translator_avalon_universal_master_0_writedata),              //          .writedata
		.av_readdata      (nios_cpu_instruction_master_translator_avalon_universal_master_0_readdata),               //          .readdata
		.av_waitrequest   (nios_cpu_instruction_master_translator_avalon_universal_master_0_waitrequest),            //          .waitrequest
		.av_readdatavalid (nios_cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid),          //          .readdatavalid
		.av_byteenable    (nios_cpu_instruction_master_translator_avalon_universal_master_0_byteenable),             //          .byteenable
		.av_burstcount    (nios_cpu_instruction_master_translator_avalon_universal_master_0_burstcount),             //          .burstcount
		.av_debugaccess   (nios_cpu_instruction_master_translator_avalon_universal_master_0_debugaccess),            //          .debugaccess
		.av_lock          (nios_cpu_instruction_master_translator_avalon_universal_master_0_lock),                   //          .lock
		.cp_valid         (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid),         //        cp.valid
		.cp_data          (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.cp_startofpacket (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.cp_endofpacket   (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.cp_ready         (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready),         //          .ready
		.rp_valid         (limiter_rsp_src_valid),                                                                   //        rp.valid
		.rp_data          (limiter_rsp_src_data),                                                                    //          .data
		.rp_channel       (limiter_rsp_src_channel),                                                                 //          .channel
		.rp_startofpacket (limiter_rsp_src_startofpacket),                                                           //          .startofpacket
		.rp_endofpacket   (limiter_rsp_src_endofpacket),                                                             //          .endofpacket
		.rp_ready         (limiter_rsp_src_ready)                                                                    //          .ready
	);

	altera_merlin_master_agent #(
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.PKT_BEGIN_BURST           (63),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.ST_DATA_W                 (71),
		.ST_CHANNEL_W              (4),
		.AV_BURSTCOUNT_W           (3),
		.SUPPRESS_0_BYTEEN_RSP     (0),
		.ID                        (2),
		.BURSTWRAP_VALUE           (7)
	) nios_cpu_data_master_translator_avalon_universal_master_0_agent (
		.clk              (clk_clk),                                                                          //       clk.clk
		.reset            (rst_controller_reset_out_reset),                                                   // clk_reset.reset
		.av_address       (nios_cpu_data_master_translator_avalon_universal_master_0_address),                //        av.address
		.av_write         (nios_cpu_data_master_translator_avalon_universal_master_0_write),                  //          .write
		.av_read          (nios_cpu_data_master_translator_avalon_universal_master_0_read),                   //          .read
		.av_writedata     (nios_cpu_data_master_translator_avalon_universal_master_0_writedata),              //          .writedata
		.av_readdata      (nios_cpu_data_master_translator_avalon_universal_master_0_readdata),               //          .readdata
		.av_waitrequest   (nios_cpu_data_master_translator_avalon_universal_master_0_waitrequest),            //          .waitrequest
		.av_readdatavalid (nios_cpu_data_master_translator_avalon_universal_master_0_readdatavalid),          //          .readdatavalid
		.av_byteenable    (nios_cpu_data_master_translator_avalon_universal_master_0_byteenable),             //          .byteenable
		.av_burstcount    (nios_cpu_data_master_translator_avalon_universal_master_0_burstcount),             //          .burstcount
		.av_debugaccess   (nios_cpu_data_master_translator_avalon_universal_master_0_debugaccess),            //          .debugaccess
		.av_lock          (nios_cpu_data_master_translator_avalon_universal_master_0_lock),                   //          .lock
		.cp_valid         (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid),         //        cp.valid
		.cp_data          (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.cp_startofpacket (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.cp_endofpacket   (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.cp_ready         (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready),         //          .ready
		.rp_valid         (limiter_001_rsp_src_valid),                                                        //        rp.valid
		.rp_data          (limiter_001_rsp_src_data),                                                         //          .data
		.rp_channel       (limiter_001_rsp_src_channel),                                                      //          .channel
		.rp_startofpacket (limiter_001_rsp_src_startofpacket),                                                //          .startofpacket
		.rp_endofpacket   (limiter_001_rsp_src_endofpacket),                                                  //          .endofpacket
		.rp_ready         (limiter_001_rsp_src_ready)                                                         //          .ready
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (63),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (71),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent (
		.clk                     (clk_clk),                                                                                         //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                                  //       clk_reset.reset
		.m0_address              (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_lock                 (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_lock),                    //                .lock
		.m0_readdata             (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_src_ready),                                                                          //              cp.ready
		.cp_valid                (cmd_xbar_mux_src_valid),                                                                          //                .valid
		.cp_data                 (cmd_xbar_mux_src_data),                                                                           //                .data
		.cp_startofpacket        (cmd_xbar_mux_src_startofpacket),                                                                  //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_src_endofpacket),                                                                    //                .endofpacket
		.cp_channel              (cmd_xbar_mux_src_channel),                                                                        //                .channel
		.rf_sink_ready           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (72),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (clk_clk),                                                                                         //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                                  // clk_reset.reset
		.in_data           (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                                           // (terminated)
		.csr_read          (1'b0),                                                                                            // (terminated)
		.csr_write         (1'b0),                                                                                            // (terminated)
		.csr_readdata      (),                                                                                                // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                            // (terminated)
		.almost_full_data  (),                                                                                                // (terminated)
		.almost_empty_data (),                                                                                                // (terminated)
		.in_empty          (1'b0),                                                                                            // (terminated)
		.out_empty         (),                                                                                                // (terminated)
		.in_error          (1'b0),                                                                                            // (terminated)
		.out_error         (),                                                                                                // (terminated)
		.in_channel        (1'b0),                                                                                            // (terminated)
		.out_channel       ()                                                                                                 // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (63),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (71),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) uart_0_s1_translator_avalon_universal_slave_0_agent (
		.clk                     (clk_clk),                                                                        //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                 //       clk_reset.reset
		.m0_address              (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_lock                 (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_lock),                    //                .lock
		.m0_readdata             (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (uart_0_s1_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_001_src_ready),                                                     //              cp.ready
		.cp_valid                (cmd_xbar_mux_001_src_valid),                                                     //                .valid
		.cp_data                 (cmd_xbar_mux_001_src_data),                                                      //                .data
		.cp_startofpacket        (cmd_xbar_mux_001_src_startofpacket),                                             //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_001_src_endofpacket),                                               //                .endofpacket
		.cp_channel              (cmd_xbar_mux_001_src_channel),                                                   //                .channel
		.rf_sink_ready           (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (uart_0_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (72),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (clk_clk),                                                                        //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                 // clk_reset.reset
		.in_data           (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (uart_0_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (uart_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                          // (terminated)
		.csr_read          (1'b0),                                                                           // (terminated)
		.csr_write         (1'b0),                                                                           // (terminated)
		.csr_readdata      (),                                                                               // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                           // (terminated)
		.almost_full_data  (),                                                                               // (terminated)
		.almost_empty_data (),                                                                               // (terminated)
		.in_empty          (1'b0),                                                                           // (terminated)
		.out_empty         (),                                                                               // (terminated)
		.in_error          (1'b0),                                                                           // (terminated)
		.out_error         (),                                                                               // (terminated)
		.in_channel        (1'b0),                                                                           // (terminated)
		.out_channel       ()                                                                                // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (63),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (71),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) sysid_control_slave_translator_avalon_universal_slave_0_agent (
		.clk                     (clk_clk),                                                                                  //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                           //       clk_reset.reset
		.m0_address              (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_lock                 (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_lock),                    //                .lock
		.m0_readdata             (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (sysid_control_slave_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_002_src_ready),                                                               //              cp.ready
		.cp_valid                (cmd_xbar_mux_002_src_valid),                                                               //                .valid
		.cp_data                 (cmd_xbar_mux_002_src_data),                                                                //                .data
		.cp_startofpacket        (cmd_xbar_mux_002_src_startofpacket),                                                       //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_002_src_endofpacket),                                                         //                .endofpacket
		.cp_channel              (cmd_xbar_mux_002_src_channel),                                                             //                .channel
		.rf_sink_ready           (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (sysid_control_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (72),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (clk_clk),                                                                                  //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                           // clk_reset.reset
		.in_data           (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (sysid_control_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                                    // (terminated)
		.csr_read          (1'b0),                                                                                     // (terminated)
		.csr_write         (1'b0),                                                                                     // (terminated)
		.csr_readdata      (),                                                                                         // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                     // (terminated)
		.almost_full_data  (),                                                                                         // (terminated)
		.almost_empty_data (),                                                                                         // (terminated)
		.in_empty          (1'b0),                                                                                     // (terminated)
		.out_empty         (),                                                                                         // (terminated)
		.in_error          (1'b0),                                                                                     // (terminated)
		.out_error         (),                                                                                         // (terminated)
		.in_channel        (1'b0),                                                                                     // (terminated)
		.out_channel       ()                                                                                          // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (63),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (51),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (52),
		.PKT_TRANS_POSTED          (53),
		.PKT_TRANS_WRITE           (54),
		.PKT_TRANS_READ            (55),
		.PKT_TRANS_LOCK            (56),
		.PKT_SRC_ID_H              (66),
		.PKT_SRC_ID_L              (64),
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_BURSTWRAP_H           (62),
		.PKT_BURSTWRAP_L           (60),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_PROTECTION_H          (70),
		.PKT_PROTECTION_L          (70),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (71),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) on_chip_ram_s1_translator_avalon_universal_slave_0_agent (
		.clk                     (clk_clk),                                                                             //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                      //       clk_reset.reset
		.m0_address              (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_lock                 (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_lock),                    //                .lock
		.m0_readdata             (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_003_src_ready),                                                          //              cp.ready
		.cp_valid                (cmd_xbar_mux_003_src_valid),                                                          //                .valid
		.cp_data                 (cmd_xbar_mux_003_src_data),                                                           //                .data
		.cp_startofpacket        (cmd_xbar_mux_003_src_startofpacket),                                                  //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_003_src_endofpacket),                                                    //                .endofpacket
		.cp_channel              (cmd_xbar_mux_003_src_channel),                                                        //                .channel
		.rf_sink_ready           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (72),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (clk_clk),                                                                             //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                      // clk_reset.reset
		.in_data           (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                               // (terminated)
		.csr_read          (1'b0),                                                                                // (terminated)
		.csr_write         (1'b0),                                                                                // (terminated)
		.csr_readdata      (),                                                                                    // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                // (terminated)
		.almost_full_data  (),                                                                                    // (terminated)
		.almost_empty_data (),                                                                                    // (terminated)
		.in_empty          (1'b0),                                                                                // (terminated)
		.out_empty         (),                                                                                    // (terminated)
		.in_error          (1'b0),                                                                                // (terminated)
		.out_error         (),                                                                                    // (terminated)
		.in_channel        (1'b0),                                                                                // (terminated)
		.out_channel       ()                                                                                     // (terminated)
	);

	nios_cpu_addr_router addr_router (
		.sink_ready         (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready),         //      sink.ready
		.sink_valid         (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid),         //          .valid
		.sink_data          (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.sink_startofpacket (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.sink_endofpacket   (nios_cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                                                 //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                          // clk_reset.reset
		.src_ready          (addr_router_src_ready),                                                                   //       src.ready
		.src_valid          (addr_router_src_valid),                                                                   //          .valid
		.src_data           (addr_router_src_data),                                                                    //          .data
		.src_channel        (addr_router_src_channel),                                                                 //          .channel
		.src_startofpacket  (addr_router_src_startofpacket),                                                           //          .startofpacket
		.src_endofpacket    (addr_router_src_endofpacket)                                                              //          .endofpacket
	);

	nios_cpu_addr_router addr_router_001 (
		.sink_ready         (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready),         //      sink.ready
		.sink_valid         (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid),         //          .valid
		.sink_data          (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.sink_startofpacket (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.sink_endofpacket   (nios_cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                                          //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                   // clk_reset.reset
		.src_ready          (addr_router_001_src_ready),                                                        //       src.ready
		.src_valid          (addr_router_001_src_valid),                                                        //          .valid
		.src_data           (addr_router_001_src_data),                                                         //          .data
		.src_channel        (addr_router_001_src_channel),                                                      //          .channel
		.src_startofpacket  (addr_router_001_src_startofpacket),                                                //          .startofpacket
		.src_endofpacket    (addr_router_001_src_endofpacket)                                                   //          .endofpacket
	);

	nios_cpu_id_router id_router (
		.sink_ready         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (nios_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                                               //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                        // clk_reset.reset
		.src_ready          (id_router_src_ready),                                                                   //       src.ready
		.src_valid          (id_router_src_valid),                                                                   //          .valid
		.src_data           (id_router_src_data),                                                                    //          .data
		.src_channel        (id_router_src_channel),                                                                 //          .channel
		.src_startofpacket  (id_router_src_startofpacket),                                                           //          .startofpacket
		.src_endofpacket    (id_router_src_endofpacket)                                                              //          .endofpacket
	);

	nios_cpu_id_router id_router_001 (
		.sink_ready         (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (uart_0_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                              //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                       // clk_reset.reset
		.src_ready          (id_router_001_src_ready),                                              //       src.ready
		.src_valid          (id_router_001_src_valid),                                              //          .valid
		.src_data           (id_router_001_src_data),                                               //          .data
		.src_channel        (id_router_001_src_channel),                                            //          .channel
		.src_startofpacket  (id_router_001_src_startofpacket),                                      //          .startofpacket
		.src_endofpacket    (id_router_001_src_endofpacket)                                         //          .endofpacket
	);

	nios_cpu_id_router id_router_002 (
		.sink_ready         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (sysid_control_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                                        //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                 // clk_reset.reset
		.src_ready          (id_router_002_src_ready),                                                        //       src.ready
		.src_valid          (id_router_002_src_valid),                                                        //          .valid
		.src_data           (id_router_002_src_data),                                                         //          .data
		.src_channel        (id_router_002_src_channel),                                                      //          .channel
		.src_startofpacket  (id_router_002_src_startofpacket),                                                //          .startofpacket
		.src_endofpacket    (id_router_002_src_endofpacket)                                                   //          .endofpacket
	);

	nios_cpu_id_router id_router_003 (
		.sink_ready         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (on_chip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (clk_clk),                                                                   //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                            // clk_reset.reset
		.src_ready          (id_router_003_src_ready),                                                   //       src.ready
		.src_valid          (id_router_003_src_valid),                                                   //          .valid
		.src_data           (id_router_003_src_data),                                                    //          .data
		.src_channel        (id_router_003_src_channel),                                                 //          .channel
		.src_startofpacket  (id_router_003_src_startofpacket),                                           //          .startofpacket
		.src_endofpacket    (id_router_003_src_endofpacket)                                              //          .endofpacket
	);

	altera_merlin_traffic_limiter #(
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_TRANS_POSTED          (53),
		.MAX_OUTSTANDING_RESPONSES (5),
		.PIPELINED                 (0),
		.ST_DATA_W                 (71),
		.ST_CHANNEL_W              (4),
		.VALID_WIDTH               (4),
		.ENFORCE_ORDER             (0),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32)
	) limiter (
		.clk                    (clk_clk),                        //       clk.clk
		.reset                  (rst_controller_reset_out_reset), // clk_reset.reset
		.cmd_sink_ready         (addr_router_src_ready),          //  cmd_sink.ready
		.cmd_sink_valid         (addr_router_src_valid),          //          .valid
		.cmd_sink_data          (addr_router_src_data),           //          .data
		.cmd_sink_channel       (addr_router_src_channel),        //          .channel
		.cmd_sink_startofpacket (addr_router_src_startofpacket),  //          .startofpacket
		.cmd_sink_endofpacket   (addr_router_src_endofpacket),    //          .endofpacket
		.cmd_src_ready          (limiter_cmd_src_ready),          //   cmd_src.ready
		.cmd_src_data           (limiter_cmd_src_data),           //          .data
		.cmd_src_channel        (limiter_cmd_src_channel),        //          .channel
		.cmd_src_startofpacket  (limiter_cmd_src_startofpacket),  //          .startofpacket
		.cmd_src_endofpacket    (limiter_cmd_src_endofpacket),    //          .endofpacket
		.rsp_sink_ready         (rsp_xbar_mux_src_ready),         //  rsp_sink.ready
		.rsp_sink_valid         (rsp_xbar_mux_src_valid),         //          .valid
		.rsp_sink_channel       (rsp_xbar_mux_src_channel),       //          .channel
		.rsp_sink_data          (rsp_xbar_mux_src_data),          //          .data
		.rsp_sink_startofpacket (rsp_xbar_mux_src_startofpacket), //          .startofpacket
		.rsp_sink_endofpacket   (rsp_xbar_mux_src_endofpacket),   //          .endofpacket
		.rsp_src_ready          (limiter_rsp_src_ready),          //   rsp_src.ready
		.rsp_src_valid          (limiter_rsp_src_valid),          //          .valid
		.rsp_src_data           (limiter_rsp_src_data),           //          .data
		.rsp_src_channel        (limiter_rsp_src_channel),        //          .channel
		.rsp_src_startofpacket  (limiter_rsp_src_startofpacket),  //          .startofpacket
		.rsp_src_endofpacket    (limiter_rsp_src_endofpacket),    //          .endofpacket
		.cmd_src_valid          (limiter_cmd_valid_data)          // cmd_valid.data
	);

	altera_merlin_traffic_limiter #(
		.PKT_DEST_ID_H             (69),
		.PKT_DEST_ID_L             (67),
		.PKT_TRANS_POSTED          (53),
		.MAX_OUTSTANDING_RESPONSES (5),
		.PIPELINED                 (0),
		.ST_DATA_W                 (71),
		.ST_CHANNEL_W              (4),
		.VALID_WIDTH               (4),
		.ENFORCE_ORDER             (0),
		.PKT_BYTE_CNT_H            (59),
		.PKT_BYTE_CNT_L            (57),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32)
	) limiter_001 (
		.clk                    (clk_clk),                            //       clk.clk
		.reset                  (rst_controller_reset_out_reset),     // clk_reset.reset
		.cmd_sink_ready         (addr_router_001_src_ready),          //  cmd_sink.ready
		.cmd_sink_valid         (addr_router_001_src_valid),          //          .valid
		.cmd_sink_data          (addr_router_001_src_data),           //          .data
		.cmd_sink_channel       (addr_router_001_src_channel),        //          .channel
		.cmd_sink_startofpacket (addr_router_001_src_startofpacket),  //          .startofpacket
		.cmd_sink_endofpacket   (addr_router_001_src_endofpacket),    //          .endofpacket
		.cmd_src_ready          (limiter_001_cmd_src_ready),          //   cmd_src.ready
		.cmd_src_data           (limiter_001_cmd_src_data),           //          .data
		.cmd_src_channel        (limiter_001_cmd_src_channel),        //          .channel
		.cmd_src_startofpacket  (limiter_001_cmd_src_startofpacket),  //          .startofpacket
		.cmd_src_endofpacket    (limiter_001_cmd_src_endofpacket),    //          .endofpacket
		.rsp_sink_ready         (rsp_xbar_mux_001_src_ready),         //  rsp_sink.ready
		.rsp_sink_valid         (rsp_xbar_mux_001_src_valid),         //          .valid
		.rsp_sink_channel       (rsp_xbar_mux_001_src_channel),       //          .channel
		.rsp_sink_data          (rsp_xbar_mux_001_src_data),          //          .data
		.rsp_sink_startofpacket (rsp_xbar_mux_001_src_startofpacket), //          .startofpacket
		.rsp_sink_endofpacket   (rsp_xbar_mux_001_src_endofpacket),   //          .endofpacket
		.rsp_src_ready          (limiter_001_rsp_src_ready),          //   rsp_src.ready
		.rsp_src_valid          (limiter_001_rsp_src_valid),          //          .valid
		.rsp_src_data           (limiter_001_rsp_src_data),           //          .data
		.rsp_src_channel        (limiter_001_rsp_src_channel),        //          .channel
		.rsp_src_startofpacket  (limiter_001_rsp_src_startofpacket),  //          .startofpacket
		.rsp_src_endofpacket    (limiter_001_rsp_src_endofpacket),    //          .endofpacket
		.cmd_src_valid          (limiter_001_cmd_valid_data)          // cmd_valid.data
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS        (1),
		.OUTPUT_RESET_SYNC_EDGES ("deassert"),
		.SYNC_DEPTH              (2)
	) rst_controller (
		.reset_in0  (~reset_reset_n),                 // reset_in0.reset
		.clk        (clk_clk),                        //       clk.clk
		.reset_out  (rst_controller_reset_out_reset), // reset_out.reset
		.reset_in1  (1'b0),                           // (terminated)
		.reset_in2  (1'b0),                           // (terminated)
		.reset_in3  (1'b0),                           // (terminated)
		.reset_in4  (1'b0),                           // (terminated)
		.reset_in5  (1'b0),                           // (terminated)
		.reset_in6  (1'b0),                           // (terminated)
		.reset_in7  (1'b0),                           // (terminated)
		.reset_in8  (1'b0),                           // (terminated)
		.reset_in9  (1'b0),                           // (terminated)
		.reset_in10 (1'b0),                           // (terminated)
		.reset_in11 (1'b0),                           // (terminated)
		.reset_in12 (1'b0),                           // (terminated)
		.reset_in13 (1'b0),                           // (terminated)
		.reset_in14 (1'b0),                           // (terminated)
		.reset_in15 (1'b0)                            // (terminated)
	);

	nios_cpu_cmd_xbar_demux cmd_xbar_demux (
		.clk                (clk_clk),                           //        clk.clk
		.reset              (rst_controller_reset_out_reset),    //  clk_reset.reset
		.sink_ready         (limiter_cmd_src_ready),             //       sink.ready
		.sink_channel       (limiter_cmd_src_channel),           //           .channel
		.sink_data          (limiter_cmd_src_data),              //           .data
		.sink_startofpacket (limiter_cmd_src_startofpacket),     //           .startofpacket
		.sink_endofpacket   (limiter_cmd_src_endofpacket),       //           .endofpacket
		.sink_valid         (limiter_cmd_valid_data),            // sink_valid.data
		.src0_ready         (cmd_xbar_demux_src0_ready),         //       src0.ready
		.src0_valid         (cmd_xbar_demux_src0_valid),         //           .valid
		.src0_data          (cmd_xbar_demux_src0_data),          //           .data
		.src0_channel       (cmd_xbar_demux_src0_channel),       //           .channel
		.src0_startofpacket (cmd_xbar_demux_src0_startofpacket), //           .startofpacket
		.src0_endofpacket   (cmd_xbar_demux_src0_endofpacket),   //           .endofpacket
		.src1_ready         (cmd_xbar_demux_src1_ready),         //       src1.ready
		.src1_valid         (cmd_xbar_demux_src1_valid),         //           .valid
		.src1_data          (cmd_xbar_demux_src1_data),          //           .data
		.src1_channel       (cmd_xbar_demux_src1_channel),       //           .channel
		.src1_startofpacket (cmd_xbar_demux_src1_startofpacket), //           .startofpacket
		.src1_endofpacket   (cmd_xbar_demux_src1_endofpacket),   //           .endofpacket
		.src2_ready         (cmd_xbar_demux_src2_ready),         //       src2.ready
		.src2_valid         (cmd_xbar_demux_src2_valid),         //           .valid
		.src2_data          (cmd_xbar_demux_src2_data),          //           .data
		.src2_channel       (cmd_xbar_demux_src2_channel),       //           .channel
		.src2_startofpacket (cmd_xbar_demux_src2_startofpacket), //           .startofpacket
		.src2_endofpacket   (cmd_xbar_demux_src2_endofpacket),   //           .endofpacket
		.src3_ready         (cmd_xbar_demux_src3_ready),         //       src3.ready
		.src3_valid         (cmd_xbar_demux_src3_valid),         //           .valid
		.src3_data          (cmd_xbar_demux_src3_data),          //           .data
		.src3_channel       (cmd_xbar_demux_src3_channel),       //           .channel
		.src3_startofpacket (cmd_xbar_demux_src3_startofpacket), //           .startofpacket
		.src3_endofpacket   (cmd_xbar_demux_src3_endofpacket)    //           .endofpacket
	);

	nios_cpu_cmd_xbar_demux cmd_xbar_demux_001 (
		.clk                (clk_clk),                               //        clk.clk
		.reset              (rst_controller_reset_out_reset),        //  clk_reset.reset
		.sink_ready         (limiter_001_cmd_src_ready),             //       sink.ready
		.sink_channel       (limiter_001_cmd_src_channel),           //           .channel
		.sink_data          (limiter_001_cmd_src_data),              //           .data
		.sink_startofpacket (limiter_001_cmd_src_startofpacket),     //           .startofpacket
		.sink_endofpacket   (limiter_001_cmd_src_endofpacket),       //           .endofpacket
		.sink_valid         (limiter_001_cmd_valid_data),            // sink_valid.data
		.src0_ready         (cmd_xbar_demux_001_src0_ready),         //       src0.ready
		.src0_valid         (cmd_xbar_demux_001_src0_valid),         //           .valid
		.src0_data          (cmd_xbar_demux_001_src0_data),          //           .data
		.src0_channel       (cmd_xbar_demux_001_src0_channel),       //           .channel
		.src0_startofpacket (cmd_xbar_demux_001_src0_startofpacket), //           .startofpacket
		.src0_endofpacket   (cmd_xbar_demux_001_src0_endofpacket),   //           .endofpacket
		.src1_ready         (cmd_xbar_demux_001_src1_ready),         //       src1.ready
		.src1_valid         (cmd_xbar_demux_001_src1_valid),         //           .valid
		.src1_data          (cmd_xbar_demux_001_src1_data),          //           .data
		.src1_channel       (cmd_xbar_demux_001_src1_channel),       //           .channel
		.src1_startofpacket (cmd_xbar_demux_001_src1_startofpacket), //           .startofpacket
		.src1_endofpacket   (cmd_xbar_demux_001_src1_endofpacket),   //           .endofpacket
		.src2_ready         (cmd_xbar_demux_001_src2_ready),         //       src2.ready
		.src2_valid         (cmd_xbar_demux_001_src2_valid),         //           .valid
		.src2_data          (cmd_xbar_demux_001_src2_data),          //           .data
		.src2_channel       (cmd_xbar_demux_001_src2_channel),       //           .channel
		.src2_startofpacket (cmd_xbar_demux_001_src2_startofpacket), //           .startofpacket
		.src2_endofpacket   (cmd_xbar_demux_001_src2_endofpacket),   //           .endofpacket
		.src3_ready         (cmd_xbar_demux_001_src3_ready),         //       src3.ready
		.src3_valid         (cmd_xbar_demux_001_src3_valid),         //           .valid
		.src3_data          (cmd_xbar_demux_001_src3_data),          //           .data
		.src3_channel       (cmd_xbar_demux_001_src3_channel),       //           .channel
		.src3_startofpacket (cmd_xbar_demux_001_src3_startofpacket), //           .startofpacket
		.src3_endofpacket   (cmd_xbar_demux_001_src3_endofpacket)    //           .endofpacket
	);

	nios_cpu_cmd_xbar_mux cmd_xbar_mux (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_src_ready),                //       src.ready
		.src_valid           (cmd_xbar_mux_src_valid),                //          .valid
		.src_data            (cmd_xbar_mux_src_data),                 //          .data
		.src_channel         (cmd_xbar_mux_src_channel),              //          .channel
		.src_startofpacket   (cmd_xbar_mux_src_startofpacket),        //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_src_endofpacket),          //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src0_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src0_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src0_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src0_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src0_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src0_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src0_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src0_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src0_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src0_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src0_endofpacket)    //          .endofpacket
	);

	nios_cpu_cmd_xbar_mux cmd_xbar_mux_001 (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_001_src_ready),            //       src.ready
		.src_valid           (cmd_xbar_mux_001_src_valid),            //          .valid
		.src_data            (cmd_xbar_mux_001_src_data),             //          .data
		.src_channel         (cmd_xbar_mux_001_src_channel),          //          .channel
		.src_startofpacket   (cmd_xbar_mux_001_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_001_src_endofpacket),      //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src1_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src1_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src1_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src1_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src1_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src1_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src1_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src1_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src1_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src1_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_cmd_xbar_mux cmd_xbar_mux_002 (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_002_src_ready),            //       src.ready
		.src_valid           (cmd_xbar_mux_002_src_valid),            //          .valid
		.src_data            (cmd_xbar_mux_002_src_data),             //          .data
		.src_channel         (cmd_xbar_mux_002_src_channel),          //          .channel
		.src_startofpacket   (cmd_xbar_mux_002_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_002_src_endofpacket),      //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src2_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src2_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src2_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src2_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src2_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src2_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src2_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src2_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src2_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src2_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src2_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src2_endofpacket)    //          .endofpacket
	);

	nios_cpu_cmd_xbar_mux cmd_xbar_mux_003 (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_003_src_ready),            //       src.ready
		.src_valid           (cmd_xbar_mux_003_src_valid),            //          .valid
		.src_data            (cmd_xbar_mux_003_src_data),             //          .data
		.src_channel         (cmd_xbar_mux_003_src_channel),          //          .channel
		.src_startofpacket   (cmd_xbar_mux_003_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_003_src_endofpacket),      //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src3_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src3_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src3_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src3_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src3_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src3_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src3_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src3_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src3_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src3_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src3_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src3_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_demux rsp_xbar_demux (
		.clk                (clk_clk),                           //       clk.clk
		.reset              (rst_controller_reset_out_reset),    // clk_reset.reset
		.sink_ready         (id_router_src_ready),               //      sink.ready
		.sink_channel       (id_router_src_channel),             //          .channel
		.sink_data          (id_router_src_data),                //          .data
		.sink_startofpacket (id_router_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_demux rsp_xbar_demux_001 (
		.clk                (clk_clk),                               //       clk.clk
		.reset              (rst_controller_reset_out_reset),        // clk_reset.reset
		.sink_ready         (id_router_001_src_ready),               //      sink.ready
		.sink_channel       (id_router_001_src_channel),             //          .channel
		.sink_data          (id_router_001_src_data),                //          .data
		.sink_startofpacket (id_router_001_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_001_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_001_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_001_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_001_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_001_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_001_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_001_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_001_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_001_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_001_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_001_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_001_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_demux rsp_xbar_demux_002 (
		.clk                (clk_clk),                               //       clk.clk
		.reset              (rst_controller_reset_out_reset),        // clk_reset.reset
		.sink_ready         (id_router_002_src_ready),               //      sink.ready
		.sink_channel       (id_router_002_src_channel),             //          .channel
		.sink_data          (id_router_002_src_data),                //          .data
		.sink_startofpacket (id_router_002_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_002_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_002_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_002_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_002_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_002_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_002_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_002_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_002_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_002_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_002_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_002_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_002_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_002_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_002_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_demux rsp_xbar_demux_003 (
		.clk                (clk_clk),                               //       clk.clk
		.reset              (rst_controller_reset_out_reset),        // clk_reset.reset
		.sink_ready         (id_router_003_src_ready),               //      sink.ready
		.sink_channel       (id_router_003_src_channel),             //          .channel
		.sink_data          (id_router_003_src_data),                //          .data
		.sink_startofpacket (id_router_003_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_003_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_003_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_003_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_003_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_003_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_003_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_003_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_003_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_003_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_003_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_003_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_003_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_003_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_003_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_mux rsp_xbar_mux (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (rsp_xbar_mux_src_ready),                //       src.ready
		.src_valid           (rsp_xbar_mux_src_valid),                //          .valid
		.src_data            (rsp_xbar_mux_src_data),                 //          .data
		.src_channel         (rsp_xbar_mux_src_channel),              //          .channel
		.src_startofpacket   (rsp_xbar_mux_src_startofpacket),        //          .startofpacket
		.src_endofpacket     (rsp_xbar_mux_src_endofpacket),          //          .endofpacket
		.sink0_ready         (rsp_xbar_demux_src0_ready),             //     sink0.ready
		.sink0_valid         (rsp_xbar_demux_src0_valid),             //          .valid
		.sink0_channel       (rsp_xbar_demux_src0_channel),           //          .channel
		.sink0_data          (rsp_xbar_demux_src0_data),              //          .data
		.sink0_startofpacket (rsp_xbar_demux_src0_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (rsp_xbar_demux_src0_endofpacket),       //          .endofpacket
		.sink1_ready         (rsp_xbar_demux_001_src0_ready),         //     sink1.ready
		.sink1_valid         (rsp_xbar_demux_001_src0_valid),         //          .valid
		.sink1_channel       (rsp_xbar_demux_001_src0_channel),       //          .channel
		.sink1_data          (rsp_xbar_demux_001_src0_data),          //          .data
		.sink1_startofpacket (rsp_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.sink1_endofpacket   (rsp_xbar_demux_001_src0_endofpacket),   //          .endofpacket
		.sink2_ready         (rsp_xbar_demux_002_src0_ready),         //     sink2.ready
		.sink2_valid         (rsp_xbar_demux_002_src0_valid),         //          .valid
		.sink2_channel       (rsp_xbar_demux_002_src0_channel),       //          .channel
		.sink2_data          (rsp_xbar_demux_002_src0_data),          //          .data
		.sink2_startofpacket (rsp_xbar_demux_002_src0_startofpacket), //          .startofpacket
		.sink2_endofpacket   (rsp_xbar_demux_002_src0_endofpacket),   //          .endofpacket
		.sink3_ready         (rsp_xbar_demux_003_src0_ready),         //     sink3.ready
		.sink3_valid         (rsp_xbar_demux_003_src0_valid),         //          .valid
		.sink3_channel       (rsp_xbar_demux_003_src0_channel),       //          .channel
		.sink3_data          (rsp_xbar_demux_003_src0_data),          //          .data
		.sink3_startofpacket (rsp_xbar_demux_003_src0_startofpacket), //          .startofpacket
		.sink3_endofpacket   (rsp_xbar_demux_003_src0_endofpacket)    //          .endofpacket
	);

	nios_cpu_rsp_xbar_mux rsp_xbar_mux_001 (
		.clk                 (clk_clk),                               //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (rsp_xbar_mux_001_src_ready),            //       src.ready
		.src_valid           (rsp_xbar_mux_001_src_valid),            //          .valid
		.src_data            (rsp_xbar_mux_001_src_data),             //          .data
		.src_channel         (rsp_xbar_mux_001_src_channel),          //          .channel
		.src_startofpacket   (rsp_xbar_mux_001_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (rsp_xbar_mux_001_src_endofpacket),      //          .endofpacket
		.sink0_ready         (rsp_xbar_demux_src1_ready),             //     sink0.ready
		.sink0_valid         (rsp_xbar_demux_src1_valid),             //          .valid
		.sink0_channel       (rsp_xbar_demux_src1_channel),           //          .channel
		.sink0_data          (rsp_xbar_demux_src1_data),              //          .data
		.sink0_startofpacket (rsp_xbar_demux_src1_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (rsp_xbar_demux_src1_endofpacket),       //          .endofpacket
		.sink1_ready         (rsp_xbar_demux_001_src1_ready),         //     sink1.ready
		.sink1_valid         (rsp_xbar_demux_001_src1_valid),         //          .valid
		.sink1_channel       (rsp_xbar_demux_001_src1_channel),       //          .channel
		.sink1_data          (rsp_xbar_demux_001_src1_data),          //          .data
		.sink1_startofpacket (rsp_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.sink1_endofpacket   (rsp_xbar_demux_001_src1_endofpacket),   //          .endofpacket
		.sink2_ready         (rsp_xbar_demux_002_src1_ready),         //     sink2.ready
		.sink2_valid         (rsp_xbar_demux_002_src1_valid),         //          .valid
		.sink2_channel       (rsp_xbar_demux_002_src1_channel),       //          .channel
		.sink2_data          (rsp_xbar_demux_002_src1_data),          //          .data
		.sink2_startofpacket (rsp_xbar_demux_002_src1_startofpacket), //          .startofpacket
		.sink2_endofpacket   (rsp_xbar_demux_002_src1_endofpacket),   //          .endofpacket
		.sink3_ready         (rsp_xbar_demux_003_src1_ready),         //     sink3.ready
		.sink3_valid         (rsp_xbar_demux_003_src1_valid),         //          .valid
		.sink3_channel       (rsp_xbar_demux_003_src1_channel),       //          .channel
		.sink3_data          (rsp_xbar_demux_003_src1_data),          //          .data
		.sink3_startofpacket (rsp_xbar_demux_003_src1_startofpacket), //          .startofpacket
		.sink3_endofpacket   (rsp_xbar_demux_003_src1_endofpacket)    //          .endofpacket
	);

	nios_cpu_irq_mapper irq_mapper (
		.clk           (clk_clk),                        //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.sender_irq    (nios_cpu_d_irq_irq)              //    sender.irq
	);

endmodule

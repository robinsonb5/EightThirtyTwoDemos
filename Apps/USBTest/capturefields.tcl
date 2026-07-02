# The total number of bits here must match the width defined in jcapture_pkg.vhd

set capture_fields {
	{ usb_in_dp_0 1 }
	{ usb_in_dp_1 1 }
	{ usb_in_dm_0 1 }
	{ usb_in_dm_1 1 }

	{ usb_out_dp_0 1 }
	{ usb_out_dp_1 1 }
	{ usb_out_dm_0 1 }
	{ usb_out_dm_1 1 }

	{ usb_out_oe_0 1 }
	{ usb_out_oe_1 1 }
	{ d_stb 1 }
	{ d_send 1 }
	{ sending 1 }
	{ stb_lowspeed 1 }

	{ sample_0 1 }
	{ sample_1 1 }
	{ sample_stb_0 1 }
	{ sample_stb_1 1 }
	{ edgesense_0 1 }
	{ edgesense_1 1 }

	{ fifo_rx_wr 1 }
	{ fifo_rx_d 8 }
	{ fifo_rx_rd 1 }
	{ receiving 1 }
	{ pad 1 }
}


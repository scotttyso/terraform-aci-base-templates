variable "snmp_policies" {
	default = {
		"Inband" = {
			name        = "Inband"
			epg		= "inb-inb_epg"
		},
		"Out-of-Band" = {
			name        = "Out-of-Band"
			epg		= "oob-default"
		},
	}
}
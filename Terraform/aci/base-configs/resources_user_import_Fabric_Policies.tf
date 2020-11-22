# This File will include DNS, Domain, NTP, SmartCallHome
# SNMP, Syslog and other base configuration parameters
resource "aci_rest" "bgp_as_65513" {
	path		= "/api/node/mo/uni/fabric/bgpInstP-default/as.json"
	class_name	= "bgpAsP"
	payload		= <<EOF
{
    "bgpAsP": {
        "attributes": {
            "dn": "uni/fabric/bgpInstP-default/as",
            "asn": "65513",
            "rn": "as"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "bgp_rr_101" {
	path		= "/api/node/mo/uni/fabric/bgpInstP-default/rr/node-101.json"
	class_name	= "bgpRRNodePEp"
	payload		= <<EOF
{
    "bgpRRNodePEp": {
        "attributes": {
            "dn": "uni/fabric/bgpInstP-default/rr/node-101",
            "id": "101",
            "rn": "node-101"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "dns_epg_oob-default" {
	path		= "/api/node/mo/uni/fabric/dnsp-default.json"
	class_name	= "dnsRsProfileToEpg"
	payload		= <<EOF
{
    "dnsRsProfileToEpg": {
        "attributes": {
            "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "dns_1_1_1_1" {
	path		= "/api/node/mo/uni/fabric/dnsp-default/prov-[1.1.1.1].json"
	class_name	= "dnsProv"
	payload		= <<EOF
{
    "dnsProv": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/prov-[1.1.1.1]",
            "addr": "1.1.1.1",
            "preferred": "no",
            "rn": "prov-[1.1.1.1]"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "dns_1_1_1_2" {
	path		= "/api/node/mo/uni/fabric/dnsp-default/prov-[1.1.1.2].json"
	class_name	= "dnsProv"
	payload		= <<EOF
{
    "dnsProv": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/prov-[1.1.1.2]",
            "addr": "1.1.1.2",
            "preferred": "yes",
            "rn": "prov-[1.1.1.2]"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "SmartCallHome_dg" {
	path		= "/api/node/mo/uni/fabric/smartgroup-SmartCallHome_dg.json"
	class_name	= "callhomeSmartGroup"
	payload		= <<EOF
{
    "callhomeSmartGroup": {
        "attributes": {
            "dn": "uni/fabric/smartgroup-SmartCallHome_dg",
            "name": "SmartCallHome_dg",
            "rn": "smartgroup-SmartCallHome_dg"
        },
        "children": [
            {
                "callhomeProf": {
                    "attributes": {
                        "dn": "uni/fabric/smartgroup-SmartCallHome_dg/prof",
                        "port": "25",
                        "from": "asgard-aci@rich.ciscolabs.com",
                        "replyTo": "rich-lab@cisco.com",
                        "email": "rich-lab@cisco.com",
                        "phone": "+1-408-525-5300",
                        "contact": "Richfield Labs",
                        "addr": "4125 Highlander Pkwy Richfield, OH 44286",
                        "contract": "5555555",
                        "customer": "5555555",
                        "site": "555555",
                        "rn": "prof"
                    },
                    "children": [
                        {
                            "callhomeSmtpServer": {
                                "attributes": {
                                    "dn": "uni/fabric/smartgroup-SmartCallHome_dg/prof/smtp",
                                    "host": "cisco-ext.cisco.com",
                                    "rn": "smtp"
                                },
                                "children": [
                                    {
                                        "fileRsARemoteHostToEpg": {
                                            "attributes": {
                                                "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                            },
                                            "children": []
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            },
            {
                "callhomeSmartDest": {
                    "attributes": {
                        "dn": "uni/fabric/smartgroup-SmartCallHome_dg/smartdest-SCH_Receiver",
                        "name": "SCH_Receiver",
                        "email": "rich-lab@cisco.com",
                        "format": "short-txt",
                        "rn": "smartdest-SCH_Receiver"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "callhomeSmartSrc" {
	path		= "/api/node/mo/uni/infra/moninfra-default/smartchsrc.json"
	class_name	= "callhomeSmartSrc"
	payload		= <<EOF
{
    "callhomeSmartSrc": {
        "attributes": {
            "dn": "uni/infra/moninfra-default/smartchsrc",
            "rn": "smartchsrc"
        },
        "children": [
            {
                "callhomeRsSmartdestGroup": {
                    "attributes": {
                        "tDn": "uni/fabric/smartgroup-SmartCallHome_dg"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "ntp_1_1_1_4" {
	path		= "/api/node/mo/uni/fabric/time-default/ntpprov-1.1.1.4.json"
	class_name	= "datetimeNtpProv"
	payload		= <<EOF
{
    "datetimeNtpProv": {
        "attributes": {
            "dn": "uni/fabric/time-default/ntpprov-1.1.1.4",
            "name": "1.1.1.4",
            "preferred": "false",
            "rn": "ntpprov-1.1.1.4"
        },
        "children": [
            {
                "datetimeRsNtpProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    }
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "ntp_1_1_1_5" {
	path		= "/api/node/mo/uni/fabric/time-default/ntpprov-1.1.1.5.json"
	class_name	= "datetimeNtpProv"
	payload		= <<EOF
{
    "datetimeNtpProv": {
        "attributes": {
            "dn": "uni/fabric/time-default/ntpprov-1.1.1.5",
            "name": "1.1.1.5",
            "preferred": "true",
            "rn": "ntpprov-1.1.1.5"
        },
        "children": [
            {
                "datetimeRsNtpProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    }
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "domain_rich_ciscolabs_com" {
	path		= "/api/node/mo/uni/fabric/dnsp-default/dom-[rich.ciscolabs.com].json"
	class_name	= "dnsDomain"
	payload		= <<EOF
{
    "dnsDomain": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/dom-[rich.ciscolabs.com]",
            "name": "rich.ciscolabs.com",
            "isDefault": "yes",
            "rn": "dom-[rich.ciscolabs.com]"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "domain_cisco_com" {
	path		= "/api/node/mo/uni/fabric/dnsp-default/dom-[cisco.com].json"
	class_name	= "dnsDomain"
	payload		= <<EOF
{
    "dnsDomain": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/dom-[cisco.com]",
            "name": "cisco.com",
            "isDefault": "no",
            "rn": "dom-[cisco.com]"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_client_10_0_0_1" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/clgrp-Out-of-Band_Clients/client-[10.0.0.1].json"
	class_name	= "snmpClientP"
	payload		= <<EOF
{
    "snmpClientP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/clgrp-Out-of-Band_Clients/client-[10.0.0.1]",
            "name": "snmp-server1",
            "addr": "10.0.0.1",
            "rn": "client-10.0.0.1"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_client_10_0_0_2" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/clgrp-Out-of-Band_Clients/client-[10.0.0.2].json"
	class_name	= "snmpClientP"
	payload		= <<EOF
{
    "snmpClientP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/clgrp-Out-of-Band_Clients/client-[10.0.0.2]",
            "name": "snmp-server2",
            "addr": "10.0.0.2",
            "rn": "client-10.0.0.2"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_info" {
	path		= "/api/node/mo/uni/fabric/snmppol-default.json"
	class_name	= "snmpPol"
	payload		= <<EOF
{
    "snmpPol": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default",
            "descr": "This is the default SNMP Policy",
            "adminSt": "enabled",
            "contact": "rich-lab@cisco.com",
            "loc": "Richfield Ohio"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_comm_read_access" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/community-read_access.json"
	class_name	= "snmpCommunityP"
	payload		= <<EOF
{
    "snmpCommunityP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/community-read_access",
            "descr": "is it needed, I don't know",
            "name": "read_access",
            "rn": "community-read_access"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_comm_will-this-work" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/community-will-this-work.json"
	class_name	= "snmpCommunityP"
	payload		= <<EOF
{
    "snmpCommunityP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/community-will-this-work",
            "descr": "None",
            "name": "will-this-work",
            "rn": "community-will-this-work"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_trap_default_10_0_0_1" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/trapfwdserver-[10.0.0.1].json"
	class_name	= "snmpTrapFwdServerP"
	payload		= <<EOF
{
    "snmpTrapFwdServerP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/trapfwdserver-[10.0.0.1]",
            "addr": "10.0.0.1",
            "port": "162"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_trap_dest_10_0_0_1" {
	path		= "/api/node/mo/uni/fabric/snmpgroup-SNMP-TRAP_dg.json"
	class_name	= "snmpGroup"
	payload		= <<EOF
{
    "snmpGroup": {
        "attributes": {
            "dn": "uni/fabric/snmpgroup-SNMP-TRAP_dg",
            "descr": "SNMP Trap Destination Group - Created by Brahma Startup Script",
            "name": "SNMP-TRAP_dg",
            "rn": "snmpgroup-SNMP-TRAP_dg"
        },
        "children": [
            {
                "snmpTrapDest": {
                    "attributes": {
                        "dn": "uni/fabric/snmpgroup-SNMP-TRAP_dg/trapdest-10.0.0.1-port-162",
                        "ver": "v2c",
                        "host": "10.0.0.1",
                        "port": "162",
                        "secName": "read_access",
                        "v3SecLvl": "noauth",
                        "rn": "trapdest-10.0.0.1-port-162"
                    },
                    "children": [
                        {
                            "fileRsARemoteHostToEpg": {
                                "attributes": {
                                    "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                }
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "snmp_trap_default_10_0_0_2" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/trapfwdserver-[10.0.0.2].json"
	class_name	= "snmpTrapFwdServerP"
	payload		= <<EOF
{
    "snmpTrapFwdServerP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/trapfwdserver-[10.0.0.2]",
            "addr": "10.0.0.2",
            "port": "162"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_trap_dest_10_0_0_2" {
	path		= "/api/node/mo/uni/fabric/snmpgroup-SNMP-TRAP_dg.json"
	class_name	= "snmpGroup"
	payload		= <<EOF
{
    "snmpGroup": {
        "attributes": {
            "dn": "uni/fabric/snmpgroup-SNMP-TRAP_dg",
            "descr": "SNMP Trap Destination Group - Created by Brahma Startup Script",
            "name": "SNMP-TRAP_dg",
            "rn": "snmpgroup-SNMP-TRAP_dg"
        },
        "children": [
            {
                "snmpTrapDest": {
                    "attributes": {
                        "dn": "uni/fabric/snmpgroup-SNMP-TRAP_dg/trapdest-10.0.0.2-port-162",
                        "ver": "v3",
                        "host": "10.0.0.2",
                        "port": "162",
                        "secName": "cisco_user1",
                        "v3SecLvl": "priv",
                        "rn": "trapdest-10.0.0.2-port-162"
                    },
                    "children": [
                        {
                            "fileRsARemoteHostToEpg": {
                                "attributes": {
                                    "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                }
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "snmp_user_cisco_user1" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/user-cisco_user1.json"
	class_name	= "snmpUserP"
	payload		= <<EOF
{
    "snmpUserP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/user-cisco_user1",
            "name": "cisco_user1",
            "privType": "aes-128",
            "privKey": "cisco123",
            "authType": "hmac-sha1-96",
            "authKey": "cisco123"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_user_cisco_user2" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/user-cisco_user2.json"
	class_name	= "snmpUserP"
	payload		= <<EOF
{
    "snmpUserP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/user-cisco_user2",
            "name": "cisco_user2",
            "privType": "des",
            "privKey": "cisco123",
            "authKey": "cisco123"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "snmp_user_cisco_user3" {
	path		= "/api/node/mo/uni/fabric/snmppol-default/user-cisco_user3.json"
	class_name	= "snmpUserP"
	payload		= <<EOF
{
    "snmpUserP": {
        "attributes": {
            "dn": "uni/fabric/snmppol-default/user-cisco_user3",
            "name": "cisco_user3",
            "authType": "hmac-sha1-96",
            "authKey": "cisco123"
        },
        "children": []
    }
}
	EOF
}

resource "aci_rest" "syslog_1_1_1_1" {
	path		= "/api/node/mo/uni/fabric/slgroup-Syslog-dg_1.1.1.1.json"
	class_name	= "syslogGroup"
	payload		= <<EOF
{
    "syslogGroup": {
        "attributes": {
            "dn": "uni/fabric/slgroup-Syslog-dg_1.1.1.1",
            "includeMilliSeconds": "true",
            "includeTimeZone": "true",
            "descr": "Syslog Destination Group 1.1.1.1 - Created by Brahma Startup Wizard",
            "name": "Syslog-dg_1.1.1.1",
            "rn": "slgroup-Syslog-dg_1.1.1.1"
        },
        "children": [
            {
                "syslogConsole": {
                    "attributes": {
                        "dn": "uni/fabric/slgroup-Syslog-dg_1.1.1.1/console",
                        "adminState": "enabled",
                        "severity": "critical",
                        "rn": "console"
                    },
                    "children": []
                }
            },
            {
                "syslogFile": {
                    "attributes": {
                        "dn": "uni/fabric/slgroup-Syslog-dg_1.1.1.1/file",
                        "adminState": "enabled",
                        "severity": "information",
                        "rn": "file"
                    },
                    "children": []
                }
            },
            {
                "syslogProf": {
                    "attributes": {
                        "dn": "uni/fabric/slgroup-Syslog-dg_1.1.1.1/prof",
                        "adminState": "enabled",
                        "rn": "prof"
                    },
                    "children": []
                }
            },
            {
                "syslogRemoteDest": {
                    "attributes": {
                        "dn": "uni/fabric/slgroup-Syslog-dg_1.1.1.1/rdst-1.1.1.1",
                        "host": "1.1.1.1",
                        "name": "RmtDst-1.1.1.1",
                        "adminState": "enabled",
                        "forwardingFacility": "local7",
                        "port": "514",
                        "severity": "warnings",
                        "rn": "rdst-1.1.1.1"
                    },
                    "children": [
                        {
                            "fileRsARemoteHostToEpg": {
                                "attributes": {
                                    "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                },
                                "children": []
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "aaaRadiusProvider_1_1_1_5" {
	path		= "/api/node/mo/uni/userext/radiusext/radiusprovider-1.1.1.5.json"
	class_name	= "aaaRadiusProvider"
	payload		= <<EOF
{
    "aaaRadiusProvider": {
        "attributes": {
            "dn": "uni/userext/radiusext/radiusprovider-1.1.1.5",
            "timeout": "5",
            "retries": "5",
            "monitorServer": "disabled",
            "key": "cisco1231",
            "authProtocol": "pap",
            "name": "1.1.1.5",
            "descr": "RADIUS Provider - 1.1.1.5.  Added by Brahma Startup Wizard.",
            "rn": "radiusprovider-1.1.1.5"
        },
        "children": [
            {
                "aaaRsSecProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "Ext_Login_RADIUS_prov-1_1_1_5" {
	path		= "/api/node/mo/uni/userext.json"
	class_name	= "aaaUserEp"
	payload		= <<EOF
{
    "aaaUserEp": {
        "attributes": {
            "dn": "uni/userext"
        },
        "children": [
            {
                "aaaLoginDomain": {
                    "attributes": {
                        "dn": "uni/userext/logindomain-RAD_ISE",
                        "name": "RAD_ISE",
                        "rn": "logindomain-RAD_ISE"
                    },
                    "children": [
                        {
                            "aaaDomainAuth": {
                                "attributes": {
                                    "dn": "uni/userext/logindomain-RAD_ISE/domainauth",
                                    "providerGroup": "RAD_ISE",
                                    "realm": "radius",
                                    "descr": "RADIUS Login Domain RAD_ISE. Created by Brahma Wizard.",
                                    "rn": "domainauth"
                                },
                                "children": []
                            }
                        }
                    ]
                }
            },
            {
                "aaaRadiusEp": {
                    "attributes": {
                        "dn": "uni/userext/radiusext"
                    },
                    "children": [
                        {
                            "aaaRadiusProviderGroup": {
                                "attributes": {
                                    "dn": "uni/userext/radiusext/radiusprovidergroup-RAD_ISE"
                                },
                                "children": [
                                    {
                                        "aaaProviderRef": {
                                            "attributes": {
                                                "dn": "uni/userext/radiusext/radiusprovidergroup-RAD_ISE/providerref-1.1.1.5",
                                                "order": "1",
                                                "name": "1.1.1.5",
                                                "descr": "Added RADIUS Server 1.1.1.5 - Brahma Startup Wizard"
                                            },
                                            "children": []
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "aaaRadiusProvider_1_1_1_6" {
	path		= "/api/node/mo/uni/userext/radiusext/radiusprovider-1.1.1.6.json"
	class_name	= "aaaRadiusProvider"
	payload		= <<EOF
{
    "aaaRadiusProvider": {
        "attributes": {
            "dn": "uni/userext/radiusext/radiusprovider-1.1.1.6",
            "timeout": "5",
            "retries": "5",
            "monitorServer": "disabled",
            "key": "cisco123",
            "authProtocol": "pap",
            "name": "1.1.1.6",
            "descr": "RADIUS Provider - 1.1.1.6.  Added by Brahma Startup Wizard.",
            "rn": "radiusprovider-1.1.1.6"
        },
        "children": [
            {
                "aaaRsSecProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "Ext_Login_RADIUS_prov-1_1_1_6" {
	path		= "/api/node/mo/uni/userext.json"
	class_name	= "aaaUserEp"
	payload		= <<EOF
{
    "aaaUserEp": {
        "attributes": {
            "dn": "uni/userext"
        },
        "children": [
            {
                "aaaLoginDomain": {
                    "attributes": {
                        "dn": "uni/userext/logindomain-RAD_ISE",
                        "name": "RAD_ISE",
                        "rn": "logindomain-RAD_ISE"
                    },
                    "children": [
                        {
                            "aaaDomainAuth": {
                                "attributes": {
                                    "dn": "uni/userext/logindomain-RAD_ISE/domainauth",
                                    "providerGroup": "RAD_ISE",
                                    "realm": "radius",
                                    "descr": "RADIUS Login Domain RAD_ISE. Created by Brahma Wizard.",
                                    "rn": "domainauth"
                                },
                                "children": []
                            }
                        }
                    ]
                }
            },
            {
                "aaaRadiusEp": {
                    "attributes": {
                        "dn": "uni/userext/radiusext"
                    },
                    "children": [
                        {
                            "aaaRadiusProviderGroup": {
                                "attributes": {
                                    "dn": "uni/userext/radiusext/radiusprovidergroup-RAD_ISE"
                                },
                                "children": [
                                    {
                                        "aaaProviderRef": {
                                            "attributes": {
                                                "dn": "uni/userext/radiusext/radiusprovidergroup-RAD_ISE/providerref-1.1.1.6",
                                                "order": "2",
                                                "name": "1.1.1.6",
                                                "descr": "Added RADIUS Server 1.1.1.6 - Brahma Startup Wizard"
                                            },
                                            "children": []
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "tacacs_TACACS_acct_1_1_1_5" {
	path		= "/api/node/mo/uni/fabric/tacacsgroup-TACACS_acct.json"
	class_name	= "tacacsGroup"
	payload		= <<EOF
{
    "tacacsGroup": {
        "attributes": {
            "dn": "uni/fabric/tacacsgroup-TACACS_acct",
            "descr": "TACACS Accounting Group TACACS_acct - Created by Brahma Startup Wizard",
            "name": "TACACS_acct",
            "rn": "tacacsgroup-TACACS_acct"
        },
        "children": [
            {
                "tacacsTacacsDest": {
                    "attributes": {
                        "dn": "uni/fabric/tacacsgroup-TACACS_acct/tacacsdest-1.1.1.5-port-49",
                        "authProtocol": "pap",
                        "host": "1.1.1.5",
                        "key": "cisco1231",
                        "rn": "tacacsdest-1.1.1.5-port-49"
                    },
                    "children": [
                        {
                            "fileRsARemoteHostToEpg": {
                                "attributes": {
                                    "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                }
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "tacacsSrc" {
	path		= "/api/node/mo/uni/fabric/moncommon/tacacssrc-TACACS_Src.json"
	class_name	= "tacacsSrc"
	payload		= <<EOF
{
    "tacacsSrc": {
        "attributes": {
            "dn": "uni/fabric/moncommon/tacacssrc-TACACS_Src",
            "name": "TACACS_Src",
            "rn": "tacacssrc-TACACS_Src"
        },
        "children": [
            {
                "tacacsRsDestGroup": {
                    "attributes": {
                        "tDn": "uni/fabric/tacacsgroup-TACACS_acct"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "aaaTacacsPlusProvider_1_1_1_5" {
	path		= "/api/node/mo/uni/userext/tacacsext/tacacsplusprovider-1.1.1.5.json"
	class_name	= "aaaTacacsPlusProvider"
	payload		= <<EOF
{
    "aaaTacacsPlusProvider": {
        "attributes": {
            "dn": "uni/userext/tacacsext/tacacsplusprovider-1.1.1.5",
            "timeout": "5",
            "retries": "5",
            "monitorServer": "disabled",
            "key": "cisco1231",
            "authProtocol": "pap",
            "name": "1.1.1.5",
            "descr": "TACACS+ Provider - 1.1.1.5.  Added by Brahma Startup Wizard.",
            "rn": "tacacsplusprovider-1.1.1.5"
        },
        "children": [
            {
                "aaaRsSecProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "Ext_Login_TACACS_prov-1_1_1_5" {
	path		= "/api/node/mo/uni/userext.json"
	class_name	= "aaaUserEp"
	payload		= <<EOF
{
    "aaaUserEp": {
        "attributes": {
            "dn": "uni/userext"
        },
        "children": [
            {
                "aaaLoginDomain": {
                    "attributes": {
                        "dn": "uni/userext/logindomain-ISE",
                        "name": "ISE",
                        "rn": "logindomain-ISE"
                    },
                    "children": [
                        {
                            "aaaDomainAuth": {
                                "attributes": {
                                    "dn": "uni/userext/logindomain-ISE/domainauth",
                                    "providerGroup": "ISE",
                                    "realm": "tacacs",
                                    "descr": "TACACS+ Login Domain ISE. Created by Brahma Wizard.",
                                    "rn": "domainauth"
                                },
                                "children": []
                            }
                        }
                    ]
                }
            },
            {
                "aaaTacacsPlusEp": {
                    "attributes": {
                        "dn": "uni/userext/tacacsext"
                    },
                    "children": [
                        {
                            "aaaTacacsPlusProviderGroup": {
                                "attributes": {
                                    "dn": "uni/userext/tacacsext/tacacsplusprovidergroup-ISE"
                                },
                                "children": [
                                    {
                                        "aaaProviderRef": {
                                            "attributes": {
                                                "dn": "uni/userext/tacacsext/tacacsplusprovidergroup-ISE/providerref-1.1.1.5",
                                                "order": "1",
                                                "name": "1.1.1.5",
                                                "descr": "Added TACACS Server 1.1.1.5 - Brahma Startup Wizard"
                                            },
                                            "children": []
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "tacacs_TACACS_acct_1_1_1_6" {
	path		= "/api/node/mo/uni/fabric/tacacsgroup-TACACS_acct.json"
	class_name	= "tacacsGroup"
	payload		= <<EOF
{
    "tacacsGroup": {
        "attributes": {
            "dn": "uni/fabric/tacacsgroup-TACACS_acct",
            "descr": "TACACS Accounting Group TACACS_acct - Created by Brahma Startup Wizard",
            "name": "TACACS_acct",
            "rn": "tacacsgroup-TACACS_acct"
        },
        "children": [
            {
                "tacacsTacacsDest": {
                    "attributes": {
                        "dn": "uni/fabric/tacacsgroup-TACACS_acct/tacacsdest-1.1.1.6-port-49",
                        "authProtocol": "pap",
                        "host": "1.1.1.6",
                        "key": "cisco123",
                        "rn": "tacacsdest-1.1.1.6-port-49"
                    },
                    "children": [
                        {
                            "fileRsARemoteHostToEpg": {
                                "attributes": {
                                    "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                                }
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "aaaTacacsPlusProvider_1_1_1_6" {
	path		= "/api/node/mo/uni/userext/tacacsext/tacacsplusprovider-1.1.1.6.json"
	class_name	= "aaaTacacsPlusProvider"
	payload		= <<EOF
{
    "aaaTacacsPlusProvider": {
        "attributes": {
            "dn": "uni/userext/tacacsext/tacacsplusprovider-1.1.1.6",
            "timeout": "5",
            "retries": "5",
            "monitorServer": "disabled",
            "key": "cisco123",
            "authProtocol": "pap",
            "name": "1.1.1.6",
            "descr": "TACACS+ Provider - 1.1.1.6.  Added by Brahma Startup Wizard.",
            "rn": "tacacsplusprovider-1.1.1.6"
        },
        "children": [
            {
                "aaaRsSecProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "Ext_Login_TACACS_prov-1_1_1_6" {
	path		= "/api/node/mo/uni/userext.json"
	class_name	= "aaaUserEp"
	payload		= <<EOF
{
    "aaaUserEp": {
        "attributes": {
            "dn": "uni/userext"
        },
        "children": [
            {
                "aaaLoginDomain": {
                    "attributes": {
                        "dn": "uni/userext/logindomain-ISE",
                        "name": "ISE",
                        "rn": "logindomain-ISE"
                    },
                    "children": [
                        {
                            "aaaDomainAuth": {
                                "attributes": {
                                    "dn": "uni/userext/logindomain-ISE/domainauth",
                                    "providerGroup": "ISE",
                                    "realm": "tacacs",
                                    "descr": "TACACS+ Login Domain ISE. Created by Brahma Wizard.",
                                    "rn": "domainauth"
                                },
                                "children": []
                            }
                        }
                    ]
                }
            },
            {
                "aaaTacacsPlusEp": {
                    "attributes": {
                        "dn": "uni/userext/tacacsext"
                    },
                    "children": [
                        {
                            "aaaTacacsPlusProviderGroup": {
                                "attributes": {
                                    "dn": "uni/userext/tacacsext/tacacsplusprovidergroup-ISE"
                                },
                                "children": [
                                    {
                                        "aaaProviderRef": {
                                            "attributes": {
                                                "dn": "uni/userext/tacacsext/tacacsplusprovidergroup-ISE/providerref-1.1.1.6",
                                                "order": "2",
                                                "name": "1.1.1.6",
                                                "descr": "Added TACACS Server 1.1.1.6 - Brahma Startup Wizard"
                                            },
                                            "children": []
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "auth-realm_console" {
	path		= "/api/node/mo/uni/userext/authrealm.json"
	class_name	= "aaaAuthRealm"
	payload		= <<EOF
{
    "aaaAuthRealm": {
        "attributes": {
            "dn": "uni/userext/authrealm"
        },
        "children": [
            {
                "aaaConsoleAuth": {
                    "attributes": {
                        "dn": "uni/userext/authrealm/consoleauth",
                        "realm": "tacacs",
                        "providerGroup": "ISE"
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

resource "aci_rest" "auth-realm_default" {
	path		= "/api/node/mo/uni/userext/authrealm.json"
	class_name	= "aaaAuthRealm"
	payload		= <<EOF
{
    "aaaAuthRealm": {
        "attributes": {
            "dn": "uni/userext/authrealm"
        },
        "children": [
            {
                "aaaDefaultAuth": {
                    "attributes": {
                        "dn": "uni/userext/authrealm/defaultauth",
                        "realm": "local",
                        "providerGroup": ""
                    },
                    "children": []
                }
            }
        ]
    }
}
	EOF
}

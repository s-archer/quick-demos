              { 
                    "schemaVersion": "1.15.0",
                    "class": "Device",
                    "async": true,
                    "label": "my BIG-IP declaration for declarative onboarding",
                    "Common": {
                        "class": "Tenant",
                        "hostname": "{{{ HOST_NAME }}}",
                        "admin": {
                            "class": "User",
                            "userType": "regular",
                            "password": "{{{ ADMIN_PASS }}}",
                            "shell": "bash"
                        },
                        "myDns": {
                            "class": "DNS",
                            "nameServers": [
                                "8.8.8.8"
                            ]
                        },
                        "myNtp": {
                            "class": "NTP",
                            "servers": [
                                "0.pool.ntp.org"
                            ],
                            "timezone": "UTC"
                        },
                        "myProvisioning": {
                            "class": "Provision",
                            "ltm": "nominal",
                            "asm": "nominal"
                        },
                        "external": {
                            "class": "VLAN",
                            "tag": 1001,
                            "mtu": 1500,
                            "interfaces": [
                                {
                                    "name": 1.1,
                                    "tagged": false
                                }
                            ]
                        },
                        "external-self": {
                            "class": "SelfIp",
                            "address": "{{{ EXTERNAL_IP }}}",
                            "vlan": "external",
                            "allowService": "none",
                            "trafficGroup": "traffic-group-local-only"
                        },
                        "internal": {
                            "class": "VLAN",
                            "tag": 1002,
                            "mtu": 1500,
                            "interfaces": [
                                {
                                    "name": 1.2,
                                    "tagged": false
                                }
                            ]
                        },
                        "internal-self": {
                            "class": "SelfIp",
                            "address": "{{{ INTERNAL_IP }}}",
                            "vlan": "internal",
                            "allowService": "default",
                            "trafficGroup": "traffic-group-local-only"
                        },
                        "dbvars": {
                            "class": "DbVariables",
                            "provision.extramb": 500,
                            "restjavad.useextramb": true,
                            "config.allow.rfc3927": "enable"
                        },
                        "configsync": {
                            "class": "ConfigSync",
                            "configsyncIp": "/Common/internal-self/address"
                        },
                        "failoverAddress": {
                            "class": "FailoverUnicast",
                            "address": "/Common/internal-self/address"
                        },
                        "failoverGroup": {
                            "class": "DeviceGroup",
                            "type": "sync-failover",
                            "members": ["{{{ BIGIP1 }}}", "{{{ BIGIP2 }}}"],
                            "owner": "{{{ BIGIP1 }}}",
                            "autoSync": true,
                            "saveOnAutoSync": false,
                            "networkFailover": true,
                            "fullLoadOnSync": false,
                            "asmSync": false
                        },
                        "trust": {
                            "class": "DeviceTrust",
                            "localUsername": "admin",
                            "localPassword": "{{{ ADMIN_PASS }}}",
                            "remoteHost": "{{{ BIGIP1 }}}",
                            "remoteUsername": "admin",
                            "remotePassword": "{{{ ADMIN_PASS }}}"
                        }
                    }
                }
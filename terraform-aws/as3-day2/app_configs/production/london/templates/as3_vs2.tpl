{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.0.0",
        "id": "123abc",
        "label": "Sample 2",
        "remark": "HTTPS with predictive-node pool",
        "demo_day_2": {
            "class": "Tenant",
            "nginx2": {
                "class": "Application",
                "nginx2": {
                    "class": "Service_HTTPS",
                    "virtualAddresses": ${vip},
                    "pool": "web_pool",
                    "iRules": [
                    "tetris_rule"
                    ],
                    "serverTLS": "webtls"
                },
                "tetris_rule": {
                "class": "iRule",
                "remark": "choose private pool based on IP",
                "iRule": { "url": "https://raw.githubusercontent.com/s-archer/irules/main/tetris.tcl" }
                },
                "web_pool": {
                    "class": "Pool",
                    "loadBalancingMode": "predictive-node",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "serverAddresses": [
                                "192.0.2.12",
                                "192.0.2.13"
                            ]
                        }
                    ]
                },
                "webtls": {
                    "class": "TLS_Server",
                    "certificates": [
                        {
                            "certificate": "webcert"
                        }
                    ]
                },
                "webcert": {
                    "class": "Certificate",
                    "remark": "in practice we recommend using a passphrase",
                    "certificate": ${jsonencode(cert)},
                    "privateKey": ${jsonencode(key)},
                    "passphrase": {
                        "ciphertext": ${jsonencode(ciphertext)},
                        "protected": ${jsonencode(protected)}
                    }
                }
            }
        }
    }
}
                {
                    "class": "AS3",
                    "action": "deploy",
                    "persist": true,
                    "declaration": {
                        "class": "ADC",
                        "schemaVersion": "3.22.0",
                        "label": "Sample 1",
                        "remark": "Simple HTTP Service with Round-Robin Load Balancing",
                        "demo_day_1": {
                            "class": "Tenant",
                            "nginx1": {
                                "class": "Application",
                                "template": "http",
                                "serviceMain": {
                                    "class": "Service_HTTP",
                                    "virtualAddresses": [
                                        "{{{ VS1_IP }}}"
                                    ],
                                    "persistenceMethods": [],
                                    "profileMultiplex": {
                                        "bigip": "/Common/oneconnect"
                                    },
                                    "pool": "web_pool"
                                },
                                "web_pool": {
                                    "class": "Pool",
                                    "monitors": [
                                        "http"
                                    ],
                                    "members": [
                                        {
                                            "servicePort": 80,
                                            "addressDiscovery": "aws",
                                            "updateInterval": 1,
                                            "tagKey": "Name",
                                            "tagValue": "nginx-autoscale",
                                            "addressRealm": "private",
                                            "accessKeyId": "{{{ ACCESS_KEY }}}",
                                            "secretAccessKey": "{{{ SECRET_KEY }}}",
                                            "region": "eu-west-2"
                                        }
                                    ]
                                }
                            }
                        }
                    }
                }
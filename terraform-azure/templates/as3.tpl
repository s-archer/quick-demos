                {
                    "class": "AS3",
                    "action": "deploy",
                    "persist": true,
                    "declaration": {
                        "class": "ADC",
                        "schemaVersion": "3.22.0",
                        "label": "Sample 1",
                        "remark": "Simple HTTP Service with Round-Robin Load Balancing",
                        "Sample_01": {
                            "class": "Tenant",
                            "A1": {
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
                                            "addressDiscovery": "azure",
                                            "updateInterval": 10,
                                            "tagKey": "Name",
                                            "tagValue": "nginx-autoscale",
                                            "addressRealm": "private",
                                            "resourceGroup": "{{{ RESOURCE_GROUP }}}",
                                            "subscriptionId": "{{{ SUBSCRIPTION_ID }}}",
                                            "directoryId": "{{{ DIRECTORY_ID }}}",
                                            "applicationId": "{{{ APPLICATION_ID }}}",
                                            "apiAccessKey": "{{{ API_ACCESS_KEY }}}"
                                        }
                                    ]
                                }
                            }
                        }
                    }
                }
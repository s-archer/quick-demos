{
    "id": "per-app-declaration",
    "schemaVersion": "3.50.0",
    "controls": {
        "class": "Controls"
    }%{ for app in app_list},
    "${app.app_short_name}": {
        "class": "Application",
        "HTTPS_${app.app_short_name}": {
            "class": "Service_HTTPS",
            "virtualPort": 443,
            "redirect80": false,
            "virtualAddresses": [
                "${app.private_ip}"
            ],
            "persistenceMethods": [],
            "profileMultiplex": {
                "bigip": "/Common/oneconnect"
            },
            "pool": "${app.app_short_name}_pool",
            "serverTLS": "${app.app_short_name}Tls"%{ if app.waf_enable == true },
            "policyWAF": {
                "use": "${app.app_short_name}_basePolicy" 
            }%{ endif }
        },
        "${app.app_short_name}Tls": {
            "class": "TLS_Server",
            "certificates": [
                {
                    "certificate": "${app.app_short_name}_cert"
                }
            ]
        },  
        "${app.app_short_name}_cert": {
            "class": "Certificate",
            "remark" : "in practice we recommend using a passphrase",
            "certificate": "${app.certificate}",
            "privateKey": "${app.key}"%{ if app.passphrase != "" },
            "passphrase": {
                "ciphertext": "${base64encode(app.passphrase)}",
                "protected": "${base64encode(app.protected)}"
            }%{ endif }
        },
        "${app.app_short_name}_pool": {
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
                    "tagValue": "${app.service_discovery_tag}",
                    "addressRealm": "private",
                    "region": "${app.region}"
                }
            ]
        }%{ if app.waf_enable == true },
        "${app.app_short_name}_basePolicy": {
            "class": "WAF_Policy",
            "url": "https://raw.githubusercontent.com/s-archer/waf_policies/master/owasp.json",
            "ignoreChanges": false,
            "enforcementMode": "blocking"
        }%{ endif }
    }%{ endfor }
}
{
  "class":"Cloud_Failover",
  "environment":"azure",
  "controls":{
    "class":"Controls",
    "logLevel":"silly"
  },
  "externalStorage":{
    "scopingTags":{
      "f5_cloud_failover_label":"{{{ CFE_TAG }}}"
    }
  },
  "failoverAddresses":{
    "enabled":false,
    "scopingTags":{
      "f5_cloud_failover_label":"{{{ CFE_TAG }}}"
    }
  },
  "failoverRoutes":{
    "enabled":true,
    "routeGroupDefinitions":[
      {
        "scopingName":"{{{ UDR_RT }}}",
        "scopingAddressRanges":[
          {
            "range":"{{{ UDR_PREFIX }}}"
          }
        ],
        "defaultNextHopAddresses":{
          "discoveryType":"static",
          "items":[
            "{{{ EXTERNAL_IP0 }}}",
            "{{{ EXTERNAL_IP1 }}}"
          ]
        }
      }
    ]
  }
}
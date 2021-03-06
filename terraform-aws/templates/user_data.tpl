#!/bin/bash

mkdir -p /config/cloud
cat << 'EOF' > /config/cloud/runtime-init-conf.yaml
---
runtime_parameters:
  - name: HOST_NAME
    type: static
    value: ${hostname}
  - name: ADMIN_PASS
    type: static
    value: ${admin_pass}
  - name: EXTERNAL_IP
    type: static
    value: ${external_ip}
  - name: INTERNAL_IP
    type: static
    value: ${internal_ip}
  - name: INTERNAL_GW
    type: static
    value: ${internal_gw}
  - name: VS1_IP
    type: static
    value: ${vs1_ip}
  - name: ACCESS_KEY
    type: static
    value: ${access_key}
  - name: SECRET_KEY
    type: static
    value: ${secret_key}
pre_onboard_enabled:
  - name: provision_rest
    type: inline
    commands:
      - /usr/bin/setdb provision.extramb 500
      - /usr/bin/setdb restjavad.useextramb true
extension_packages:
  install_operations:
    - extensionType: do
      extensionVersion: 1.15.0
    - extensionType: as3
      extensionVersion: 3.22.1
    - extensionType: cf
      extensionVersion: 1.5.0
    - extensionType: ilx
      extensionUrl: >-
        https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.3.0/f5-appsvcs-templates-1.3.0-1.noarch.rpm
      extensionVersion: 1.3.0
      extensionVerificationEndpoint: /mgmt/shared/fast/info
extension_services:
  service_operations:
    - extensionType: do
      type: inline
      value:
        schemaVersion: 1.15.0
        class: Device
        async: true
        label: my BIG-IP declaration for declarative onboarding
        Common:
          class: Tenant
          hostname: '{{{ HOST_NAME }}}'
          admin:
            class: User
            userType: regular
            password: '{{{ ADMIN_PASS }}}'
            shell: bash
          myDns:
            class: DNS
            nameServers:
              - 8.8.8.8
          myNtp:
            class: NTP
            servers:
              - 0.pool.ntp.org
            timezone: UTC
          myProvisioning:
            class: Provision
            ltm: nominal
            asm: nominal
          external:
            class: VLAN
            tag: 1001
            mtu: 1500
            interfaces:
              - name: 1.1
                tagged: false
          external-self:
            class: SelfIp
            address: '{{{ EXTERNAL_IP }}}'
            vlan: external
            allowService: none
            trafficGroup: traffic-group-local-only
          internal:
            class: VLAN
            tag: 1002
            mtu: 1500
            interfaces:
              - name: 1.2
                tagged: false
          internal-self:
            class: SelfIp
            address: '{{{ INTERNAL_IP }}}'
            vlan: internal
            allowService: default
            trafficGroup: traffic-group-local-only
          default: 
            class: Route
            gw: '{{{ INTERNAL_GW }}}'
            network: default
            mtu: 1500
          dbvars:
            class: DbVariables
            provision.extramb: 500
            restjavad.useextramb: true
    - extensionType: as3
      type: inline
      value:
        class: AS3
        action: deploy
        persist: true
        declaration:
          class: ADC
          schemaVersion: 3.22.0
          label: Sample 1
          remark: Simple HTTP Service with Round-Robin Load Balancing
          Sample_01:
            class: Tenant
            A1:
              class: Application
              template: http
              serviceMain:
                class: Service_HTTP
                virtualAddresses:
                  - '{{{ VS1_IP }}}'
                pool: web_pool
              web_pool:
                class: Pool
                monitors:
                  - http
                members:
                  - servicePort: 80
                    addressDiscovery: aws
                    updateInterval: 1
                    tagKey: Name
                    tagValue: nginx-autoscale
                    addressRealm: private
                    accessKeyId: '{{{ ACCESS_KEY }}}'
                    secretAccessKey: '{{{ SECRET_KEY }}}'
                    region: eu-west-2

EOF

curl https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.0.0/dist/f5-bigip-runtime-init-1.0.0-1.gz.run -o f5-bigip-runtime-init-1.0.0-1.gz.run && bash f5-bigip-runtime-init-1.0.0-1.gz.run -- '--cloud aws'

f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml

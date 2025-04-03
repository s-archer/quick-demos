resource "bigip_ltm_irule" "rule2" {
  name  = "/Common/terraform_irule2"
  irule = <<EOF
when HTTP_REQUEST {

  if { [string tolower [HTTP::header value Upgrade]] equals "websocket" } {
    HTTP::disable
#    ASM::disable
    log local0. "[IP::client_addr] - Connection upgraded to websocket protocol. Disabling ASM-checks and HTTP protocol. Traffic is treated as L4 TCP stream."
  } else {
    HTTP::enable
#    ASM::enable
    log local0. "[IP::client_addr] - Regular HTTP request. ASM-checks and HTTP protocol enabled. Traffic is deep-inspected at L7."
  }
}
EOF
}

resource "bigip_ltm_monitor" "ltmmonitor" {
  name        = "/Common/terraform_ltmmonitor"
  parent      = "/Common/http"
  send        = "GET /some/path\\r\\n"
  timeout     = "999"
  interval    = "998"
  destination = "1.2.3.4:1234"
}

resource "bigip_ltm_monitor" "test-https-monitor" {
  name        = "/Common/terraform_test-https-monitor"
  parent      = "/Common/http"
  ssl_profile = "/Common/serverssl"
  send        = "GET /some/path\\r\\n"
  interval    = "999"
  timeout     = "1000"
}

resource "bigip_ltm_monitor" "test-postgresql-monitor" {
  name     = "/Common/test-postgresql-monitor"
  parent   = "/Common/postgresql"
  send     = "SELECT 'Test';"
  receive  = "Test"
  interval = 5
  timeout  = 16
  username = "abcd"
  password = "abcd1234"
}

resource "bigip_ltm_node" "node11" {
  name             = "/Common/terraform_node11"
  address          = "192.168.30.1"
  connection_limit = "0"
  dynamic_ratio    = "1"
  description      = "Test-Node1"
  rate_limit       = "disabled"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}

resource "bigip_ltm_node" "node12" {
  name             = "/Common/terraform_node12"
  address          = "192.168.30.2"
  connection_limit = "0"
  dynamic_ratio    = "1"
  description      = "Test-Node2"
  rate_limit       = "disabled"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}

resource "bigip_ltm_monitor" "monitor" {
  name     = "/Common/terraform_monitor"
  parent   = "/Common/http"
  send     = "GET /some/path\\r\\n"
  timeout  = "999"
  interval = "998"
}

resource "bigip_ltm_pool" "pool" {
  name                = "/Common/terraform-pool"
  load_balancing_mode = "round-robin"
  monitors            = [bigip_ltm_monitor.monitor.name]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource "bigip_ltm_pool_attachment" "node11_attach" {
  pool = bigip_ltm_pool.pool.name
  node = "${bigip_ltm_node.node11.name}:80"
}

resource "bigip_ltm_pool_attachment" "node12_attach" {
  pool = bigip_ltm_pool.pool.name
  node = "${bigip_ltm_node.node12.name}:80"
}

resource "bigip_ltm_virtual_server" "https" {
  name                       = "/Common/terraform_vs_https"
  destination                = "10.255.255.254"
  description                = "VirtualServer-test"
  port                       = 443
  pool                       = bigip_ltm_pool.pool.name
  profiles                   = ["/Common/tcp", "/Common/http"]
  client_profiles            = ["/Common/clientssl"]
  server_profiles            = ["/Common/serverssl"]
  security_log_profiles      = ["/Common/global-network"]
  source_address_translation = "automap"
  irules                     = [bigip_ltm_irule.rule2.name]
}
// Client Config
datacenter = "dc1"
node_name = "dc1a5"
server = false
log_level = "INFO"
data_dir = "/consul-data"
partition = "pt2"

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	//grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}

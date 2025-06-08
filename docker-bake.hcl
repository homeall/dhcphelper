group "default" {
  targets = ["dhcphelper"]
}

target "dhcphelper" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags       = ["homeall/dhcphelper:latest"]
  output     = ["type=registry"]
}

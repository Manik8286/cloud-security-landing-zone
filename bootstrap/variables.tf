variable "my_public_ip" {
  description = "Your current public IP, so the storage account firewall allows your machine"
  type        = string
  # find yours with: curl -s ifconfig.me
}
provider "alicloud" {
    region = var.alicloud_region
    
    # Access keys should be set via environment variables
    # ALICLOUD_ACCESS_KEY=$ACCESS_KEY
    # ALICLOUD_SECRET_KEY=$SECRET_KEY
}
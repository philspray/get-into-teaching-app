paas_space                   = "get-into-teaching-production"
paas_monitoring_space        = "get-into-teaching-monitoring"
paas_monitoring_app          = "prometheus-prod-get-into-teaching"
paas_app_route_name          = "get-into-teaching-app-prod"
paas_app_application_name    = "get-into-teaching-app-prod"
paas_redis_1_name            = "get-into-teaching-prod-redis-svc"
paas_internet_hostnames      = ["getintoteaching", "beta-getintoteaching"] # The first item in the list will be used as the Application URL, routes will be created for all items.
paas_asset_hostnames         = ["app-assets-getintoteaching"]              # The first item will be used as Asset Hostname, routes will be created for all items.
instances                    = 6
basic_auth                   = 0
azure_key_vault              = "s146p01-kv"
azure_resource_group         = "s146p01-rg"
alerts = {
  GiT_App_Production_Healthcheck = {
    website_name  = "Get Into Teaching Website (Production)"
    website_url   = "https://getintoteaching.education.gov.uk/healthcheck.json"
    check_rate    = 60
    contact_group = [185037]
  }
}

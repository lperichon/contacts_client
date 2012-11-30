class Avatar < LogicalModel
  self.hydra = Contacts::HYDRA

  self.resource_path = "/v0/avatar"
  self.attribute_keys = [:file]
  self.use_api_key = true
  self.api_key_name = "app_key"
  self.api_key = Contacts::API_KEY
  self.host  = Contacts::HOST
end
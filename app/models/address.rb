class Address < ContactAttribute
  attr_accessor :category, :postal_code, :city, :state, :country
  self.attribute_keys = [:_id, :_type, :public, :primary, :category, :value, :postal_code, :city, :state, :country, :contact_id]

  self.hydra = Contacts::HYDRA
  self.resource_path = "/v0/contact_attributes"
  self.use_api_key = true
  self.api_key_name = "app_key"
  self.api_key = Contacts::API_KEY
  self.host  = Contacts::HOST

  def _type
    self.class.name
  end
end
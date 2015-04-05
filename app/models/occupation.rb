class Occupation < ContactAttribute

  use_hydra Contacts::HYDRA

  set_resource_url Contacts::HOST, '/v0/contact_attributes'
  set_api_key      :app_key, Contacts::API_KEY

  attribute :_id
  attribute :_type
  attribute :public
  attribute :primary
  attribute :value
  attribute :contact_id

  def _type
    self.class.name
  end

end

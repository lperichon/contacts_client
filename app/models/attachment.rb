class Attachment < LogicalModel
  self.attribute_keys = [:_id, :file, :_type, :public, :name, :description, :contact_id, :account_name]
  self.hydra = Contacts::HYDRA
  self.resource_path = "/v0/attachments"
  self.use_api_key = true
  self.api_key_name = "app_key"
  self.api_key = Contacts::API_KEY
  self.host  = Contacts::HOST

  attr_accessor :name, :description, :file, :public, :primary

  def new_record?
    self._id.blank?
  end

  def always_public?
    false
  end

  def json_root
    :attachment
  end

  def to_key
    [self._id]
  end

  def id
    self._id
  end

  def id= id
    self._id = id
  end


  def _type
    self.class.name
  end
end
class Tag < LogicalModel
  attr_accessor :name

  attribute :_id
  attribute :name
  attribute :contact_ids
  attribute :account_name

  set_resource_url Contacts::HOST, "/v0/tags"

  set_api_key(:app_key,Contacts::API_KEY)

  self.hydra = Contacts::HYDRA

  validates :name, :presence => true

  def json_root
    :tag
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


  # Returns all the tags associated with a given account
  def self.account_tags(account_name)
    paginate(per_page: 999, account_name: account_name)
  end
end
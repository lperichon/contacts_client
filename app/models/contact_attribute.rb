class ContactAttribute < LogicalModel

  # defines ContactAttribute.custom_keys and .async_custom_keys
  extend ContactAttribute::CustomKeys

  AVAILABLE_TYPES = %w(telephone email identification address date_attribute custom_attribute social_network_id)

  attr_accessor :public, :primary

  attribute :_id
  attribute :_type
  attribute :value
  attribute :public
  attribute :primary
  attribute :account_name

  belongs_to :contact, class: 'PadmaContact'
  
  use_hydra Contacts::HYDRA
  set_resource_url Contacts::HOST, "/v0/contact_attributes"
  set_api_key 'app_key', Contacts::API_KEY

  validates :value, :presence => true, :unless => proc { self.is_a? DateAttribute }

  def new_record?
    self._id.blank?
  end

  def always_public?
    false
  end

  def json_root
    :contact_attribute
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

  #
  # creates model.
  # Override to set the primary boolean based on what is returned from the service
  # TODO this could be done in an after_create
  def _create(params = {})
    return false unless valid?

    params = { self.json_root => self.attributes }.merge(params)
    params = self.class.merge_key(params)

    response = nil

    Timeout::timeout(self.class.timeout/1000) do
      response = Typhoeus::Request.post( self.class.resource_uri, :params => params, :timeout => self.class.timeout )
    end
    if response.code == 201
      log_ok(response)
      self.id = ActiveSupport::JSON.decode(response.body)["id"]
      #Set as primary according to json returned from service
      self.primary = ActiveSupport::JSON.decode(response.body)["primary"]
      return true
    elsif response.code == 400
      log_failed(response)
      ws_errors = ActiveSupport::JSON.decode(response.body)["errors"]
      ws_errors.each_key do |k|
        self.errors.add k, ws_errors[k]
      end
      return false
    else
      log_failed(response)
      return nil
    end
  rescue Timeout::Error
    self.class.logger.warn "timeout"
    return nil
  end
end
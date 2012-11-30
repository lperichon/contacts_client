class DateAttribute < ContactAttribute
  self.attribute_keys = [:_id, :_type, :public, :primary, :category, :contact_id, :year, :month, :day, :value]
  self.hydra = Contacts::HYDRA
  self.resource_path = "/v0/contact_attributes"
  self.use_api_key = true
  self.api_key_name = "app_key"
  self.api_key = Contacts::API_KEY
  self.host  = Contacts::HOST

  attr_accessor :category, :public, :primary

  validate :valid_date

  before_save :set_value

  def _type
    self.class.name
  end

  private

  def set_value
    y = year.blank?? 0 : year.to_i
    self.value = Date.civil(y,month.to_i,day.to_i) if Date.valid_civil?(y,month.to_i,day.to_i)
  end

  def valid_date
    y = year.blank?? 2011 : year # 2011 is a leap year
    unless Date.valid_civil?(y.to_i,month.to_i,day.to_i)
      errors.add(nil)
    end
  end
end
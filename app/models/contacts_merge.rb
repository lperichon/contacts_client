# encoding: UTF-8
class ContactsMerge < LogicalModel

  self.hydra = Contacts::HYDRA

  self.resource_path = "/v0/merges"
  self.attribute_keys =
      [
          :id,
          :first_contact_id,
          :second_contact_id,
          :state
      ]
  self.use_api_key = true
  self.api_key_name = "app_key"
  self.api_key = Contacts::API_KEY
  self.host  = Contacts::HOST

  def json_root
    'merge'
  end

  # Returns a Hash with the message corresponding
  # to last create result
  # @return [Hash]
  # @example { alert: 'error' }
  # @example { notice: 'success' }
  def last_create_message_hash
    case self.last_response_code
      when 400
        if self.errors.keys.include?(:similarity_of_contacts)
          {alert: I18n.t('contacts_merge.not_similar')}
        else
          {alert: self.errors.messages}
        end
      when 401
        {alert: I18n.t('contacts_merge.not_allowed', more: "[<a href='http://www.padma-support.com.ar/blog/n%C4%81o-tenho-permiss%C5%8Des-para-fundir-contatos' target='_blank'>?</a>]").html_safe}
      when 201
        {notice: I18n.t('contacts_merge.merged')}
      when 202
        case self.state
          when 'pending_confirmation'
            {notice: I18n.t('contacts_merge.pending_confirmation_of_admin')}
          else
            {notice: I18n.t('contacts_merge.started')}
        end
      else
        {alert: I18n.t('contacts.communication_failure')}
    end
  end

end
# this module assumes base class has a contact_id attribute.
# expects base class to respond to :account_name
module BelongsToContact

  def self.included(base)
    base.send(:validate, :padma_contact_setted_correctly)
  end

  attr_accessor :padma_contact
  ##
  # Returns associated contact.
  #
  # contact is stored in instance variable padma_contact. This allows for it to be setted in a Mass-Load.
  #
  # @param options [Hash]
  # @option options [TrueClass] decorated          - returns decorated contact
  # @option options [TrueClass] force_service_call - forces call to contacts-ws
  # @return [PadmaContact / PadmaContactDecorator]
  def contact(options={})
    if self.padma_contact.nil? || options[:force_service_call]
      self.padma_contact = PadmaContact.find(contact_id, {select: :all, account_name: self.account_name})
    end
    ret = padma_contact
    if options[:decorated] && padma_contact
      ret = PadmaContactDecorator.decorate(padma_contact)
    end
    ret
  end

  private

  # If padma_contact is setted with a PadmaContact that doesn't match
  # contact_id an exception will be raised
  # @raises 'This is the wrong contact!'
  # @raises 'This is not a contact!'
  def padma_contact_setted_correctly
    return if self.padma_contact.nil?
    unless padma_contact.is_a?(PadmaContact)
      raise 'This is not a contact!'
    end
    if padma_contact.id != self.contact_id
      if self.contact_id.nil?
        # if they differ because contact_id is nil we set it here
        self.contact_id = self.padma_contact.id
      else
        raise 'This is the wrong contact!'
      end
    end
  end
end

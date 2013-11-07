if(defined?(Rails))
  module Contacts

    unless defined? HYDRA
      HYDRA = Typhoeus::Hydra.new
    end

    HOST = case Rails.env
      when "production"
        "contacts.padm.am"
      when "staging"
        "padma-contacts-staging.herokuapp.com"
      when "development"
         "localhost:3002"
      when "test"
         "localhost:3002"
    end
  end
end

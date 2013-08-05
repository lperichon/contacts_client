class ContactAttribute
  module CustomKeys

    # Get CustomAttribute names
    #
    # @param options [ Hash ]
    #
    # @example
    #   ContactAttribute.async_custom_keys(:page => params[:page]){|i| result = i}
    def async_custom_keys(options={})
      options = self.merge_key(options)

      request = Typhoeus::Request.new("#{resource_uri}/custom_keys", params: options)
      request.on_complete do |response|
        if response.code >= 200 && response.code < 400
          log_ok(response)

          parsed_response = ActiveSupport::JSON.decode(response.body)
          yield parsed_response['collection']
        else
          log_failed(response)
        end
      end
      self.hydra.queue(request)
    end

    ##
    # Get CustomAttribute names
    # @see async_custom_keys
    def custom_keys(options={})
      result = nil
      self.retries.times do
        begin
          async_custom_keys(options){|i| result = i}
          Timeout::timeout(self.timeout/1000) do
            self.hydra.run
          end
          break unless result.nil?
        rescue Timeout::Error
          self.logger.warn("timeout")
          result = nil
        end
      end
      result
    end

  end
end
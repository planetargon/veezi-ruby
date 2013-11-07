require 'rest_client'

module Veezi
  module API
    class Base
      attr_accessor :api_path
      attr_reader :client
      attr_reader :parser

      def initialize(client)
        @client = client
        @parser = Veezi::API::Parser.new(self.client.configuration.content_type)
      end

      def configuration
        self.client.configuration
      end

      def content_type
        self.client.configuration.content_type || :json
      end

      def base_url
        "#{self.client.configuration.endpoint_url}/#{self.client.configuration.api_version}#{self.api_path}"
      end

      def all
        response = request(:get, self.base_url)
        self.parser.parse(response)
      end

      protected
      def request(method, url, options = {})
        RestClient.send(method, url, options.merge({ :accept => self.content_type }))
      end
    end
  end
end
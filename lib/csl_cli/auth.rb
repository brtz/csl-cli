# encoding: utf-8
require 'json'

module CslCli
  class Auth
    @token = nil
    @decoded_token = nil
    @csl_app_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :csl_app_url

    def initialize(api_url)
      @csl_app_url = api_url
    end

    def login(email, password)
      credentials = {auth: {email: email, password: password}}.to_json
      request_auth = CslCli::Request::Post.new(@csl_app_url + '/user_token', credentials, {"Content-Type" => "application/json"})
      if request_auth.code < 300
        @token = JSON.parse(request_auth.response.body)["jwt"]
        @decoded_token = {}
        @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
        @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))

        true
      end
    end

  end
end

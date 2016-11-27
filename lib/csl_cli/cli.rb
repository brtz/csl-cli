require 'thor'
require 'csl_cli'
require 'json'
require 'base64'

module CslCli
  class CLI < Thor

    desc 'login', 'Log in at csl app using environmet variables (csl_cli_email, csl_cli_password, csl_cli_app_url)'
    def login
      email = ENV['CSL_CLI_EMAIL']
      password = ENV['CSL_CLI_PASSWORD']
      app_url = ENV['CSL_CLI_APP_URL']

      abort 'email missing, please check environment variables' if email.nil?
      abort 'password missing, please check environment variables' if password.nil?
      abort 'app_url missing, please check environment variables' if app_url.nil?

      auth = CslCli::Auth.new(app_url)
      logged_in = auth.login(email, password)
      if logged_in
        tokenstore = CslCli::Tokenstore.new(ENV['HOME'])
        tokenstore.store(auth.token)
        puts "Successfully logged in (token saved to disk)"
      else
        abort 'wrong credentials'
      end


    end

    desc 'switch NOTE', 'creates a context switch with NOTE'
    def switch(note)
      token = nil
      decoded_token = {}

      app_url = ENV['CSL_CLI_APP_URL']

      abort 'app_url missing, please check environment variables' if app_url.nil?

      begin
        tokenstore = CslCli::Tokenstore.new(ENV['HOME'])
        token = tokenstore.load
      rescue
        abort 'Failed loading token from disk. Are you logged in?'
      end

      decoded_token['header'] = JSON.parse(Base64.decode64(token.split('.')[0]))
      decoded_token['payload'] = JSON.parse(Base64.decode64(token.split('.')[1]))

      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}", "Accept" => "application/json"}
      body = {note: note, user_id: decoded_token['payload']['sub']['$oid']}.to_json
      request = CslCli::Request::Post.new(app_url + "/switches/", body, headers)
      if request.code < 300
        response = request.response
        puts "Successfully created new context switch: #{response['created_at']}: #{response['id']}: #{response['note']}"
      else
        abort "Failed to create new note: #{request.response}"
      end
    end

  end
end

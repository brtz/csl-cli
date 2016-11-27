require 'csl_cli'
require 'thor'
require 'table_print'
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

    desc 'logout', 'removes the token from disk'
    def logout
      tokenstore = CslCli::Tokenstore.new(ENV['HOME'])
      tokenstore.clear
      puts "Successfully logged out (removed token from disk)"
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

    desc 'list', 'lists your context switches'
    option :show_all, type: :boolean, aliases: '-s'
    option :format, type: :string, aliases: '-f'
    def list
      token = nil
      decoded_token = {}
      query = ""

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

      query = "?limited=true" unless options[:show_all]

      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}", "Accept" => "application/json"}
      request = CslCli::Request::Get.new(app_url + "/switches/" + query, headers)
      if request.code < 400
        response = request.response

        case options[:format]
        when "csv"
          tp.set :separator, ","
          tp.set :max_width, 100000
        when "json"
          puts response.to_json
          exit
        end

        if options[:show_all]
          tp response, :except => [:updated_at, :url, :id]
        else
          tp response, :except => [:updated_at, :url, :id, :user_id]
        end
      else
        abort "Failed to list notes: #{request.response}"
      end
    end

  end
end

require 'thor'
require 'csl_cli'

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
      auth.login(email, password)
      p auth.token

    end

    desc 'switch NOTE', 'creates a context switch with NOTE'
    def switch(note)

    end

  end
end

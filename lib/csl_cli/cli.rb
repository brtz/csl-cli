require 'thor'
require 'csl_cli'

module CslCli
  class CLI < Thor

    desc 'login', 'Log in at csl app using environmet variables (csl_cli_email, csl_cli_password, csl_cli_app_url)'
    def login
      email = ENV['csl_cli_email']
      password = ENV['csl_cli_password']
      app_url = ENV['csl_cli_app_url']

      auth = CslCli::Auth.new(app_url)
      auth.login(email, password)
      p auth

    end

    desc 'switch NOTE', 'creates a context switch with NOTE'
    def switch(note)

    end

  end
end

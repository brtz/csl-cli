require 'thor'

module CslCli
  class CLI < Thor
    desc 'login', 'Log in at csl app'
    def login
      email = ENV['csl_cli_email']
      password = ENV['csl_cli_password']
      puts "login: #{email}:#{password}"
    end
  end
end

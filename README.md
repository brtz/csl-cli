# CslCli

This gem is the command line interface for the context switch logger (https://github.com/brtz/csl-app).

## Installation

If you wish to install this cli to your system run:

    $ gem install csl_cli

It is also available as a container: https://hub.docker.com/r/brtz/csl-cli/

## Usage

#### Configuration

The cli relies on a few settings. They can be provided as environment variables
or within a config file (~/.csv_config.json).

Example .csv_config.json:

    {
      "email": "yourEmail",
      "password": "yourPassword",
      "app_url": "http://yourappurl:port"
    }

Please make sure to chmod 0600 the config file, so only your user can read it.

If a config cannot be loaded, cslcli is going to fall back to these environment variables:

    CSL_CLI_EMAIL
    CSL_CLI_PASSWORD
    CSL_CLI_APP_URL

To run this gem as a container:

    docker run -it --rm --name cslcli -v "./localfolder:/root" brtz/csl-cli csl help

You can also drop the volume and pass the environment variables into the container (-e).

#### Commands

    $ csl --help
    Commands:
      csl help [COMMAND]  # Describe available commands or one specific command
      csl list            # lists your context switches
      csl login           # Log in at csl app using environmet variables (csl_cli_email, csl_cli_password, csl_cli_app_url)
      csl logout          # removes the token from disk
      csl switch NOTE     # creates a context switch with NOTE

The first step is to log in. This is done by calling:

      csl login

It will store the received token within ~/.csv_token. Once you are logged in, you can
create new context switches:

      csl switch "my first context switch"

If done right, you can now list them with:

      csl list

Please check csl help [COMMAND] for further options (like format on list command).


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brtz/csl-cli.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

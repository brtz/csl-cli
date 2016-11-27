# encoding: utf-8
require 'json'

module CslCli
  class Config

    @path = nil
    @configfile = nil

    def initialize(path)
      @path = path
      @configfile = File.join(@path, '.csl_config')
    end

    def load
      begin
        file = File.open(@configfile, 'rb')
        config = JSON.parse(file.read())
        file.close
        return config
      rescue
        return false
      end
    end

  end
end

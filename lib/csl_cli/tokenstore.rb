# encoding: utf-8

module CslCli
  class Tokenstore
    @path = ""
    @saved_token = nil

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def load
      file = File.open(File.join(@path, '.csl_token'), 'rb')
      @saved_token = file.read()
      file.close
      return @saved_token
    end

    def store(token)
      file = File.open(File.join(@path, '.csl_token'), 'w')
      file.write(token)
      file.close
      return true
    end

  end
end

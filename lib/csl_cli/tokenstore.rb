# encoding: utf-8

module CslCli
  class Tokenstore
    @path = ""
    @saved_token = nil
    @tokenfile = nil

    attr_reader :path

    def initialize(path)
      @path = path
      @tokenfile = File.join(@path, '.csl_token')
    end

    def load
      file = File.open(@tokenfile, 'rb')
      @saved_token = file.read()
      file.close
      return @saved_token
    end

    def store(token)
      file = File.open(@tokenfile, 'w')
      file.write(token)
      file.close
      File.chmod(0600, @tokenfile)
      return true
    end

    def clear
      File.delete(@tokenfile) if File.exist?(@tokenfile)
      return true
    end

  end
end

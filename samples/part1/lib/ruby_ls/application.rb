module RubyLS
  
  class Application

    def initialize

      @params = {}

      OptionParser.new do |opts|
        opts.on("-l") { params[:long] = true }
        opts.on("-a") { params[:all] = true }
      end.parse!

      params[:paths] = ARGV
      
      rescue OptionParser::InvalidOption => e 
      params[:invalid] = true
      params[:paths] = ARGV
    end

    def run
      Display.new(params).render
    end

    attr_accessor :params

  end

end
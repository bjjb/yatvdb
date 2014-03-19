require 'optparse'
require 'ostruct'
require 'yatvdb'
require 'yatvdb/version'

module YATVDB
  class CLI < OptionParser
    @@defaults = { verbose: false, format: :json }
    @@json_options = { indent: '  ', space: ' ', space_before: ' ', object_nl: "\n", array_nl: "\n" }

    def initialize(*args)
      @args, @options = args, OpenStruct.new(@@defaults)
      super() do
        option '-h', '--help', 'Print this message', :help
        option '-V', '--version', 'Show the YATVDB version', :version
        option '-l', '--language LANG', 'Choose the language (en)', :lang
        option '-v', '--verbose', 'Be noisier', :verbose
        option '-D', '--debug', 'Print out loads of information', :debug
        option '-s', '--search SHOW', 'Look up a TV show', :lookup
        option '-S', '--show ID', 'Get details about a TV show', :show
        option '-E', '--episode [EPISODEID]', 'Show episodes', :episode
      end
    end

    def lookup(show)
      results = YATVDB.lookup(URI::escape(show))
      puts format(results)
    end

    def lang(language)
      YATVDB.language = language.to_s.downcase
    end

    def debug(*args)
      $DEBUG = true
      YATVDB.logger.level = Logger::DEBUG
      puts "YATVDB v#{YATVDB::VERSION}"
      puts "      Config: #{YATVDB.config.inspect}"
      puts "Config Paths: #{YATVDB.config_paths.inspect}"
      puts "    Language: #{YATVDB.language}"
      puts "     API Key: #{YATVDB.api_key}"
      puts "    Base URI: #{YATVDB.base_uri}"
    end

    def verbose(*args)
      $VERBOSE = 1
    end

    def show(id)
      @show = YATVDB.fetch_series(id)
    end

    def episode(id)
      @episodes = @show.episodes
      @episode = @episodes.find { |e| e.id == id.to_i } if id
    end

    def list(id)
      show = YATVDB.fetch_series(id)
      puts format(show.seasons)
    end

    def option(short, long, desc, method)
      on(short, long, desc, &method(method))
    end

    def help(*args)
      puts to_s
      throw :done  
    end

    def self.help
      new.help
    end

    def version(*args)
      puts "#{program_name} v#{YATVDB::VERSION}"
      throw :done
    end

    def start
      catch(:done) do
        help if @args.empty?
        order!(@args)
        raise "Unknown command: #{@args.shift}" unless @args.empty?
        if @episode
          puts format(@episode)
        elsif @episodes
          puts format(@episodes)
        elsif @show
          puts format(@show)
        end
      end
    end

    def format(something)
      case @options.format.to_s
        when /json/i then JSON.generate(something, @@json_options)
        else raise "Unknown format"
      end
    end

    def self.start(args = ARGV)
      new(*args).start
    end
  end
end

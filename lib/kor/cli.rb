require 'optparse'
require "kor/input/base"
require "kor/output/base"

module Kor
  class Cli
    USAGE = <<-USAGE
kor [option] [input-plugin] [input-option] [output-plugin] [output-option]
example:
  $ kor --sync csv markdown --strip
USAGE

    def initialize(argv = ARGV, input_io = $stdin, output_io = $stdout)
      @argv = argv
      @input_io = input_io
      @output_io = output_io

      @cli_args = []
      while argv.first && argv.first[0] == "-"
        @cli_args << argv.shift
      end

      @input_plugin = argv.shift
      @input_args = []
      while argv.first && argv.first[0] == "-"
        @input_args << argv.shift
      end

      @output_plugin = argv.shift
      @output_args = []
      while argv.first && argv.first[0] == "-"
        @output_args << argv.shift
      end
    end

    def run
      cli_opt = OptionParser.new
      cli_opt.on("--sync", "I/O sync mode") do |arg|
        @input_io.sync = true
        @output_io.sync = true
      end
      cli_opt.parse(@cli_args)

      unless @input_plugin
        @output_io.puts Cli::USAGE
        exit 0
      end

      require_plugin "kor/input/#{@input_plugin}"
      in_class = Kor::Input.const_get(@input_plugin.capitalize)
      in_obj = in_class.new(@input_io)
      in_opt = OptionParser.new
      in_obj.parse(in_opt)
      in_opt.parse(@input_args)

      unless @output_plugin
        @output_io.puts Cli::USAGE
        exit 0
      end

      require_plugin "kor/output/#{@output_plugin}"
      out_class = Kor::Output.const_get(@output_plugin.capitalize)
      out_obj = out_class.new(@output_io)
      out_opt = OptionParser.new
      out_obj.parse(out_opt)
      out_opt.parse(@output_args)

      out_obj.head(in_obj.head)
      while body = in_obj.gets
        out_obj.puts(body)
      end
      out_obj.finish
    end

    private

    def require_plugin(name)
      require name
    rescue LoadError
      warn "LoadError: `#{name}' plugin not found"
      exit 1
    end
  end
end

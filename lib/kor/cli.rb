require 'optparse'
require 'thread'
require "kor/input/base"
require "kor/output/base"

module Kor
  class Cli
    def initialize(argv = ARGV, input_io = $stdin, output_io = $stdout)
      @argv = argv
      @input_io = input_io
      @output_io = output_io

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
      unless @input_plugin && @output_plugin
        @output_io.puts <<-USAGE
kor [input-plugin] [input-option] [output-plugin] [output-option]
example:
  $ kor csv markdown
USAGE
        exit 0
      end

      require "kor/input/#{@input_plugin}"
      require "kor/output/#{@output_plugin}"

      in_class = Kor::Input.const_get(@input_plugin.capitalize)
      out_class = Kor::Output.const_get(@output_plugin.capitalize)
      in_obj = in_class.new(@input_io)
      out_obj = out_class.new(@output_io)

      in_opt = OptionParser.new
      out_opt = OptionParser.new
      in_obj.parse(in_opt)
      out_obj.parse(out_opt)
      in_opt.parse(@input_args)
      out_opt.parse(@output_args)

      out_obj.head(in_obj.head)
      while body = in_obj.gets
        out_obj.puts(body)
      end
      out_obj.finish
    end
  end
end

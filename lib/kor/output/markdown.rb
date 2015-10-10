module Kor
  module Output
    class Markdown < Base
      def parse(opt)
        @space = " "
        opt.on("--strip", "strip space") do |arg|
          @space = ""
        end
        opt.on("--key=KEY", "select output keys (like foo,bar,baz)") do |arg|
          @select_key = arg
        end
      end

      def head(keys)
        if @select_key
          select_keys = @select_key.split(",")
          select_keys.select!{ |key| keys.include?(key) }
          @select_key = select_keys.map do |key|
            keys.index(key)
          end
          keys = select_keys
        end
        s = @space || " "
        io.puts "|#{s}#{keys.join("#{s}|#{s}")}#{s}|"
        io.puts "|#{s}#{(["---"] * keys.length).join("#{s}|#{s}")}#{s}|"
      end

      def puts(values)
        if @select_key
          s = @space || " "
          io.puts "|#{s}#{@select_key.map{ |index| values[index] }.join("#{s}|#{s}")}#{s}|"
        else
          s = @space || " "
          io.puts "|#{s}#{values.join("#{s}|#{s}")}#{s}|"
        end
      end
    end
  end
end

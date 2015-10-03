module Kor
  module Output
    class Markdown < Base
      def parse(opt)
        @space = " "
        opt.on("--strip", "strip space") do |arg|
          @space = ""
        end
      end

      def head(keys)
        s = @space || " "
        io.puts "|#{s}#{keys.join("#{s}|#{s}")}#{s}|"
        io.puts "|#{s}#{(["---"] * keys.length).join("#{s}|#{s}")}#{s}|"
      end

      def puts(values)
        s = @space || " "
        io.puts "|#{s}#{values.join("#{s}|#{s}")}#{s}|"
      end
    end
  end
end

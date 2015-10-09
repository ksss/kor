module Kor
  module Input
    class Markdown < Base
      def parse(opt)
        opt.on("--key=KEY", "filter key set (e.g. foo,bar,baz)") do |arg|
          @filter_key = arg
        end
      end

      def head
        line = io.gets.strip
        first_index = line[0] == '|' ? 1 : 0
        keys = line.split('|')[first_index..-1].map(&:strip)
        # skip separate line
        io.gets
        if @filter_key
          @filter_key = @filter_key.split(",").map do |key|
            if index = keys.index(key)
              index
            else
              raise NotKeyError, "`#{key}' is a not key of this table"
            end
          end
          keys = @filter_key.map{ |index| keys[index] }
        end
        keys
      end

      def gets
        if line = io.gets
          first_index = line[0] == '|' ? 1 : 0
          body = line.strip.split('|')[first_index..-1].map(&:strip)
          if @filter_key
            return @filter_key.map{ |index| body[index] }
          end
          body
        else
          nil
        end
      end
    end
  end
end

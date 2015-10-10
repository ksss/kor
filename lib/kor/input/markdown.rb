module Kor
  module Input
    class Markdown < Base
      def parse(opt)
        opt.on("--key=KEY", "filter key set (e.g. foo,bar,baz)") do |arg|
          @filter_key = arg
        end
      end

      def head
        line = io.gets
        raise ReadError, "cannot get markdown header" unless line
        line.strip!
        first_index = line[0] == '|' ? 1 : 0
        keys = line.split('|')[first_index..-1].map(&:strip)
        # skip separate line
        io.gets
        if @filter_key
          filter_keys = @filter_key.split(",")
          filter_keys = keys.select { |key|
            filter_keys.include?(key)
          }
          keys = filter_keys
          @filter_key = filter_keys.map { |key| keys.index(key) }
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

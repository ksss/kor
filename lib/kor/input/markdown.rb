module Kor
  module Input
    class Markdown < Base
      def head
        line = io.gets.strip
        first_index = line[0] == '|' ? 1 : 0
        h = line.split('|')[first_index..-1].map(&:strip)
        # skip separate line
        io.gets
        h
      end

      def gets
        if line = io.gets
          first_index = line[0] == '|' ? 1 : 0
          line.strip.split('|')[first_index..-1].map(&:strip)
        else
          nil
        end
      end
    end
  end
end

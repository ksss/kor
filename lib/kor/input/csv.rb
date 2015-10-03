module Kor
  module Input
    class Csv < Base
      DELIM = ","

      def head
        io.gets.chomp.split(self.class::DELIM).map(&:strip)
      end

      def gets
        if line = io.gets
          line.chomp.split(self.class::DELIM).map(&:strip)
        else
          nil
        end
      end
    end
  end
end

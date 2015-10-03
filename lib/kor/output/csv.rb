module Kor
  module Output
    class Csv < Base
      DELIM = ","

      def head(keys)
        io.puts keys.join(self.class::DELIM)
      end

      def puts(values)
        io.puts values.join(self.class::DELIM)
      end
    end
  end
end

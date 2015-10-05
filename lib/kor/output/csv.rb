module Kor
  module Output
    class Csv < Base
      DELIM = ","

      def head(keys)
        io.puts keys.map{|k| "\"#{k}\""}.join(self.class::DELIM)
      end

      def puts(values)
        io.puts values.map{|k| "\"#{k}\""}.join(self.class::DELIM)
      end
    end
  end
end

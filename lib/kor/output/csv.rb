require 'csv'

module Kor
  module Output
    class Csv < Base
      DELIM = ","

      def head(keys)
        io.puts keys.to_csv(col_sep: self.class::DELIM)
      end

      def puts(values)
        io.puts values.to_csv(col_sep: self.class::DELIM)
      end
    end
  end
end

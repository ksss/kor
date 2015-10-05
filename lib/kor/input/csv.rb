require 'csv'

module Kor
  module Input
    class Csv < Base
      class ReadError < StandardError
      end

      DELIM = ","

      def head
        if line = io.gets
          ::CSV.new(line.strip, col_sep: self.class::DELIM).gets
        else
          raise ReadError, "cannot get csv header"
        end
      end

      def gets
        if line = io.gets
          ::CSV.new(line.strip, col_sep: self.class::DELIM).gets
        else
          nil
        end
      end
    end
  end
end

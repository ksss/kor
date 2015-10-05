require 'kor/output/csv'

module Kor
  module Output
    class Tsv < Csv
      DELIM = "\t"
    end
  end
end

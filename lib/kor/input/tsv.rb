require 'kor/input/csv'

module Kor
  module Input
    class Tsv < Csv
      DELIM = "\t"
    end
  end
end

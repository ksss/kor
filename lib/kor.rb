module Kor
  class NotKeyError < StandardError
    def initialize(*)
      super
      warn "[DEPRECATED] Kot::NotKeyError was deprecated"
    end
  end

  class ReadError < StandardError
  end

  require "kor/cli"
  require "kor/version"
end

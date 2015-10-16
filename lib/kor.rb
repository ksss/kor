module Kor
  class NotKeyError < StandardError
    def initialize(*)
      super
      warn "[DEPRECATED] #{self.class} was deprecated"
    end
  end

  class ReadError < StandardError
  end

  require "kor/cli"
  require "kor/version"
end

module Kor
  class NotKeyError < StandardError
  end
  class ReadError < StandardError
  end

  require "kor/cli"
  require "kor/version"
end

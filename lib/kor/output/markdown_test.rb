require 'kor'
require 'kor/output/markdown'

module KorOutputCsvTest
  def test_head(t)
    io = StringIO.new
    csv = Kor::Output::Markdown.new(io)
    csv.head(%w(foo bar baz))
    if io.string != "| foo | bar | baz |\n| --- | --- | --- |\n"
      t.error("expect output '| foo | bar | baz |\\n| --- | --- | --- |\\n' got #{io.string.inspect}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    csv = Kor::Output::Markdown.new(io)
    csv.puts(%w(aaa bbb ccc))
    if io.string != "| aaa | bbb | ccc |\n"
      t.error("expect output '| aaa | bbb | ccc |\\n' got #{io.string.inspect}")
    end
  end
end

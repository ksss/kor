require 'kor'
require 'kor/output/tsv'

module KorOutputTsvTest
  def test_head(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.head(%w(foo bar baz))
    if io.string != "foo\tbar\tbaz\n"
      t.error("expect output 'foo\\tbar\\tbaz\\n' got #{io.string.inspect}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.puts(%w(aaa bbb ccc))
    if io.string != "aaa\tbbb\tccc\n"
      t.error("expect output 'aaa\\tbbb\\tccc\\n' got #{io.string.inspect}")
    end
  end
end

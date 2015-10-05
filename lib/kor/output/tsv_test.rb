require 'kor'
require 'kor/output/tsv'

module KorOutputTsvTest
  def test_head(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.head(["foo", "bar", "baz\tqux"])
    expect = %Q{"foo"\t"bar"\t"baz\tqux"\n}
    if io.string != expect
      t.error("expect output #{expect.inspect} got #{io.string.inspect}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.puts(["aaa", "bbb\tccc", "ddd"])
    expect = %Q{"aaa"\t"bbb\tccc"\t"ddd"\n}
    if io.string != expect
      t.error("expect output #{expect.inspect} got #{io.string.inspect}")
    end
  end
end

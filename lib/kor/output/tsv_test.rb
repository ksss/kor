require 'kor'
require 'kor/output/tsv'

module KorOutputTsvTest
  def test_head(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.head(["foo", "bar", "baz\tqux", nil])
    expect = %Q{foo\tbar\t"baz\tqux"\t\n}
    if io.string != expect
      t.error("expect output #{expect.inspect} got #{io.string.inspect}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    tsv = Kor::Output::Tsv.new(io)
    tsv.puts([nil, "aaa", "bbb\tccc", "ddd"])
    expect = %Q{\taaa\t"bbb\tccc"\tddd\n}
    if io.string != expect
      t.error("expect output #{expect.inspect} got #{io.string.inspect}")
    end
  end
end

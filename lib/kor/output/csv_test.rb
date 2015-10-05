require 'kor'
require 'kor/output/csv'

module KorOutputCsvTest
  def test_head(t)
    io = StringIO.new
    csv = Kor::Output::Csv.new(io)
    csv.head(%w(foo bar baz,qux))
    expect = %Q{"foo","bar","baz,qux"\n}
    if io.string != expect
      t.error("expect output #{expect} got #{io.string.inspect}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    csv = Kor::Output::Csv.new(io)
    csv.puts(%w(aaa bbb,ccc ddd))
    expect = %Q{"aaa","bbb,ccc","ddd"\n}
    if io.string != expect
      t.error("expect output #{expect} got #{io.string.inspect}")
    end
  end
end

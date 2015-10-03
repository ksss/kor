require 'kor'
require 'kor/input/tsv'

module KorInputTsvTest
  def test_main(m)
    @io = StringIO.new(<<-TSV)
foo\tbar\tbaz
1\t2\t3
a\tb\tc
TSV
    exit m.run
  end

  def test_head(t)
    @io.rewind
    tsv = Kor::Input::Tsv.new(@io)
    head = tsv.head
    if head != %w(foo bar baz)
      t.error("expect #{%w(foo bar baz)} got #{head}")
    end
  end

  def test_gets(t)
    @io.rewind
    tsv = Kor::Input::Tsv.new(@io)
    tsv.head

    value = tsv.gets
    if value != %w(1 2 3)
      t.error("expect #{%w(1 2 3)} got #{value}")
    end
    value = tsv.gets
    if value != %w(a b c)
      t.error("expect #{%w(a b c)} got #{value}")
    end
    2.times do
      value = tsv.gets
      if value != nil
        t.error("expect nil got #{value}")
      end
    end
  end
end

require 'kor'
require 'kor/input/csv'

module KorInputCsvTest
  def test_main(m)
    @io = StringIO.new(<<-CSV)
foo,bar,baz
1,2,3
a,b,c
CSV
    exit m.run
  end

  def test_head(t)
    @io.rewind
    csv = Kor::Input::Csv.new(@io)
    head = csv.head
    if head != %w(foo bar baz)
      t.error("expect #{%w(foo bar baz)} got #{head}")
    end
  end

  def test_gets(t)
    @io.rewind
    csv = Kor::Input::Csv.new(@io)
    csv.head

    value = csv.gets
    if value != %w(1 2 3)
      t.error("expect #{%w(1 2 3)} got #{value}")
    end
    value = csv.gets
    if value != %w(a b c)
      t.error("expect #{%w(a b c)} got #{value}")
    end
    2.times do
      value = csv.gets
      if value != nil
        t.error("expect nil got #{value}")
      end
    end
  end
end

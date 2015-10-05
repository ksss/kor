require 'kor'
require 'kor/input/csv'

module KorInputCsvTest
  def test_main(m)
    @io = StringIO.new(<<-CSV)
foo,bar,"baz,qux"
1,"2,3,4",5
a,b,c
CSV
    exit m.run
  end

  def test_head(t)
    @io.rewind
    csv = Kor::Input::Csv.new(@io)
    head = csv.head
    if head != %w(foo bar baz,qux)
      t.error("expect #{%w(foo bar baz,qux)} got #{head}")
    end

    io2 = StringIO.new("")
    csv = Kor::Input::Csv.new(io2)
    head, err = go { csv.head }
    unless Kor::Input::Csv::ReadError === err
      t.error("expect Kor::Input::Csv::ReadError got #{err.class}:#{err}")
    end
  end

  def test_gets(t)
    @io.rewind
    csv = Kor::Input::Csv.new(@io)
    csv.head

    value = csv.gets
    if value != %w(1 2,3,4 5)
      t.error("expect #{%w(1 2,3,4 5)} got #{value}")
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

  private

  def go
    [yield, nil]
  rescue Exception => err
    [nil, err]
  end
end

require 'kor'
require 'kor/input/markdown'

module KorInputMarkdownTest
  def test_main(m)
    @io = StringIO.new(<<-MARKDOWN)
| foo | bar | baz |
| --- | --- | --- |
|  1  |  2  |  3  |
|  a  |  b  |  c  |
MARKDOWN
    @io2 = StringIO.new(<<-MARKDOWN)
foo | bar | baz |
--- | --- | ---
| 1  |  2  |  3
a  |  b  |  c |
MARKDOWN
    exit m.run
  end

  def test_head(t)
    @io.rewind
    md = Kor::Input::Markdown.new(@io)
    head = md.head
    if head != %w(foo bar baz)
      t.error("expect #{%w(foo bar baz)} got #{head}")
    end

    @io2.rewind
    md = Kor::Input::Markdown.new(@io2)
    head = md.head
    if head != %w(foo bar baz)
      t.error("expect #{%w(foo bar baz)} got #{head}")
    end
  end

  def test_with_key(t)
    @io.rewind
    md = Kor::Input::Markdown.new(@io)
    opt = OptionParser.new
    md.parse(opt)

    opt.parse ["--key=bar,nothing"]
    _, err = go { md.head }
    unless Kor::NotKeyError === err
      t.error("expect raise an error Kor::NotKeyError got #{err.class}:#{err}")
    end

    @io.rewind
    opt.parse ["--key=bar,foo"]
    actual = md.head
    expect = %w(bar foo)
    if actual != expect
      t.error("expect #{expect} got #{actual}")
    end

    expects = [
      %w(2 1),
      %w(b a),
      nil, nil, nil, nil, nil
    ].each do |expect|
      actual = md.gets
      if actual != expect
        t.error("expect #{expect} got #{actual}")
      end
    end
  end

  def test_gets(t)
    @io.rewind
    md = Kor::Input::Markdown.new(@io)
    md.head

    value = md.gets
    if value != %w(1 2 3)
      t.error("expect #{%w(1 2 3)} got #{value}")
    end
    value = md.gets
    if value != %w(a b c)
      t.error("expect #{%w(a b c)} got #{value}")
    end
    2.times do
      value = md.gets
      if value != nil
        t.error("expect nil got #{value}")
      end
    end

    @io2.rewind
    md = Kor::Input::Markdown.new(@io2)
    md.head

    value = md.gets
    if value != %w(1 2 3)
      t.error("expect #{%w(1 2 3)} got #{value}")
    end
    value = md.gets
    if value != %w(a b c)
      t.error("expect #{%w(a b c)} got #{value}")
    end
    2.times do
      value = md.gets
      if value != nil
        t.error("expect nil got #{value}")
      end
    end
  end

  def go
    [yield, nil]
  rescue Exception => err
    [nil, err]
  end
end

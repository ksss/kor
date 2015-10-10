require 'kor'
require 'kor/output/markdown'

module KorOutputMarkdownTest
  def test_head(t)
    io = StringIO.new
    md = Kor::Output::Markdown.new(io)
    md.head(%w(foo bar baz))
    if io.string != "| foo | bar | baz |\n| --- | --- | --- |\n"
      t.error("expect output '| foo | bar | baz |\\n| --- | --- | --- |\\n' got #{io.string.inspect}")
    end
  end

  def test_head_with_key(t)
    io = StringIO.new
    md = Kor::Output::Markdown.new(io)
    opt = OptionParser.new
    md.parse(opt)

    opt.parse ["--key=bar,foo,non"]
    _, err = go { md.head(["foo", "bar", "baz"]) }
    t.error("expect not raise got #{err.class}:#{err}") if err
    if io.string != "| bar | foo |\n| --- | --- |\n"
      t.error("expect bar,foo header got #{io.string}")
    end
  end

  def test_puts(t)
    io = StringIO.new
    md = Kor::Output::Markdown.new(io)
    md.puts(%w(aaa bbb ccc))
    if io.string != "| aaa | bbb | ccc |\n"
      t.error("expect output '| aaa | bbb | ccc |\\n' got #{io.string.inspect}")
    end
  end

  def test_puts_with_key(t)
    io = StringIO.new
    md = Kor::Output::Markdown.new(io)
    opt = OptionParser.new
    md.parse(opt)
    opt.parse ["--key=bar,foo"]
    md.head %w(foo bar baz)
    md.puts %w(aaa bbb ccc)
    md.puts %w(100 200 300)
    io.rewind
    io.gets
    io.gets
    actual = io.gets
    if actual != "| bbb | aaa |\n"
      t.error("expect output '| bbb | aaa |\\n' got #{actual}")
    end

    actual = io.gets
    if actual != "| 200 | 100 |\n"
      t.error("expect output '| 200 | 100 |\\n' got #{actual}")
    end
  end

  def go
    [yield, nil]
  rescue Exception => err
    [nil, err]
  end
end

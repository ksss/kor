require 'kor'

module KorCliTest
  def test_new(t)
    cli = Kor::Cli.new
    unless cli.kind_of?(Kor::Cli)
      t.error("expect instance of Kor::Cli got #{cli}")
    end
  end

  def test_run(t)
    input_io = StringIO.new
    output_io = StringIO.new
    cli = Kor::Cli.new(["base"], input_io, output_io)
    ret, err = go { cli.run }
    unless SystemExit === err
      t.error("expect raise SystemExit got #{err.class}:#{err.to_s}")
    end

    input = StringIO.new("input")
    output = StringIO.new("output")
    cli = Kor::Cli.new(["base", "base"], input, output)
    cli.run
    if input.string != "input"
      t.error("expect base input plugin string \"input\" got #{input.string}")
    end
    if output.string != "output"
      t.error("expect base output plugin string \"output\" got #{output.string}")
    end
  end

  def test_e2e(t)
    actual = `#{<<-COMMAND}`
cat << CSV | kor csv markdown
foo,bar,baz
100,200,300
400,500,600
CSV
COMMAND
    expect = <<-MARKDOWN
| foo | bar | baz |
| --- | --- | --- |
| 100 | 200 | 300 |
| 400 | 500 | 600 |
MARKDOWN
    if actual != expect
      t.error("actual output not match to expect output.")
    end
  end

  private

  def go
    [yield, nil]
  rescue Exception => err
    [nil, err]
  end
end

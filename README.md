Kor
===

[![Build Status](https://travis-ci.org/ksss/kor.svg)](https://travis-ci.org/ksss/kor)

**Kor** is a pluggable table data converter.

```
+----------+    +-----+    +----------+
|   csv    | => |     | => |   csv    |
+----------+    |     |    +----------+
+----------+    |     |    +----------+
|   tsv    | => | kor | => |   tsv    |
+----------+    |     |    +----------+
+----------+    |     |    +----------+
| markdown | => |     | => | markdown |
+----------+    +-----+    +----------+
```

```
$ cat table.csv
from \ to,markdown,csv,tsv
markdown,ok,ok,ok
csv,ok,ok,ok
tsv,ok,ok,ok

$ kor csv markdown < table.csv
| from \ to | markdown | csv | tsv |
| --- | --- | --- | --- |
| markdown | ok | ok | ok |
| csv | ok | ok | ok |
| tsv | ok | ok | ok |
```

# Cli

Kor have command line interface.

Input from stdin and output to stdout.

## Option

```
$ kor
kor [option] [input-plugin] [input-option] [output-plugin] [output-option]
example:
  $ kor --sync csv markdown --strip
```

### input-plugin

Input plugin name.
If you set `name` that `require "kor/input/name"` And call `Kor::Input::Name.new`
By default, you can use csv,tsv,markdown.

### input-option

input-plugin have distinctive option.
Should be start `-` and join key and value with `=` like `--key=value`.

### output-plugin

Output plugin name.
If you set `name` that `require "kor/output/name"` And call `Kor::Output::Name.new`
By default, you can use csv,tsv,markdown.

### output-option

output-plugin have distinctive option.
Should be start `-` and join key and value with `=` like `--key=value`.

# Plugin

Kor have plugin system.

You can extend input and output support format.

Embed format is that input **csv**,**tsv**,**markdown** and output **csv**,**tsv**,**markdown**

Plugin just only write class of Ruby.

And input and output run sequential processing like this.

```ruby
out_obj.head(in_obj.head)
while body = in_obj.gets
  out_obj.puts(body)
end
out_obj.finish
```

## Extend plugins

- https://github.com/ksss/kor-input-json
- https://github.com/ksss/kor-output-json
- https://github.com/ksss/kor-input-ltsv
- https://github.com/ksss/kor-output-ltsv
- https://github.com/ksss/kor-input-yaml
- https://github.com/ksss/kor-output-yaml

## Input

Input plugin read data by I/O and make data of keys and values.

keys read by `head` method.

values read by `gets` method.

`gets` method should be designed to read only one line.

This is an example for **Coron separated values** table.

```ruby
module Kor
  module Input
    class Coronsv < Base
      # head method should be return Array of key name
      def head
        # io is input IO object (default $stdin)
        io.gets.split(':').map(&:strip)
      end

      # gets method should be return Array of values or nil
      # Stop read loop when return nil
      def gets
        if line = io.gets
          line.chomp.split(':').map(&:strip)
        else
          nil
        end
      end
    end
  end
end
```

## Output

Output plugin write data to I/O from input keys and values.

keys write by `head` method.

values write by `puts` method.

`puts` method should be designed to write only one line.

This is and example for **Coron separated values** table.

```ruby
module Kor
  module Output
    class Coronsv < Base
      # You can set cli option.
      # $ kor [input-plugin] coronsv --hello=world
      # Hello, world
      def parse(opt)
        opt.on("--hello") do |arg|
          io.puts "Hello, #{arg}"
        end
      end

      # At first, run `head` method with `keys`
      # keys is object of returned by input-plugin `head` method.
      # `head` should be print output string to I/O.
      def head(keys)
        # `io` is output I/O object (default $stdout)
        io.puts keys.join(':')
      end

      # `puts` method each call by input-plugin `gets`.
      # values is object of returned by input-plugin `gets` method.
      # `puts` should be print output string to I/O
      def puts(values)
        io.puts values.join(':')
      end
    end
  end
end
```

But in most cases separated values table can make from `sed` command like this

```shell
$ kor markdown csv < table.md | sed 's/,/:/g'
from \ to:markdown:csv:tsv
markdown:ok:ok:ok
csv:ok:ok:ok
tsv:ok:ok:ok
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kor

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ksss/kor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

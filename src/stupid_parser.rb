class StupidParser
  def parse(filename, &block)
    File.open(filename).each_line do |line|
      block.call(parse_text(line))
    end
  end

  def parse_text(text)
    if text.method?
      return {:type => :method, :name => method_name_from(text),
              :arguments => arguments_from(text)}
    end

    if text.comment?
      return {:type => :comment, :text => comment_from(text)}
    end

    {:type => :unknown}
  end

  private
  def arguments_from text
    argument_string = text.strip.split(/\s+|\(|\)/, 3)[2].strip
    if argument_string.end_with?(")")
      argument_string.chop!
    end
    argument_string.split(",").map { |it|
      it = it.strip.split(" ", 2)[0]
      if it.start_with?("*")
        {:name => it[1..-1], :type => :array}
      else
        {:name => it}
      end
    }
  end

  def comment_from text
    text.strip.sub(/^#/, "").strip
  end

  def method_name_from text
    text.strip.split(/\s+|\(/, 3)[1]
  end
end

class String
  def method?
    strip.start_with? "def "
  end

  def comment?
    strip.start_with? "#"
  end
end
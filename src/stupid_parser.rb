class StupidParser
  def parse(filename, &block)
    File.open(filename).each_line do |line|
      block.call(parse_text(line))
    end
  end

  def parse_text(text)
    if text.method?
      return {:type => :method, :name => method_name_from(text)}
    end

    if text.comment?
      return {:type => :comment, :text => comment_from(text)}
    end

    {:type => :unknown}
  end

  private
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
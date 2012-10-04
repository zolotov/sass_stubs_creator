class StubBuilder
  def function(method_name, options = {})
    raise Exception.new("Method name cannot be empty") if method_name.nil? or method_name.empty?
    result = ""
    result << comments(options[:comments])
    arguments = arguments(options[:arguments])
    result << "@function #{method_name}(#{arguments}) { /* stub */ }"
  end

  def comments(comments = [])
    if comments.nil? or comments.size == 0
      ""
    else
      "/**\n#{comments.map { |it| " * #{it}\n" }.join()} */\n"
    end
  end

  def arguments(descriptors = {})
    if descriptors.nil?
      ""
    else
      descriptors.map { |it| argument(it) }.join(", ")
    end
  end

  def argument(descriptor = {})
    raise Exception.new("Method name cannot be empty") if descriptor[:name].nil? or descriptor[:name].empty?
    postfix = descriptor[:type] == :array ? "..." : ""
    "$#{descriptor[:name]}#{postfix}"
  end
end
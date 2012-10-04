# encoding: utf-8
require_relative "src/stupid_parser"
require_relative "src/stub_builder"
require_relative "settings"

def path(*str)
  File.join(File.dirname(__FILE__), str)
end

def load_sass_gem(sass_lib_path, sass_git_repo)
  begin
    require sass_lib_path
  rescue LoadError
    puts 'Cloning Sass'
    `git clone #{sass_git_repo}`
    begin
      require sass_lib_path
    rescue LoadError
      puts "Sass library not found "
      exit(1)
    end
  end
end

load_sass_gem(path(Settings.sass_lib_path), Settings.sass_git_repo)
sass_functions = Sass::Script::Functions.instance_methods
parser = StupidParser.new
builder = StubBuilder.new
comments_collector = []
parser.parse(path(Settings.sass_lib_path, Settings.functions_path)) do |it|
  if it[:type] == :method && sass_functions.include?(it[:name].to_sym)
    puts builder.function(it[:name], :comments => comments_collector, :arguments => it[:arguments])
    puts
  end

  if it[:type] == :comment
    comments_collector << it[:text]
  else
    comments_collector.clear
  end
end
module Settings
  extend self

  @config = {
      :sass_git_repo => "https://github.com/nex3/sass.git",
      :sass_lib_path => "sass/lib/sass",
      :functions_path => "script/functions.rb"
  }

  #noinspection RubyUnusedLocalVariable
  def method_missing(name, *args, &block)
    @config[name.to_sym] || fail(NoMethodError, "unknown parameter #{name}", caller)
  end
end
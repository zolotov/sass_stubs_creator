require_relative "spec_helper"

describe StubBuilder do

  before :each do
    @builder = StubBuilder.new
  end

  it "should build function" do
    @builder.function("function_name").should == "@function function_name() { /* stub */ }"
  end

  it "should build function with doc-string" do
    function = @builder.function("function_name", :comments => ["comment line 1", "comment line 2"])
    function.should == "/**\n" +
        " * comment line 1\n" +
        " * comment line 2\n" +
        " */\n" +
        "@function function_name() { /* stub */ }"
  end

  it "should build function with arguments" do
    function = @builder.function("function_name",
                                 :arguments => [{:name => "arg1"}, {:name => "arg2"}])
    function.should == "@function function_name($arg1, $arg2) { /* stub */ }"
  end

  it "should build complex function" do
    function = @builder.function("name", :arguments => [{:name => "arg1"}], :comments => %w(comment))
    function.should == "/**\n * comment\n */\n@function name($arg1) { /* stub */ }"
  end

  it "should build vararg arguments" do
    function = @builder.function("function_name",
                                 :arguments => [{:name => "arg1"}, {:name => "arg2", :type => :array}])
    function.should == "@function function_name($arg1, $arg2...) { /* stub */ }"
  end

  it "should throw error on empty method name" do
    expect { @builder.function(nil) }.to raise_error(Exception)
    expect { @builder.function("") }.to raise_error(Exception)
  end

  it "should throw error on empty argument name" do
    expect { @builder.function("name", :arguments => [{:name => ""}]) }.to raise_error(Exception)
    expect { @builder.function("name", :arguments => [{}]) }.to raise_error(Exception)
  end
end
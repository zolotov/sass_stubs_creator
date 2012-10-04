require_relative "spec_helper"

describe StupidParser do
  before :each do
    @parser = StupidParser.new
  end

  it "should parse method" do
    result = @parser.parse_text "def method_name(arg1, *arg2)"
    result[:type].should == :method
    result[:name].should == "method_name"
    result[:arguments].should == [
        {:name => "arg1"},
        {:name => "arg2", :type => :array}
    ]
  end

  it "should parse comment" do
    result = @parser.parse_text "  # some comment line"
    result[:type].should == :comment
    result[:text].should == "some comment line"
  end

  it "should be able to return unknown type" do
    result = @parser.parse_text "  some unknown line line"
    result[:type].should == :unknown
  end
end
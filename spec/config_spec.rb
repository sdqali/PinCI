require 'rubygems'
require File.dirname(__FILE__)+'/../lib/pinci/pinci.rb'

include PinCI
describe Config do
  before { Config = PinCI::Config}
  it "parses filter from a valid config file" do
    Dir.chdir 'spec/data/valid-config' do
      Config.new.filter.should == "**/*"
    end
  end
end

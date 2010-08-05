require 'rubygems'
require File.dirname(__FILE__)+'/../lib/pinci/pinci.rb'

include PinCI
describe Config do
  before { Config = PinCI::Config}
  context "valid config" do
    it "parses filter" do
      Dir.chdir 'spec/data/valid-config' do
        Config.new.filter.should == "**/*"
      end
    end

    it "parses exec" do
      Dir.chdir 'spec/data/valid-config' do
        Config.new.exec.should == "ls -la"
      end
    end
  end
end

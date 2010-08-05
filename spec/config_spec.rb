require 'rubygems'
require File.dirname(__FILE__)+'/../lib/pinci/pinci.rb'

Config = PinCI::Config

include PinCI
describe Config do
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

  context "invalid config" do
    it "should throw error while parsing filter" do
      Dir.chdir 'spec/data/invalid-config' do
        lambda {Config.new.filter}.should raise_error
      end
    end

    it "should throw error while parsing exec" do
      Dir.chdir 'spec/data/invalid-config' do
        lambda {Config.new.exec}.should raise_error
      end
    end
  end
end

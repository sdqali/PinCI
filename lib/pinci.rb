#!/bin/env ruby

require 'observer'
require 'yaml'

CONFIG_FILE = "pin.ci"

module PinCI 
  class App
    def self.run
      Validator.validate
      config = Config.new
      file_list = FileList.files(config.filter)
      monitor = Monitor.new(file_list)
      action = Action.new(config.exec)
      monitor.add_observer action
      monitor.run
    end 
  end

  class Validator
    def self.validate
      abort_with_error if config_file_missing?
    end

    private
    def self.abort_with_error
      error_message = <<-TEXT
CI file pin.ci does not exist!
Exiting...
        TEXT
      abort error_message
    end

    def self.config_file_missing?
      !(File.exist? CONFIG_FILE) || (File.directory? CONFIG_FILE)
    end
  end

  class Config
    def initialize
      @data = YAML.load_file(CONFIG_FILE)
    end

    def filter
      @data['filter']
    end

    def exec
      @data['exec']
    end
  end

  class FileList
    def self.files(filter)
      #TODO: return a list of absolute paths
      Dir.glob(filter)
    end
  end
  
  class Monitor
    include Observable
    
    def initialize files
      @files = {}
      now = Time.now
      files.each do |f|
        @files[f] = now
      end
    end

    def run
      while true do
        changed_files = []
        @files.each_key do |file|
          mtime = File.stat(file).mtime
          if mtime > @files[file]
            changed_files << file
            @files[file] = mtime
          end
        end
        if changed_files.length > 0
          changed
          notify_observers changed_files
        end
        sleep 10
      end
    end
  end
  
  class Action
    def initialize(exec)
      @exec = exec
    end

    def update changed_files
      puts changed_files
      puts @exec
      out = `#{@exec}`
      puts out
    end 
  end
end

PinCI::App.run

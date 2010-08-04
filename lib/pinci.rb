#!/bin/env ruby

require 'observer'
module PinCI 
  class App
    def self.run
     file_list = FileList.new
     monitor = Monitor.new(file_list)
     action = Action.new
     monitor.add_observer action
     monitor.run
    end 
  end

  class FileList
    def files
      #TODO: return a list of absolute paths
      Dir.glob(File.join("**","*"))
    end
  end
  
  class Monitor
    include Observable
    
    def initialize file_list
      @files = {}
      files = file_list.files
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
        changed
        notify_observers changed_files
        sleep 10
      end
    end
  end
  
  class Action
    def update changed_files
      puts changed_files
    end 
  end
end

PinCI::App.run

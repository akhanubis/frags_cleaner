#encoding: utf-8

begin
  require 'ffi'
rescue LoadError
  puts 'Falta la gema ffi, intentando instalarla...'
  puts `gem install ffi`
  Gem.clear_paths
  require 'ffi' 
end

load 'lib/config.rb'
load 'lib/user32.rb'
load 'lib/main.rb'

def delete_log(msg)
  puts "#{ Time.now.strftime('%H:%M:%S') } - #{ msg }"
end

FragsCleaner.run
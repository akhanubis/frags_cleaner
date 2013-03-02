#encoding: utf-8
begin
  require 'ffi'
rescue LoadError
  puts 'Falta la gema ffi, intentando instalarla...'
  puts `gem install ffi`
end

puts 'Chequeando estado de rubysdl... puede aparecer en pantalla un error que no tiene nada de erróneo!'
sleep 5
begin
  require 'sdl'
rescue LoadError
  puts 'Falta la gema rubysdl, intentando instalarla...'
  puts `gem install rubysdl-mswin32-1.9`
  puts `install_rubysdl.bat`
end

Gem.clear_paths
require 'sdl' 
require 'ffi'

load 'lib/sound.rb'
load 'lib/config.rb'
load 'lib/user32.rb'
load 'lib/main.rb'

def delete_log(msg)
  puts "#{ Time.now.strftime('%H:%M:%S') } - #{ msg }"
end

FragsCleaner.run
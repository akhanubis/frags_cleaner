#encoding: utf-8

module FragsCleaner
  class << self
    def run
      Config.load_config!
      delete_log 'Configuración actual:'
      Config.current_config.each do |config, value|
        delete_log Config.config_to_string config, value
      end
      import_get_key
      main_loop
    end

    private
    def main_loop
      delete_log 'Iniciando...'
      update_current_state!
      update_previous_last_video!
      while true do
        delete_last_movie! if GetAsyncKeyState(Config.key) != 0
        sleep Config.sleep_time
      end
    end
    def import_get_key
      extend FFI::Library
      ffi_lib 'user32'
      ffi_convention :stdcall
      attach_function :GetAsyncKeyState, [ :int ], :short
      delete_log 'GetAsyncKeyState importada!'
    end

    def delete_last_movie!
      update_current_state!

      if files_changed && !delete_movie_at!(0)
        #probablemente el video más reciente es en el que Frabs está grabando, borrar el anterior
        delete_log 'Warning: Ninguno de los dos videos más recientes se pudo borrar.' unless delete_movie_at! 1
      end

      update_previous_last_video!
    end

    def files_changed
      @previous_last_video != @current_state.first
    end

    def delete_movie_at!(index)
      to_be_deleted = @current_state[index]
      return false unless to_be_deleted
      File.delete to_be_deleted[:filename]
      delete_log "#{ to_be_deleted[:filename] } borrado!"
      @current_state.delete_at index
      true
    rescue
      delete_log "Warning: No se pudo borrar #{ to_be_deleted[:filename] }"
      false
    end

    def update_current_state!
      @current_state = Dir.glob("#{ Config.movies_path }//*.avi").map do |filename|
        { filename: filename, mtime: File.mtime(filename) }
      end.sort { |a, b| b[:mtime] <=> a[:mtime] }
    end

    def update_previous_last_video!
      @previous_last_video = @current_state.first
    end
  end
end
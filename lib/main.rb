#encoding: utf-8

module FragsCleaner
  class << self
    attr_accessor :mtime_of_last_deleted

    def run
      Config.load_config!
      delete_log 'Configuración actual:'
      Config.current_config.each do |config, value|
        delete_log Config.config_to_string config, value
      end
      FCUser32.import_register_hot_key
      main_loop
    end

    private
    def main_loop
      delete_log 'Iniciando...'
      update_current_state!
      self.mtime_of_last_deleted = Time.now
      while true do
        aux_ptr = FFI::MemoryPointer.new 36 #sizeof de la struct MSG
        delete_last_movie! if FCUser32.GetMessageW(aux_ptr, nil, 0, 0)
        aux_ptr.free
      end
    end
    
    def delete_last_movie!
      update_current_state!

      if !delete_movie_at!(0)
        #probablemente el video más reciente es en el que Fraps está grabando, borrar el anterior
        delete_log 'Ocurrió un error o no hay nada para borrar.' unless delete_movie_at! 1
      end
    end

    def delete_movie_at!(index)
      to_be_deleted = @current_state[index]
      return false unless to_be_deleted && to_be_deleted[:mtime] > mtime_of_last_deleted
      File.delete to_be_deleted[:filename]
      delete_log "#{ to_be_deleted[:filename] } borrado!"
      @current_state.delete_at index
      self.mtime_of_last_deleted = to_be_deleted[:mtime]
      true
    rescue
      delete_log "No se pudo borrar #{ to_be_deleted[:filename] }. Probablemente Fraps esté grabando en ese video"
      false
    end

    def update_current_state!
      @current_state = Dir.glob("#{ Config.movies_path }//*.avi").map do |filename|
        { filename: filename, mtime: File.mtime(filename) }
      end.sort { |a, b| b[:mtime] <=> a[:mtime] }
    end
  end
end

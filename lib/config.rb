#encoding: utf-8

module FragsCleaner
  module Config
    STATIC_COMMENTS_ON_CONFIG_FILE = <<eos
#key: virtual key code de msdn
#movies_path: path a la carpeta movie de Fraps (ejemplo: C://Fraps//Movies)
#volume: valor entre 0 y 128 que define el volumen de los sonidos indicadores de que se pudo borrar o no una movie
eos
    CONFIG_FILE = 'frags_cleaner.ini'
    INTEGER_CONFIGS = [:key, :volume]

    @current_config = {
      key: 0x77, #F8 http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
      movies_path: 'C://Fraps//Movies',
      volume: 32
    }
    
    class << self
      attr_reader :current_config

      def config_to_string(config, value)
        "#{ config }:#{ value }"
      end
      
      def load_config!
        if Dir.entries('.').include? CONFIG_FILE
          supported_configs = @current_config.keys
          File.open(CONFIG_FILE, 'r') do |file|
            file.each_with_object @current_config do |line, configs|
              match = line.match /(#{ supported_configs * '|' }):(.*)$/
              configs[match[1].to_sym] = match[2] if match
            end
            @current_config.each do |k, v|
              @current_config[k] = Integer(v) if INTEGER_CONFIGS.include? k
            end
          end
        else
          delete_log "Falta el archivo de configuración #{CONFIG_FILE}. Creando uno con los valores default..."
          File.open(CONFIG_FILE, 'w') do |file|
            file.puts STATIC_COMMENTS_ON_CONFIG_FILE
            @current_config.each { |k, v| file.puts config_to_string(k,v) }
          end
        end
      end

      def method_missing(meth, *args, &block)
        current_config[meth] || super
      end
    end
  end
end
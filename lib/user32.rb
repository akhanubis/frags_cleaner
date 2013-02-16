module FCUser32
  extend FFI::Library
  ffi_lib 'user32'
  ffi_convention :stdcall
  attach_function :RegisterHotKey, [:pointer, :pointer, :pointer, :int ], :bool
  attach_function :GetMessageW, [:pointer, :pointer, :int, :int], :bool
  
  def self.import_register_hot_key  
    if RegisterHotKey(nil, nil, nil, FragsCleaner::Config.key)
      delete_log 'RegisterHotKey importada!'
    else
      delete_log 'Error importando RegisterHotKey. Shutting down...'
    exit(-1)
    end
  end
end
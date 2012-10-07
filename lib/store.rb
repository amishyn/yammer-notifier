require 'yaml'
class Store
  class << self
    attr_accessor :path
    def options
      @options || load_from_file
    end

    def load_from_file
      @options = File.exists?(filename) ? YAML.load_file(filename) : {}
    end

    def update(options = {})
      @options||={}
      @options.merge!(options)
      File.open(filename,'w'){|f| f.puts(@options.to_yaml)}
    end
    def filename
      File.join(path, "config.yml")
    end
  end
end

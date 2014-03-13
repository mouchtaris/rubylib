module Util

class Config
  include Util::YamlLoader
  include Util::ArgumentChecking

  # Map configuration to an object.
  #
  # Loading happens according to
  # {Util::YamlLoader}.
  def initialize *yamls
    initialize_yaml_loader *yamls
    @db = {}
    reload!
  end

  def reload!
    for key in @db.keys do
      self.singleton_class.class_exec do undef_method key end
    end
    Config.structify self, (@db = reload)
  end

  def [] key
    require_symbol{:key}
    send key
  end

  def []= key, val
    require_symbol{:key}
    send :"#{key}=", val
  end

  private :reload
  private

  def self.structify target, config
    config.each do |key, val|

      define_getter = lambda do |val| target.define_singleton_method key do val end end

      case val
        when Hash then
          define_getter[Config.structify(val, val)]
        else
          define_getter[val]
      end

      target.define_singleton_method :"#{key}=" do |val|
        Config.structify self, {key => val}
      end
    end
    target
  end

end#class Config

end#module Util

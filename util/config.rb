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
    (@db = reload).each do |key, val|
      define_getter = -> (val) do define_singleton_method key do val end end
      define_getter[val]
      define_singleton_method :"#{key}=", &define_getter
    end
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

end#class Config

end#module Util

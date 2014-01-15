module Util

class Config
  include Util::YamlLoader

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
    for key, val in @db = reload do
      define_singleton_method key do val end
    end
  end

  private :reload

end

end
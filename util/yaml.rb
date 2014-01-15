require 'yaml'

module Util

module Yaml
  extend self

  def load_yaml_file_if_it_exists path
    if File.exist? path
      then YAML.load File.read path
      else {}
    end
  end

end

end
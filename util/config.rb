require 'yaml'

module Util

class Config

  # Map configuration to an object.
  #
  # Parameter config can be
  # - a [String] filename, ending in '.yaml', in which case
  #   it is loaded as a YAML file,
  # - any other [String], which is parsed as YAML, or
  # - a [Hash] instance, which is used itself.
  #
  # @param config [String, Hash] yaml filename, yaml code or
  #   a config object
  def initialize config
    hash =  case config
              when String then
                case File.extname config
                  when '.yaml' then YAML.load File.read config
                  else              YAML.load config
                end
              when Hash then config
            end
    for key, val in hash do
      define_singleton_method key do val end
    end
  end

end

end
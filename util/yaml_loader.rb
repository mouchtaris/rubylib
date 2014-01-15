require 'yaml'
#
require 'util/deep_dup'

module Util

# Loads various yaml databases and merges them
# into a final result.

module YamlLoader

  def initialize *args, **options, &block
    super
  end

  def initialize_yaml_loader *yamls
    @yamls = yamls.map do |yaml|
      case yaml
        when Hash then yaml
        when String then
          if File.extname(yaml) == '.yaml'
            then yaml
            else YAML.load(yaml).freeze
          end
        else raise ArgumentError.new yaml.inspect
      end
    end
  end

  # @return [Hash] the merged result of all yamls
  def reload
    @yamls.map do |yaml|
      case yaml
        when Hash then yaml
        when String then YAML.load File.read yaml
      end
    end.
    reduce &:merge
  end

end

end

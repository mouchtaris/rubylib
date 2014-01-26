require 'yaml'
#
require 'util/deep_dup'

module Util

# Preserves yaml sources and reloads them
# when requested.
#
# Instead of loading each source upon
# construction, each resource is preserved,
# according to its type. Later, when a
# {#reload} is requested, each source is
# loaded anew.
#
# Finally, the results from all the sources
# are merged into a final {Hash}. The
# intermediate hashes are merged in the
# order in which the sources have been provided.

module YamlLoader

  def initialize *args, **options, &block
    super
  end

  # Each argument can be:
  # * A {Hash}: in this case the hash reference
  #   is stored and the hash will be merged
  #   as-is with the other results. This hash
  #   is never modified by the {#YamlLoader},
  #   and it is not copied or cached in any way:
  #   any change in the hash instance will be
  #   reflected at the next {#reload}.
  # * A {String} filename ending in '.yaml':
  #   in this case the filename is duplicated
  #   and stored. Upon {#reload}, the file
  #   indicated by this filename is read and
  #   its contents parsed as YAML. The resulting
  #   hash is merged with the results from
  #   other sources.
  # * Any other {String}: it is immediately
  #   parsed as YAML and the resulting hash
  #   is stored to be merged with other results.
  def initialize_yaml_loader *yamls
    @yamls = yamls.map do |yaml|
      case yaml
        when Hash then yaml
        when String then
          if File.extname(yaml) == '.yaml'
            then yaml.dup.freeze
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
        when String then Util::Yaml.load_yaml_file_if_it_exists yaml
      end
    end.
    reduce &:merge
  end

end

end

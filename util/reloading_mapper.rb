require 'yaml'

module Util

module ReloadingMapper

  def initialize *args, &block
    super
  end

  def [] name
    unless result = @map[name.to_s] then
      reload!
      result = @map[name.to_s]
      ::Kernel.raise "Rc not found: #{name}" unless result
    end
    result
  end

  def each_name &block
    @map.each_value &block
  end

  private
  def reload!
    @map = ::YAML.load ::File.read @db_pathname
  end

  def initialize_reloading_mapper db_pathname
    @db_pathname = db_pathname.to_s.freeze
    reload!
  end

end

end
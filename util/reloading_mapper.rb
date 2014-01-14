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
    @map.each_key &block
  end

  def each &block
    @map.each &block
  end

  private
  def reload!
    @map = ::YAML.load ::File.read @db_pathname if @db_pathname
  end

  def initialize_reloading_mapper db_or_pathname
    case db_or_pathname
      when String then
        @db_pathname = db_or_pathname.to_s.freeze
        reload!
      when Hash then
        @db_pathname = nil
        @map = db_or_pathname.dup
    end

  end

end

end
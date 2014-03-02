module Util

#
# A mapper which reloads the underlying
# database in case a mapping fails.
#
module ReloadingMapper
  include Util::YamlLoader

  def initialize *args, **options, &block
    super
  end

  def [] name
    unless result = @map[name.to_s] then
      reload!
      result = @map[name.to_s]
      ::Kernel.raise ::IndexError.new "Rc not found: #{name}" unless result
    end
    result
  end

  def each_name &block
    @map.each_key &block
  end

  def each &block
    @map.each &block
  end

  private :reload
  private
  def reload!
    @map = reload;
  end

  def initialize_reloading_mapper *dbs
    initialize_yaml_loader *dbs
    reload!
  end

end#module ReloadingMapper

end#module Util

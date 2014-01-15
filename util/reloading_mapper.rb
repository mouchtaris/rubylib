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
    @map =  (
              @db_pathnames.map do |path| YAML.load File.read path end +
              @dbs
            ).reduce(&:merge)
    ;
  end

  def initialize_reloading_mapper *dbs
    @db_pathnames = []
    @dbs = []
    for db in dbs do
      case db
        when String then
          case File.extname db
            when '.yaml' then @db_pathnames << db.dup.freeze
            else @dbs << YAML.load(db).freeze
          end
        when Hash then
          @dbs << db.dup.freeze
      end
    end
    reload!
  end

end

end
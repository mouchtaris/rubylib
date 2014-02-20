require 'pathname'

module AutoLoader

  def self.class_name_to_file_name name
    name.scan(/[A-Z][a-z0-9]*/).map(&:downcase).to_a.join('_')
  end

  def self.path_for_module_name name
    name.to_s.
      split('::').
      map(&method(:class_name_to_file_name)).
      reduce(Pathname('.'), &:+)
  end

  def const_missing name
    full_name = "#{self.name}::#{name}"

    @auto_loader_nesting ||= 0
    STDERR.printf('[AL] %s%-*s',
      '| ' * @auto_loader_nesting   ,
      50 - @auto_loader_nesting * 2 ,
      full_name                     ,
      )

    @auto_loader_looked_for ||= {}
    if @auto_loader_looked_for.has_key? full_name
    then
      result = @auto_loader_looked_for[full_name]
      if result.is_a? FalseClass
      then raise "#{full_name} already looked for -- nothing like it"
      else STDERR.puts "CACHE:#{result}"
      end
      result
    else
      full_path = AutoLoader.path_for_module_name(full_name)
      STDERR.puts "FILE:#{full_path}"
      @auto_loader_nesting += 1
      raise "Could not load #{full_path} for #{full_name}" unless require full_path.to_s
      @auto_loader_nesting -= 1

      raise "Could not find #{name} in #{self.name}" unless result = const_get(name)

      @auto_loader_looked_for[full_name] = result || false
      result
    end
  end

end
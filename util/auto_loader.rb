require 'pathname'

module AutoLoader

  def self.class_name_to_file_name name
    name.scan(/[A-Z][a-z]*/).map(&:downcase).to_a.join('_')
  end

  def self.path_for_module_name name
    name.to_s.
      split('::').
      map(&method(:class_name_to_file_name)).
      reduce(Pathname('.'), &:+)
  end

  def const_missing name
    full_name = "#{self.name}::#{name}"
    
    $AutoLoading_nesting ||= 0
    STDERR.print "- #{'    ' * $AutoLoading_nesting}Autoloading #{full_name} . . ."

    @auto_loader_looked_for ||= {}
    if @auto_loader_looked_for.has_key? full_name
    then
      result = @auto_loader_looked_for[full_name]
      if result.is_a? FalseClass
      then raise "#{full_name} already looked for -- nothing like it" 
      else STDERR.puts " -- cached: #{result}"
      end
      result
    else
      full_path = AutoLoader.path_for_module_name(full_name)
      STDERR.puts" -- from #{full_path} . . ."
      $AutoLoading_nesting += 1
      raise "Could not load #{full_path} for #{full_name}" unless require full_path.to_s
      $AutoLoading_nesting -= 1

      raise "Could not find #{name} in #{self.name}" unless result = const_get(name)
      
      STDERR.puts "  #{'    ' * $AutoLoading_nesting}#{full_name} OK"
      @auto_loader_looked_for[full_name] = result || false
      result
    end
  end

end
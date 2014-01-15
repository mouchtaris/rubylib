class Object

  # "Deeply" clones an objects, by calling
  # #deep_dup or #dup in all of its instance
  # variables.
  def deep_dup
    case self
      when Fixnum, Symbol then self
      else
        result = dup
        for var in instance_variables do
          source = instance_variable_get(var)
          copy = source.deep_dup
          result.instance_variable_set var, copy
        end
        result
    end
  end

end



class Hash

  def deep_dup
    result = dup
    each do |key, val|
      result[key] = val.deep_dup
    end
    result
  end

end



class Array

  def deep_dup
    map &:deep_dup
  end

end
class Object

  def deep_freeze
    for var in instance_variables do instance_variable_get(var).freeze end
    freeze
  end

end



class Hash

  def deep_freeze
    for key, val in self do
      key.deep_freeze
      val.deep_freeze
    end
    freeze
  end

end



class Array

  def deep_freeze
    each &:deep_freeze
    freeze
  end

end


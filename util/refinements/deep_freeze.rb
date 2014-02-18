module Util
module Refinements

module DeepFreeze
  extend Util::Refiner

  # "Deeply" freeze this object by calling {#deep_freeze}
  # on all instance variables, elements or values.
  #
  # @return this object frozen
  refinement target: ::Object, as: :deep_freeze, method:
  def deep_freeze_for_Object
    for var in instance_variables do
      instance_variable_get(var).deep_freeze
    end
    freeze
  end

  # @!method Simple_deep_freeze
  refinement target: ::String, as: :deep_freeze, method:
  def deep_freeze_simple
    freeze
  end

  # @!method Hash_deep_freeze
  refinement target: ::Hash, as: :deep_freeze, method:
  def deep_freeze_for_Hash
    for key, val in self do
      key.deep_freeze
      val.deep_freeze
    end
    freeze
  end

  # @!method Array_deep_freeze
  refinement target: ::Array, as: :deep_freeze, method:
  def deep_freeze_for_Array
    each &:deep_freeze
    freeze
  end

end#module DeepFreeze

end#module Refinements
end#module Util

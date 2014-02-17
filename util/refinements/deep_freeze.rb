module Util
module Refinements

module DeepFreeze
  extend Util::Refiner

  # @!method Hash_deep_freeze
  refinement \
  def deep_freeze
    for key, val in self do
      key.deep_freeze
      val.deep_freeze
    end
    freeze
  end

  refine! { ::Hash }


  clear_refinements!

  # @!method Array_deep_freeze
  refinement \
  def deep_freeze
    each &:deep_freeze
    freeze
  end

  refine! { ::Array }


  clear_refinements!

  # "Deeply" freeze this object by calling {#deep_freeze}
  # on all instance variables, elements or values.
  #
  # @return this object frozen
  refinement \
  def deep_freeze
    for var in instance_variables do
      instance_variable_get(var).deep_freeze
    end
    freeze
  end

  refine! { ::Object }

end#module DeepFreeze

end#module Refinements
end#module Util

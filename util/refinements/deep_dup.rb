module Util
module Refinements

module DeepDup
  extend Refiner

  clear_refinements!

  # @!method Symbol_Fixnum_deep_dup
  refinement \
  def deep_dup
    self
  end

  refine! { ::Symbol }
  refine! { ::Fixnum }


  clear_refinements!

  # @!method Hash_deep_dup
  refinement \
  def deep_dup
    result = dup
    each do |key, val|
      result[key] = val.deep_dup
    end
    result
  end

  refine! { ::Hash }


  clear_refinements!

  # @!method Array_deep_dup
  def deep_dup
    map &:deep_dup
  end

  refine! { ::Array }


  clear_refinements!

  # "Deeply" clones an object, by calling
  # {#deep_dup} or {#dup} on all of its instance
  # variables.
  #
  # If this object is an {Array}, it calls
  # deep-dup on all of its elements.
  #
  # If this object is a {Hash}, it calls
  # deep-dup on all of its values.
  #
  # {Symbol}s and {Fixum}s cannot be cloned and
  # this method returns self.
  #
  # @return a deeply duped clone of this object
  refinement \
  def deep_dup
    dup.tap do |result|
      for var in instance_variables do
        source  = instance_variable_get(var)
        copy    = source.deep_dup
        result.instance_variable_set var, copy
      end
    end
  end

  refine! { ::Object }

end#module DeepDup

end#module Refinements
end#module Util

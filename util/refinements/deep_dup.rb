module Util
module Refinements

module DeepDup
  extend ::Util::Refiner

  refinement target: [::Symbol, ::Fixnum, ::TrueClass, ::NilClass], as: :deep_dup, method:
  def deep_dup__simple
    self
  end

  refinement target: ::Hash, as: :deep_dup, method:
  def deep_dup__for_Hash
    result = dup
    each do |key, val|
      result[key] = val.deep_dup
    end
    result
  end

  refinement target: ::Array, as: :deep_dup, method:
  def deep_dup__for_Array
    map &:deep_dup
  end

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
  refinement target: ::Object, as: :deep_dup, method:
  def deep_dup__for_Object
    ( # Parentheses for silly ruby 2.1 TODO remove with 2.2
    dup.tap do |result|
      for var in instance_variables do
        source  = instance_variable_get(var)
        copy    = source.deep_dup
        result.instance_variable_set var, copy
      end
    end
    )
  end

end#module DeepDup

end#module Refinements
end#module Util

module Util
module Refinements

module MapNth
  extend Util::Refiner

  default_targets ::Array, ::Enumerable

  # In an array in which elements are tuples,
  # the given block is applied to the n-th element
  # of each tuple and the resulting tuple replaces
  # the original one.
  #
  # @param n [Fixnum] the tuple-element index
  # @return [Array] a new array of updated tuples
  refinement \
  def map_nth n
    map do |tuple|
      tuple[n] = yield tuple[n]
      tuple
    end
  end

end#module MapNth

end#module Refinements
end#module Util

module Util
module Refinements

module RSort
  extend Util::Refiner

  default_targets ::Array, ::Enumerable

  # see #sort
  # @return this element reverse sorted (descending)
  refinement \
  def rsort &block
    sorting =
        if block
          then lambda do |a, b| -block.call(a, b) end
          else lambda do |a, b| b <=> a end
        end
    sort &sorting
  end

  # see #sort_by
  # @return this element reverse sorted (descending)
  refinement \
  def rsort_by &block
    return rsort unless block
    ( # Parentheses for silly ruby 2.1 TODO remove with 2.2
    self.
      map do |a| [block.call(a), a] end.
      rsort.
      map do |key, el| el end
    )
  end

end#module RSort

end#module Refinements
end#module Util

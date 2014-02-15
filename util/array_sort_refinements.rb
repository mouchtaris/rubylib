module Util

module ArraySortRefinements

  refine Array do

    def rsort &block
      sorting =
          if block
            then lambda do |a, b| -block.call(a, b) end
            else lambda do |a, b| b <=> a end
          end
      sort &sorting
    end

    def rsort_by &block
      return rsort unless block
      self.
        map do |a| [block.call(a), a] end.
        rsort.
        map do |key, el| el end
    end

  end

end#module ArraySortRefinements

end#module Util

module Util

module ArrayMapNthRefinement

refine Array do

  def map_nth n
    map do |multiel|
      multiel[n] = yield multiel[n]
      multiel
    end
  end

end

end#module ArrayMapNthRefinement

end#module Util

module Util

module Inliner

  def inline &block
    fname = block[]
    block.binding.eval File.read fname
  end

end#module Inliner

end#module Util

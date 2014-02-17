module Util

module Refiner
  include ArgumentChecking

  def refinement name
    require_symbol{:name}
    (@refinements ||= []) << name
  end

  def refine! &block
    refinee = block[]
    context = block.binding
    @refinements.
      each do |ref|
        context.eval "define_method #{ref}, (instance_method #{ref})"
      end
  end

end#module Refiner

end#module Util

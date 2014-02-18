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
        meth = context.eval "instance_method :#{ref}"
        refine refinee do
          define_method ref, meth
        end
      end
  end

  def clear_refinements!
    @refinements = nil
  end

end#module Refiner

end#module Util

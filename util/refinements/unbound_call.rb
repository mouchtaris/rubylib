module Util
module Refinements

module UnboundCall
  extend Util::Refiner

  refinement \
  def unbound_call receiver, *args, &block
    bind(receiver).call *args, &block
  end

  refine! { ::UnboundMethod }

  refine Proc do

    alias_method :unbound_call, :call

  end

end#module UnboundCall

end#module Refinements
end#module Util

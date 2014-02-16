module Util

module UnboundMethodRefinements

refine UnboundMethod do

  def unbound_call receiver, *args, &block
    bind(receiver).call *args, &block
  end

end

refine Proc do

  alias_method :unbound_call, :call

end

end#module UnboundMethodRefinements

end#module Util

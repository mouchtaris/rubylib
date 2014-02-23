module Util
module Refinements

module UnboundCall
  extend Util::Refiner

  refinement target: ::UnboundMethod, as: :unbound_call, method:
  def unbound_call__for_UnboundMethod receiver, *args, &block
    bind(receiver).call *args, &block
  end

  custom_refinement \
    Class.new {
      def refine target
        target.module_exec do
          alias_method :unbound_call, :call
        end
      end

      def coarsen target
        target.module_exec do
          undef_method :unbound_call
        end
      end
    }.new,
    targets: ::Proc

end#module UnboundCall

end#module Refinements
end#module Util

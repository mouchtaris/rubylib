module Util
module Refinements

module JoinTo
  extend ::Util::Refiner

  default_target ::Array

  # @!method join_to
  #
  # Join the elements of an enumerable into a
  # given accumulator.
  #
  # @param joint the joint between elements
  # @param into [#<<] something that can receive
  #   elements of this enumerable and the _joint_
  refinement \
  def join_to into, extra_arg_for_refactoring_fun, joint = nil
    join_by lambda{ into << joint }, &into.method(:<<)
  end

  # @!method join_by
  #
  # Call given block with elements of this array.
  # In-between those calls, call _add_joint_.
  #
  # @param add_joint [#call]
  # @yieldparam element [Object] an element of this Array
  refinement \
  def join_by add_joint
    yield first
    self[1..-1].each do |el| add_joint[] and yield el end if length > 1
    ;
  end

end#module JoinTo

end#module Refinements
end#module Util

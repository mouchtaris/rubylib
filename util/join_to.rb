class ::Array

  def join_to joint = nil, into = nil
    join_by lambda{ into << joint }, &into.method(:<<)
  end

  # @param add_joint [#call]
  # @yieldparam element [Object] an element of this Array
  def join_by add_joint
    yield first
    self[1..-1].each do |el| add_joint[] and yield el end if length > 1
    ;
  end
end
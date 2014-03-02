require 'util/boolean_common_type'

module Util

module ArgumentChecking
  extend self

  def initialize
    super
  end

  def require_predicate pred, &block
    name = block.call.to_s
    nameval = eval name, block.binding
    raise ArgumentError.new "\"#{name}\" is expected to be cool for #{pred}(#{pred.inspect}), but it fails (#{nameval.inspect})." unless pred.call(nameval)
  end

  def require_type *types, &block
    require_predicate lambda{ |v| types.any? &v.method(:is_a?) }, &block
  rescue ArgumentError
    name = block.call.to_s
    nameval = eval name, block.binding
    raise ArgumentError.new "\"#{name}\" is expected to be any of #{types.join ', '}, but is a #{nameval.class} (#{nameval.inspect})."
  end

  def require_respond_to what, &block
    require_predicate lambda{ |el| el.respond_to? what }, &block
  rescue ArgumentError
    name = block.call.to_s
    nameval = eval name, block.binding
    raise ArgumentError.new "\"#{name}\" is expected to respond to #{what}, but it doesn't, aww."
  end

  def require_symbol &block
    require_type Symbol, &block
  end

  def require_string &block
    require_type String, &block
  end

  def require_bool &block
    require_type Boolean, &block
  end

  def require_callable &block
    require_predicate lambda{ |el| el.respond_to? :call }, &block
  end

  def require_number &block
    require_type Integer, &block
  end

  def require_path &block
    require_type Pathname, &block
  end

  def require_url &block
    require_type URI, &block
  end

  def require_class &block
    require_type Class, &block
  end

end#module ArgumentChecking

end#module Util

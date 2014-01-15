$:.unshift __dir__

require 'util/auto_loader'

for mod in %w{
	ArgumentChecking
	IndentedPrinter
} do

  full_name   = :"Util::#{mod}"
  module_path = AutoLoader.path_for_module_name full_name

	autoload mod.to_sym, module_path
end

module Util
  extend AutoLoader
end

require 'util/auto_loader'

for mod in %w{
	ArgumentChecking
	IndentedPrinter
} do
	autoload mod.to_sym, AutoLoader.path_for_module_name(:"Util::#{mod}")
end
module Util

#
# Add _new_ to a {Module} object.
#
# This method will create a new anonymous class,
# which includes the enchanted module.
#
# The extending module is expected to have a
# constant named _ModuleInitializer_, which is
# a module-specific initialisatin method.
#
# This method is called by _new_, in order to
# properly initialise the newly created object.
#

module ModuleNew

  # _new_ creates a new, anonymous {Class}, which
  # includes the module on which _new_ is called.
  #
  # Then, a new object instance of that class is
  # created.
  #
  # _ModuleInitializer_ is called on the newly created
  # object, passing _args_ and _block_ to it.
  #
  def new *args, &block
    me = self
    initializer = me::ModuleInitializer
    Class.new do
      include me
      def initialize initializer, *args, &block
        initializer.unbound_call self, *args, &block
      end
    end.
    new initializer, *args, &block
  end

end#module ModuleNew

end#module Util

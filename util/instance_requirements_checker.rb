module Util

module InstanceRequirementsChecker

  def self.extended extender
    def extender.included includer
      const_get(:InstanceRequirements).each do |name|
        raise "Including #{self} in #{includer}: #{name}() required" unless includer.method_defined? name
      end
    end
  end

end#module InstanceRequirementsChecker

end#module Util

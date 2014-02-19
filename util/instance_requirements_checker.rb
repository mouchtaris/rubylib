module Util

module InstanceRequirementsChecker

  def self.extended extender
    def extender.included
      const_get(:InstanceRequirements).each do |name|
        raise "#{name}() required" unless method_defined? name
      end
    end
  end

end#module InstanceRequirementsChecker

end#module Util

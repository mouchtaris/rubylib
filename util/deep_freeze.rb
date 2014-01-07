class Object

	def deep_freeze
		for var in instance_variables do instance_variable_get(var).freeze end
		freeze
	end

end
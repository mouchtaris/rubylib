class Object

	# "Deeply" clones an objects, by calling
	# #deep_dup or #dup in all of its instance
	# variables.
	def deep_dup
		result = dup
		for var in instance_variables do
			source = instance_variable_get(var)
			copy =
				if source.respond_to? :deep_dup then source.deep_dup
				else source.dup end
			result.instance_variable_set var, copy
		end
		result
	end

end
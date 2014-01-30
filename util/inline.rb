module Util

module Inliner

def inline fname, binding
  binding.eval File.read fname
end

end

end

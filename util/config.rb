module Util

class Config

  def initialize hash
    for key, val in hash do
      define_singleton_method key do val end
    end
  end

end

end
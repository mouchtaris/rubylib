module Util

  def self.column_print(outs, tuples)
    maxs = []
    tuples.each { |tuple|
      for i in 0..tuple.length - 1 do
        maxs[i] = tuple[i].length if maxs[i].nil? || tuple[i].length > maxs[i]
      end
    }
    tuples.each { |tuple|
      fmt = tuple.reduce('') { |fmt, el| fmt << '%*s' }
      printf_args = maxs.zip(tuple).flatten(1)
      printf(fmt, *printf_args)
    }
  end

end#module Util

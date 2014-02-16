module Util

module StringRefinements

refine String do

  def nonewlines
    gsub "\n", ''
  end

  def around n = 15
    "#{self[0..(n-1)]}...#{self[-n..-1]}"
  end

  def sections section_begin_pattern, make_section_end_pattern
    is_section_pattern  = /\A#{section_begin_pattern}/
    rest                = dup
    until rest.nil? or rest.empty? do
      opening = nil
      non_sec = nil
      sec     = nil
      if md = is_section_pattern.match(rest) then
        # starting with a section
        opening       = md[0]
        rest          = rest[opening.length..-1]
        non_sec       = nil
      else
        non_sec, rest = rest.split section_begin_pattern, 2
        opening       = $~[0] if $~
      end
      if rest then
        section_end_pattern = make_section_end_pattern.call "#{opening}#{rest}"
        sec, rest           = rest.split section_end_pattern, 2
        closing             = $~[0]
        sec                 = opening + sec + closing
      end
      yield non_sec, sec
    end
  end

end

end#module StringRefinements

end#module Util
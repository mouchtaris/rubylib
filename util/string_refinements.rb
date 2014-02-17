module Util

#
# There are refinements for {::String}.
#
module StringRefinements
  extend Util::Refiner

  # Equivalent to
  #   gsub "\n", ''
  # @return [String] a new string without new lines
  refinement \
  def nonewlines
    gsub "\n", ''
  end

  # Truncates the string in the middle.
  # The new string is in the form of
  #   "begin...end"
  # @param n [Fixnum] the number of characters to
  #   keep in the beginning and the end
  # @return [String] a new string with _n_ chars
  #   from the beginning and _n_ from the end
  refinement \
  def around n = 15
    "#{self[0..(n-1)]}...#{self[-n..-1]}"
  end

  # Separates the string into matching and non-mathcing
  # sections and yields them as pairs.
  #
  # The _section_begin_pattern_ is used to detect the
  # beginning of a section.
  #
  # When a section beginning is detected,
  # _make_section_end_pattern_ is called with the whole
  # chunk of string which begins as a section.
  # _make_section_end_pattern_ should return a [Regexp]
  # which will match the ending of the section.
  #
  # The ending of the section is matched with the generated
  # [Regexp]. The beginning and ending parts (which have been)
  # consumed by the [Regexp] are added back to the section.
  #
  # If there was any piece of the string that preceded the
  # matched section, it is yielded as the first argument.
  # The matched section is yielded as the second argument.
  #
  # @param section_begin_pattern [Regexp] a regexp which
  #   matched the beginning of a section
  # @param make_section_end_pattern [#call(rest) => Regexp]
  #   a callback which is called as call(section_beginning)
  #   (including the matched section-opening) and should
  #   return an ending-matching [Regexp]
  # @return [NilClass]
  # @yield [String?, String] a non-matched section (or nil)
  #   and a matched section pair
  refinement \
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

  refine! { String }

end#module StringRefinements

end#module Util
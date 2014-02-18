using Util::Refinements::DeepFreeze

module Togr
  Simple = Hash[*%w{
    a α  b β  g γ  d δ  e ε  z ζ  h η  u θ  i ι
    k κ  l λ  m μ  n ν  j ξ  o ο  p π  r ρ  s σ
    t τ  y υ  f φ  x χ  c ψ  v ω  w ς  q ;

    A Α  B Β  G Γ  D Δ  E Ε  Z Ζ  H Η  U Θ  I Ι
    K Κ  L Λ  M Μ  N Ν  J Ξ  O Ο  P Π  R Ρ  S Σ
    T Τ  Y Υ  F Φ  X Χ  C Ψ  V Ω  Q :
  }].deep_freeze

  Stressed = Hash[*%w{
    a ά  e έ  h ή  i ί  o ό  y ύ  v ώ
  }].deep_freeze

  Dialitics = Hash[*%w{ i ϊ  y ϋ }].deep_freeze

  StressedDialitics = Hash[*%w{ i ΐ  y ΰ }].deep_freeze

  CHAR_STRESS = ';'.deep_freeze
  CHAR_DIALIT = ':'.deep_freeze
  MOD_STRESS = 0b0001
  MOD_DIALIT = 0b0010
  ModVals = {
    CHAR_STRESS => MOD_STRESS,
    CHAR_DIALIT => MOD_DIALIT,
  }.deep_freeze

  TransMap = {
    0 => Simple,
    MOD_STRESS => Stressed,
    MOD_DIALIT =>  Dialitics,
    MOD_STRESS | MOD_DIALIT => StressedDialitics,
  }.deep_freeze

  # Outputs the mod-char if it's not meant
  # for modding anything, and returns the
  # new mod variable.
  # @param out [#<<]
  # @param char [String] the mod char
  # @param mod [Fixnum] the mod flag variable
  # @param modval [Fixnum] the mod flag value
  # @return the new mod
  def mod_or_literal out, char, mod, modval
    if mod & modval != 0
      then
        out << char
        0
      else
        mod | modval
    end
  end

  def transcribe inp, out
    mod = 0
    inp.each do |char|
      case char
      when CHAR_STRESS, CHAR_DIALIT then
        mod = mod_or_literal out, char, mod, ModVals[char]
      else
        out << (TransMap[mod][char] || char)
        mod = 0
      end
    end
  end

end#module Togr

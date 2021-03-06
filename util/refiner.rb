module Util

#
# Poor man's refinements, which are actually tracked monkey-patches.
# They can be done and undone.
#
module Refiner
  include Util::ArgumentChecking

  def self.new_refinements
    Struct.new(:default, :specific).new({}, {})
  end

  # Record a refinement to be performed when
  # {#refine!} is called.
  #
  # If _as_ is provided, the refinement method
  # will use it as a name.
  #
  # For example
  #     refinement_for Array, :hash_array, as: :to_hash
  # will use the _hash_array_ method to refine array
  # by adding a method named _to_hash_ to it.
  #
  # If _target_ is provided, this refinement will only
  # be performed on the given target, or on nothing at
  # all (depending on the arguments passed to {#refine!}).
  #
  # @param target [Class?, Array<Class>?] the targets to refine
  # @param method [Symbol] the name of the method to use
  #   as a refinement
  # @param as [Symbol?] optionally, the name of the
  #   refinement method on the refined target
  #
  def refinement just_method = nil, method: nil, target: nil, as: nil
    targets = Array target
    require_symbol{:just_method} if just_method
    require_symbol{:method} if method
    targets.each do |target| require_class{:target} end
    require_symbol{:as} if as

    name = method || just_method
    meth = instance_method name
    ref  = as || name

    @refinements ||= Refiner.new_refinements
    if targets.empty?
      then
        @refinements.default[ref] = meth
      else
        targets.each do |target|
          (@refinements.specific[target] ||= {})[ref] = meth
        end
    end
  end

  # @param refiner [#refine(target), #coarsen(target)]
  def custom_refinement(refiner, targets:)
    target = Array targets
    target.each do |target| require_class{:target} end
    @custom_refinements ||= Refiner.new_refinements
    if target.empty? then
      @custom_refinements.default[refiner] = true
    else
      target.each do |target|
        (@custom_refinements.specific[target] ||= {})[refiner] = true
      end
    end
  end

  # Performs the refinements that have been registered
  # so far.
  #
  # Refinements registered without a target will be
  # performed on the given targets.
  #
  # Refinements registered for a specific target are
  # performed on that target.
  #
  # The given block should provide an array of targets
  # on which to apply refinements.
  #
  private \
  def _refine! &block
    targets     = Array block[]
    refinements = @refinements

    ( # Parentheses for silly ruby 2.1 TODO remove with 2.2
    block.binding.eval('self').module_exec do
      ( # Parentheses for silly ruby 2.1 TODO remove with 2.2
      targets.each do |refinee|
        defaults  = refinements.default
        specifics = refinements.specific[refinee] || {}
        refine refinee do
          defaults.merge(specifics).each do |ref, meth|
            STDERR.puts "Adding #{meth} as #{ref} on #{refinee}"
            define_method ref, meth
          end
        end

      end
      )
    end
    )
  end

  def default_targets *targets
    @default_targets = targets
  end

  def default_target target
    @default_targets = [target]
  end

  # Monkey-patch all classes given as _targets_ or
  # all classes found in specific-refinement registrations.
  #
  # If _targets_ are provided, then each class in _targets_
  # is monkey patched with all default-refinement registrations
  # plus all specific-refinement registrations for that class
  # *specifically*! Subclasses and other inheritance, mixing,
  # etc schemes are not detected or handled.
  #
  # If _targets_ is empty, all specific-refinements are
  # performed.
  #
  # If _targets_ is empty and {#default_targets} has been
  # specified, then _default_targets_ is used.
  #
  # These patchings can be undone with {#coarsen!}
  #
  # @param explicit_targets classes to patch
  def refine! *explicit_targets
    @applied ||= {}
    @custom_applied ||= {}

    targets = explicit_targets
    targets = @default_targets || (@refinements and @refinements.specific.keys) if explicit_targets.empty?

    custom_targets = explicit_targets
    custom_targets = @default_targets || (@custom_refinements and @custom_refinements.specific.keys) if custom_targets.empty?

    if @refinements then
      targets.each do |refinee|

        applying = @applied[refinee] ||= {}

        @refinements.default.each do |ref, meth|
          unless applying[ref] then
            applying[ref] = meth
            refinee.module_exec do
              STDERR.puts "[RF] +#{refinee}##{ref} -> #{meth}"
              define_method ref, meth
            end
          end
        end

        (specifics = @refinements.specific[refinee]) and
        specifics.each do |ref, meth|
          unless applying[ref] then
            applying[ref] = meth
            refinee.module_exec do
              STDERR.puts "[RF] +#{refinee}##{ref} -> #{meth}"
              define_method ref, meth
            end
          end
        end
      end
    end

    if @custom_refinements then
      custom_targets.each do |refinee|

        custom_applying = @custom_applied[refinee] ||= {}

        @custom_refinements.default.each do |refiner, _|
          STDERR.puts "[RF] +#{refinee} ~~ #{refiner}"
          custom_applying[refiner] = true
          refiner.refine refinee
        end

        (specifics = @custom_refinements.specific[refinee]) and
        specifics.each do |refiner, _|
          STDERR.puts "[RF] +#{refinee} ~~ #{refiner}"
          custom_applying[refiner] = true
          refiner.refine refinee
        end
      end
    end

  end
  alias use! refine!
  alias on! refine!

  # Remove all applied monkey patchings, or just those applied
  # to the specified _targets_.
  #
  # @param targets classes to unpatch
  def coarsen! *targets
    targets = @refinements.specific.keys if targets.empty?
    targets.each do |refinee|
      (applied = @applied[refinee]) and
      applied.each do |ref, meth|
        refinee.module_exec do
          STDERR.puts "[RF] -#{refinee}##{ref}"
          undef_method ref
        end
      end
      (custom_applied = @custom_applied[refinee]) and
      custom_applied.each do |refiner, _|
        STDERR.puts "[RF] -#{refinee} ~~ #{refiner}"
        refiner.coarsen refinee
      end
    end
  end
  alias unuse! coarsen!
  alias off! coarsen!

  # Clear the target-less refinements store.
  #
  def clear_refinements!
    @refinements = nil
  end

end#module Refiner

end#module Util

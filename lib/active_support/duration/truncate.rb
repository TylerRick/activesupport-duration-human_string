require 'active_support/duration'
require 'active_support/core_ext/hash/compact'

module ActiveSupport
  class Duration
    class << self
      # Creates a new Duration from a Hash of parts (inverse of Duration#parts).
      #
      # Surprising that upstream ActiveSupport doesn't provide this method
      #
      # TODO: normalize: option (default true?) which changes 30.5 minutes into 30m, 30s
      def parse_parts(parts, normalize: false)
        parts = parts.reject { |k, v| v.zero? }
        if normalize
          temp = build(parse_parts(parts, normalize: false).value)
          new(temp.value, temp.parts)
        else
          new(calculate_total_seconds(parts), parts)
        end
      end

      def next_smaller_unit(unit)
        i = PARTS.index(unit) or raise(ArgumentError, "unknown unit #{unit}")
        PARTS[i + 1]
      end
    end

    # Replaces parts of duration with given part values. Unlike #change_cascade and Time#change,
    # *only* ever changes the given parts; it does *not* reset any smaller-unit parts.
    def change(options)
      self.class.parse_parts(
        parts.merge(options)
      )
    end

    # Similar to Time#change
    # But note that the keys are plural, so :years instead of :year.
    # Should we allow key aliases? Should we raise ArgumentError if key not recognized? Yes. (Why doesn't Time#change?)
    # or should this be named truncate? or change_reset_smaller_parts?
    #
    #-----------
    # Returns a new Duration where one or more of the elements have been changed according
    # to the +options+ parameter. The time options (<tt>:hour</tt>, <tt>:min</tt>,
    # <tt>:sec</tt>, <tt>:usec</tt>, <tt>:nsec</tt>) reset cascadingly, so if only
    # the hour is passed, then minute, sec, usec and nsec is set to 0. If the hour
    # and minute is passed, then sec, usec and nsec is set to 0. The +options+ parameter
    # takes a hash with any of these keys: <tt>:year</tt>, <tt>:month</tt>, <tt>:day</tt>,
    # <tt>:hour</tt>, <tt>:min</tt>, <tt>:sec</tt>, <tt>:usec</tt>, <tt>:nsec</tt>,
    # <tt>:offset</tt>. Pass either <tt>:usec</tt> or <tt>:nsec</tt>, not both.
    #
    #   Time.new(2012, 8, 29, 22, 35, 0).change(day: 1)              # => Time.new(2012, 8, 1, 22, 35, 0)
    #   Time.new(2012, 8, 29, 22, 35, 0).change(year: 1981, day: 1)  # => Time.new(1981, 8, 1, 22, 35, 0)
    #   Time.new(2012, 8, 29, 22, 35, 0).change(year: 1981, hour: 0) # => Time.new(1981, 8, 29, 0, 0, 0)
    def change_cascade(options)
      options.assert_valid_keys(*PARTS_IN_SECONDS, :nsec, :usec)

      reset = false
      new_parts = {}
      new_parts[:years]   = options.fetch(:years,               parts[:years])  ; reset = options.key?(:years)
      new_parts[:month]   = options.fetch(:months,  reset ? 0 : parts[:months]) ; reset = options.key?(:months)
      new_parts[:days]    = options.fetch(:days,    reset ? 0 : parts[:days])   ; reset = options.key?(:days)
      new_parts[:hours]   = options.fetch(:hours,   reset ? 0 : parts[:hours])  ; reset = options.key?(:hours)
      new_parts[:minutes] = options.fetch(:minutes, reset ? 0 : parts[:minutes]); reset = options.key?(:minutes)
      new_parts[:seconds] = options.fetch(:seconds, reset ? 0 : parts[:seconds])

      if new_nsec = options[:nsec]
        raise ArgumentError, "Can't change both :nsec and :usec at the same time: #{options.inspect}" if options[:usec]
        new_usec = Rational(new_nsec, 1000)
      else
        new_usec = 0
#        new_usec = options.fetch(:usec, (options[:hour] || options[:min] || options[:sec]) ? 0 :
#                                         Rational(nsec, 1000))
      end

      raise ArgumentError, "argument out of range" if new_usec >= 1000000

      new_parts[:seconds] += Rational(new_usec, 1000000)

      self.class.parse_parts(
        new_parts.reject { |k, v| v.zero? }
      )
    end


    # Returns duration rounded to the nearest value with a precision of `precision` (a unit such as
    # :minutes, :seconds). All more-precise-unit parts (for example :minutes and :seconds if :hours
    # precision is specified) are discarded.
    #
    # All arguments beyond the first argument ([ndigits] [, half: mode]) are passed to [round](https://ruby-doc.org/core-2.7.1/Float.html#method-i-round).
    #
    # @example
    #   duration.round(:seconds, 2, half: :down)
    #     2.5.round(half: :down)    #=> 2
    #
    # @raises ArgumentError
    # raise ArgumentError if key not recognized?
    #
    #def round(precision = :seconds, *args)
    def round(precision, *args)
      # TODO: how do we handle 1.4 minutes + 25 seconds ? Can't do these 2 "round" approaches independently. Need to
      # normalize total number of fractional minutes into seconds before deciding which way to round
      # the :minutes part.
      new_part_value = parts[precision].round(*args)

      unit = precision
      next_smaller_unit = self.class.next_smaller_unit(unit)
      next_smaller_unit_in_s = ActiveSupport::Duration::PARTS_IN_SECONDS[next_smaller_unit]
      if next_smaller_unit_in_s
        # AKA tie-breaker
        next_smaller_part = parts[next_smaller_unit]
      end
      if next_smaller_part
        next_smaller_part_in_s = next_smaller_part * next_smaller_unit_in_s rescue byebug
        next_smaller_part_in_s = next_smaller_part * next_smaller_unit_in_s
        half_way_mark_in_s = next_smaller_unit_in_s / 2
        # TODO: use half: option if given (default :up)
        if next_smaller_part_in_s >= half_way_mark_in_s
          new_part_value += 1
        end
      end

      change_cascade(
        precision => new_part_value
      )

#      case precision
#      when :seconds
#        self.parts[:seconds] = self.parts[:seconds].round
#      when :minutes
#        self.parts = self.parts.except(:seconds)
#      when :hours
#        puts %(self.parts=#{(self.parts).inspect})
#        self.parts = self.parts.except(:seconds, :minutes)
#        puts %(self.parts=#{(self.parts).inspect})
#      end
#      self
    end

    # Probably not too useful but could mention how to implement, in #round docs, to make it even
    # clearer that this is *not* what round does, and in case someone really wanted to round in this
    # way.
    def round_part(part_name, *args)
      new_part_value = parts[part_name].round(*args)
      change(
        precision => new_part_value
      )
    end

#    def round_parts(part_names, *args)
#      parts.slice(*part_names).inject(self) do |new, (part_name, part_value)|
#        new.round_parts(part_name, *args)
#      end
#    end

    def round_all_parts(*args)
      parts.inject(self) do |new, (part_name, part_value)|
        new.round_parts(part_name, *args)
      end
    end

    # All arguments beyond the first argument ([ndigits]) are passed to round (
    #   [Float#round](https://ruby-doc.org/core-2.7.1/Float.html#method-i-round) or
    #   possibly in the case of seconds (only?) # [Integer#round](https://ruby-doc.org/core-2.7.1/Integer.html#method-i-truncate)
    # )
    # Similar to https://ruby-doc.org/core-2.7.1/Float.html#method-i-truncate
    def truncate(precision = :seconds, *args)
      # TODO: only use truncate here if :seconds or if part is Float ?
      # or just always pass them along, although they are probably only needed for :seconds
      new_part_value = parts[precision].truncate(*args)
      change_cascade(
        precision => new_part_value
      )

#      case precision
#      when :seconds
#        # drop fractional part of seconds part
#        # 20.7.truncate => 20
#        self
#      when :minutes
#        self.parts = self.parts.except(:seconds)
#      when :hours
#        self.parts = self.parts.except(:seconds, :minutes)
#      end
#      self
    end

    def ceil
    end

    def floor
    end

  end
end

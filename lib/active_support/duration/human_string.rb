# Similar to: active_support/duration/iso8601_serializer.rb

require 'active_support/duration'

module ActiveSupport
  class Duration
    # Returns a concise and human-readable string, like '3h' or '3h 5m 7s'
    # This is unlike #to_s, which is concise but not very human-readable (gives time in seconds even for large durations),
    # This is unlike #iso8601, which is concise but not very human-readable ("P3Y6M4DT12H30M5S").
    def human_to_s
      iso8601.
        sub('P', '').
        sub('T', '').
        downcase.
        gsub(/
          # We only want to pad all *except* the first "\d\D" part
          (\D+)  # Preceeded by: a non-digit
          (\d+)  # A digit
        /x) { '%s%02d' % [$1, $2.to_i] }.
        gsub(/
          \D    # Not a digit
          (?!$) # Not at end
        /x) { |m| "#{m} " }
    end
  end
end

module ActiveSupport
  class Duration
    # Serializes duration to string according to ISO 8601 Duration format.
    class ISO8601Serializer # :nodoc:
      def initialize(duration, precision: nil)
        @duration = duration
        @precision = precision
      end

      # Builds and returns output string.
      def serialize
        parts, sign = normalize
        return "PT0S".freeze if parts.empty?

        output = "P"
        output << "#{parts[:years]}Y"   if parts.key?(:years)
        output << "#{parts[:months]}M"  if parts.key?(:months)
        output << "#{parts[:weeks]}W"   if parts.key?(:weeks)
        output << "#{parts[:days]}D"    if parts.key?(:days)
        time = ""
        time << "#{parts[:hours]}H"     if parts.key?(:hours)
        time << "#{parts[:minutes]}M"   if parts.key?(:minutes)
        if parts.key?(:seconds)
          time << "#{sprintf(@precision ? "%0.0#{@precision}f" : '%g', parts[:seconds])}S"
        end
        output << "T#{time}" unless time.empty?
        "#{sign}#{output}"
      end

      private

        # Return pair of duration's parts and whole duration sign.
        # Parts are summarized (as they can become repetitive due to addition, etc).
        # Zero parts are removed as not significant.
        # If all parts are negative it will negate all of them and return minus as a sign.
        def normalize
          parts = @duration.parts.each_with_object(Hash.new(0)) do |(k, v), p|
            p[k] += v  unless v.zero?
          end
          # If all parts are negative - let's make a negative duration
          sign = ""
          if parts.values.all? { |v| v < 0 }
            sign = "-"
            parts.transform_values!(&:-@)
          end
          [parts, sign]
        end
    end
  end
end

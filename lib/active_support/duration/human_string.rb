# Similar to: active_support/duration/iso8601_serializer.rb

module ActiveSupport
        Duration
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

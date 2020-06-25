module Exports
  module Subtitles
    module Utils
      class TimeFormatter
        class << self

          # Example: 2.16 => 00:00:02,160
          def srt_format(time)
            formatted_timecode(time).join SRT_FORMAT_SEPARATOR
          end

          # Example: 2.16 => 00:00:02,160
          def vtt_format(time)
            formatted_timecode(time).join VTT_FORMAT_SEPARATOR
          end

          private

          VTT_FORMAT_SEPARATOR = '.'
          SRT_FORMAT_SEPARATOR = ','

          def formatted_timecode(time)
            decimal_seconds, = time.to_s.split(':').reverse
            decimal_seconds = decimal_seconds.to_f.round(3).to_s
            seconds, milliseconds = decimal_seconds.split('.')
            milliseconds << '0' * [3 - milliseconds.length, 0].max
            [
                seconds_to_time(seconds.to_i),
                formatted_milliseconds(milliseconds)
            ]
          end

          def formatted_milliseconds(milliseconds)
            milliseconds << '0' * [3 - milliseconds.length, 0].max
          end

          def format_separator
            @format == :vtt ? '.' : ','
          end

          def seconds_to_time(seconds)
            [seconds / 3600, seconds / 60 % 60, seconds % 60].map { |t| t.to_s.rjust(2, '0') }.join(':')
          end
        end
      end
    end
  end
end

module Exports
  module Subtitles
    class Vtt
      def initialize(subtitle, with_bom: true)
        @subtitle = subtitle
        @format = format
        @with_bom = with_bom
      end

      def call
        tempfile = Tempfile.new([video_title, ".#{@format}"])
        tempfile.write UTF8_BOM_MAGIC_NUMBER if @with_bom
        tempfile.write export_body.force_encoding(Encoding::UTF_8)
        tempfile.rewind
        tempfile
      end

      private

      UTF8_BOM_MAGIC_NUMBER = "\uFEFF"

      def video_title
        @subtitle.video_title
      end

      def export_body
        @export_body ||= [header, style, cues_body].join
      end

      def header
        @format == :vtt ? "WEBVTT - Powered by Checksub\r\n\r\n" : ''
      end

      def style
        return '' unless @format == :vtt
        "STYLE\r\n::cue { background: #6772e5; color: #fff; font-family: Lato; font-size: 14, text-align: center; }\r\n\r\n"
      end

      def cues_body
        @subtitle.cues.map.with_index { |cue, index| cue_body(cue, index) }.join
      end

      def cue_body(cue, index)
        [
            index + 1,
            cue_timecode(cue),
            cue['text'].strip,
            "\r\n"
        ].join("\r\n")
      end

      def cue_timecode(cue)
        [
            formatted_timecode(cue['start']),
            formatted_timecode(cue['end'])
        ].join(' --> ')
      end

      # Example: 2.16 => 00:00:02,160
      def formatted_timecode(time)
        decimal_seconds, = time.to_s.split(':').reverse
        decimal_seconds = decimal_seconds.to_f.round(3).to_s
        seconds, milliseconds = decimal_seconds.split('.')
        milliseconds << '0' * [3 - milliseconds.length, 0].max
        [
            seconds_to_time(seconds.to_i),
            formatted_milliseconds(milliseconds)
        ].join format_separator
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
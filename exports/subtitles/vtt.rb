# frozen_string_literal:
module Exports
  module Subtitles
    class Vtt
      def initialize(cues:,with_bom: true)
        @cues = cues
        @with_bom = with_bom
      end

      attr_reader :cues, :with_bom

      def call
        data = []
        data << UTF8_BOM_MAGIC_NUMBER if with_bom
        data << export_body.force_encoding(Encoding::UTF_8)
        data.join
      end

      private

      UTF8_BOM_MAGIC_NUMBER = "\uFEFF\n"
      HEADER = "WEBVTT - Powered by Checksub\r\n\r\n"
      STYLE = "STYLE\r\n::cue { background: #6772e5; color: #fff; font-family: Lato; font-size: 14, text-align: center; }\r\n\r\n"

      def export_body
        [ HEADER, STYLE, cues_body].join
      end

      def cues_body
        cues.map.with_index { |cue, index| cue_body(cue, index) }.join
      end

      def cue_body(cue, index)
        [
            index + 1,
            cue_timecode(cue),
            cue.text.strip,
            "\r\n"
        ].join("\r\n")
      end

      def cue_timecode(cue)
        [
            Exports::Subtitles::Utils::TimeFormatter.vtt_format(cue.start),
            Exports::Subtitles::Utils::TimeFormatter.vtt_format(cue.end)
        ].join(' --> ')
      end
    end
  end
end
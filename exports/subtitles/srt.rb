# frozen_string_literal: true
module Exports
  module Subtitles
    class Srt
      def initialize(cues:, with_bom: true)
        @with_bom = with_bom
        @cues = cues
      end

      attr_reader :cues, :with_bom

      def call
        data = []
        data << UTF8_BOM_MAGIC_NUMBER if with_bom
        data << cues_body.force_encoding(Encoding::UTF_8)
        data.join
      end

      private

      UTF8_BOM_MAGIC_NUMBER = "\uFEFF\n"

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
            Exports::Subtitles::Utils::TimeFormatter.srt_format(cue.start),
            Exports::Subtitles::Utils::TimeFormatter.srt_format(cue.end)
        ].join(' --> ')
      end
    end
  end
end
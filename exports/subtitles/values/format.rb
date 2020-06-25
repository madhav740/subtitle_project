module Exports
  module Subtitles
    class Format

      SUBTITLE_FORMATS = [
          :srt,
          :itt,
          :ttml,
          :vtt,
          :avid_markers
      ].freeze

      SUBTITLE_FORMATS.each do |format|
        define_singleton_method(format) {format}
      end

      def self.valid?(format)
        format.in? SUBTITLE_FORMATS
      end
    end
  end
end
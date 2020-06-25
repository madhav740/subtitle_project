module Exports
  module Subtitles
    class Converter
      def initialize(file_path:,video_title:,with_bom:)
        @file_path = file_path
        @video_title = video_title
        @with_bom = with_bom
      end

      class InvalidSubtitleFormatError < StandardError
      end

      attr_reader :file_path, :video_title, :with_bom

      def convert(format)
        raise InvalidSubtitleFormatError unless Exports::Subtitles::Values::Format.valid?(format)
        subtitle_data = subtitle_converter_klass(format).call
        tempfile = Tempfile.new([video_title, ".#{format}"])
        tempfile.write subtitle_data
        tempfile.rewind
        tempfile
      end

      private

      # TODO: Need to take care of dynamic paramters for different
      # subtitle classes. Might need to create some sort of value
      # object to represent such set of params across all subtitle classes

      def subtitle_converter_klass(format)
        klass = "Exports::Subtitles::#{format.classify}".safe_constantize
        return klass.new(cues: cues) unless srt?(format) || vtt?(format)
        klass.new(cues: cues,with_bom: with_bom)
      end

      def srt?(format)
        format == Exports::Subtitles::Values::Format.srt
      end

      def vtt?(format)
        format == Exports::Subtitles::Values::Format.vtt
      end

      def cues
        json_data = JSON.parse(File.read(file_path))
        json_data.map do |data|
          Exports::Subtitles::Values::Cue.new(
              id: data["id"],
              tstart: data["start"],
              tend: data["end"],
              text: data["text"]
          )
        end
      end
    end
  end
end

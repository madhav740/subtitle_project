# Work in progress for subtitle generation
# Refactoring done for srt and vtt formatter

Main Caller Class is 
Exports::Subtitles::Converter

example call for srt generation
Exports::Subtitles::Converter.new(filepath: <json_file_path>).convert(Exports::Subtitles::Values::Format.srt)

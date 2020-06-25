module Exports
  module Subtitles
    module Values
      class Cue
        def initialize(id:,tstart:,tend:,text:)
          @id = id
          @tstart = tstart
          @tend = tend
          @text = text
        end

        attr_reader :id,:tstart,:tend,:text
      end
    end
  end
end
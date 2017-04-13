class Jukebox
    attr_accessor :where

    def initialize where
        @where = where
        # TODO Load get directory contents
    end

    def get_available_songs
        Dir.entries(@where).keep_if do |entry|
            (entry != '.') && (entry != '..')
        end
    end
end

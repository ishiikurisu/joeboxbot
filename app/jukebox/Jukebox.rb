class Jukebox
    attr_accessor :where

    def initialize where
        @where = where
        # TODO Load get directory contents
        @songs = get_available_songs
    end

    def get_available_songs
        Dir.entries(@where).keep_if do |entry|
            (entry != '.') && (entry != '..')
        end
    end

    def play_nth_song n
        if (n < 0) || (n >= @songs.length)
            raise IndexError
        end
        `vlc #{generate_nth_song_name n}`
    end

    def generate_nth_song_name n
        "#{@where}/\"#{@songs[n]}\""
    end
end

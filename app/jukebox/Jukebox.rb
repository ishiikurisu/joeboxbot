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
        cmd = "vlc \"#{@songs[n]}\""
        `#{cmd}`
    end
end

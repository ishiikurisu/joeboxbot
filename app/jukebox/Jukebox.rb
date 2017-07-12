class Jukebox
    attr_accessor :where
    attr_accessor :playlist
    attr_accessor :songs

    def initialize where
        @where = where
        @songs = Dir.entries(@where).keep_if do |entry|
            (entry != '.') && (entry != '..')
        end
        @playlist = [ ]
    end

    def add_to_playlist n
        if (n >= 0) || (n < @songs.length)
            @playlist << n
        end
    end

    def play_all_songs
        Thread.new do
            loop do
                if @playlist.length > 0
                    play_nth_song @playlist[0]
                    @playlist.shift
                end
            end
        end
    end

    def play_nth_song n
        if (n < 0) || (n >= @songs.length)
            raise IndexError
        end
        `vlc --play-and-exit #{generate_nth_song_name n}`
    end

    def generate_nth_song_name n
        "#{@where}/\"#{@songs[n]}\""
    end
end

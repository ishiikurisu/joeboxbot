class Jukebox
    attr_accessor :where
    attr_accessor :playlist

    def initialize where
        @where = where
        @songs = get_available_songs
        @playlist = [ ]
    end

    def get_available_songs
        Dir.entries(@where).keep_if do |entry|
            (entry != '.') && (entry != '..')
        end
    end

    def add_to_playlist n
        if (n >= 0) || (n < @songs.length)
            @playlist << n
        end
    end

    def play_all_songs
        Thread.new do
            in_loop = true
            while in_loop
                if @playlist.length > 0
                    play_nth_song 0
                    @playlist.shift
                else
                    in_loop = false
                end
            end
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

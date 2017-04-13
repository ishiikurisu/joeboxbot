require "./app/jukebox/Jukebox.rb"
require "minitest/autorun"

class TestPerson < MiniTest::Test
    def setup
        @jukebox = Jukebox.new 'test/testmusic'
    end

    def test_get_files
        assert_equal 5, @jukebox.get_available_songs.length
    end

    # TODO Check if song name is being correctly referenced

    def test_first_song
        assert_empty @jukebox.play_nth_song 0
    end

    # TODO Test playing many songs
end

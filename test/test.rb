require "./app/jukebox/Jukebox.rb"
require "minitest/autorun"

class TestPerson < MiniTest::Test
    def setup
        @jukebox = Jukebox.new 'test/testmusic'
    end

    def test_get_files
        assert_equal 5, @jukebox.get_available_songs.length
    end

    def test_first_song
        assert_empty @jukebox.play_nth_song 0
    end

    def test_play_many_songs
        assert_empty @jukebox.play_nth_song 0
        assert_empty @jukebox.play_nth_song 1
    end

    # TODO Should not play a song with index outside the scope
    def test_try_to_play_invalid_index
        assert_raises(IndexError) do
            @jukebox.play_nth_song -1
        end
    end
end

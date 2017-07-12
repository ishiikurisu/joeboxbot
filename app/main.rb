require 'telegram_bot'
require './app/jukebox/Jukebox.rb'

class App
  def initialize api, where
    @bot = TelegramBot.new token: api
    @jukebox = Jukebox.new where
  end

  def play
    @jukebox.play_all_songs
    @bot.get_updates do |message|
      puts "@#{message.from.username}: #{message.text}"
      command = message.get_command_for @bot

      message.reply do |reply|
        case command
        when /^\/start/i
          reply.text = help
        when /^\/help/i
          reply.text = help
        when /^\/list/i
          reply.text = list
        when /^\/add/i
          arguments = command.split " "
          index = arguments[1].to_i - 1
          reply.text = add index
        else
          reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
        end

        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with @bot
      end
    end
  end

  private
  def add index
    @jukebox.add_to_playlist index
    return "adding #{jukebox.generate_nth_song_name index} to the playlist..."
  end

  def list
    songs = [ ]
    @jukebox.songs.each_index do |i|
      songs << "#{i+1}. #{@jukebox.songs[i]}\n"
    end
    # BUG This message is not being sent
    songs.join.to_s
  end

  def help
    return <<-HELP
# Welcome to the Joeboxbot!
/list - Lists all available songs
/add index - Adds a song to a playlist by its number
/help displays this message
    HELP
  end
end


if __FILE__ == $PROGRAM_NAME
  app = App.new ARGV[0], ARGV[1]
  begin
    app.play
  rescue Interrupt => e
    puts 'Program interrupted'
  end

end

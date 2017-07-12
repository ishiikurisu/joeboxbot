require 'telegram_bot'
require './app/jukebox/Jukebox.rb'

api = gets.chomp
bot = TelegramBot.new token: api
jukebox = Jukebox.new './test/testmusic'
jukebox.play_all_songs
bot.get_updates do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for bot

  message.reply do |reply|
    case command
    when /^\/list/i
      songs = [ ]
      jukebox.songs.each_index do |i|
        songs << "#{i+1}. #{jukebox.songs[i]}\n"
      end
      # BUG This message is not being sent
      reply.text = songs.join
    when /^\/add/i
      arguments = command.split " "
      index = arguments[1].to_i - 1
      jukebox.add_to_playlist index
      reply.text = "adding #{jukebox.generate_nth_song_name index} to the playlist..."
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with bot
  end
end

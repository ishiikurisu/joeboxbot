require 'telegram_bot'
require './app/jukebox/Jukebox.rb'

if __FILE__ == $PROGRAM_NAME
  bot = TelegramBot.new token: ARGV[0]
  jukebox = Jukebox.new ARGV[1]
  jukebox.play_all_songs
  begin
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
  rescue Interrupt => e
    puts 'Program interrupted'
  end

end

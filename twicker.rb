require 'tweetstream'
TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.auth_method        = :oauth
end

#ID of whatever account will be controlling the computer
#Following the ID over using userstream prevents other tweets
#which may show up in the newsfeed from being read.
controllerID = 1418571380

#should pull all *MY* tweets
TweetStream::Client.new.follow(controllerID) do |status|
  #Should probably avoid any commands that require sudo.
  #Don't really want to give a web facing app that much power, anyway.
  #
  #Using system over exec to spawn a child shell to run commands in, rather
  #than interrupting the current process. Backticks are still used on grub-reboot
  #because I want to ensure it's set before calling reboot.
  if status.text=='rb'
    puts 'Reboot command received'
  elsif status.text=='rbw'
    puts 'Reboot to windows command received'
    #Issue: grub-reboot requires su access. But a webfacing app shouldn't have that
    #many permissions.
    `grub-reboot 4`
    system("reboot")
  elsif status.text=='sd'
    puts 'Shutdown command received'
    system("shutdown")
  elsif status.text=='vlup'
    puts 'Volume up'
    system("amixer set Master 10%+ > /dev/null")
  elsif status.text=='vldn'
    puts 'Volume down'
    system("amixer set Master 10%- > /dev/null")
  else
    #No recognized command received. Do nothing.
    #puts "#{status.text}"
  end
end

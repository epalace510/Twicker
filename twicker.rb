require 'tweetstream'
TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.auth_method        = :oauth
end

#should pull all *MY* tweets
TweetStream::Client.new.userstream do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "#{status.text}"
end

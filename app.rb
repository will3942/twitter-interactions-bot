@db = Mongo::Connection.new.db("twitterbot")
@tweets = @db.collection("tweets")
@scraper = Mechanize.new
@scraper.open_timeout = 3
@scraper.read_timeout = 4
@scraper.keep_alive = false
@scraper.max_history = 0

@tweeter = Mechanize.new
@tweeter.open_timeout = 3
@tweeter.read_timeout = 4
@tweeter.keep_alive = false
@tweeter.max_history = 0

@scraper.get 'https://mobile.twitter.com/session/new' do |page|
  login = page.form_with(:action => 'https://mobile.twitter.com/session') do |f|
    username = f.field_with(:name => 'username')
    username.value = @scraper_user
    password = f.field_with(:name => 'password')
    password.value = @scraper_pass
  end.submit
end

@tweeter.get 'https://mobile.twitter.com/session/new' do |page|
  login = page.form_with(:action => 'https://mobile.twitter.com/session') do |f|
    username = f.field_with(:name => 'username')
    username.value = @bot_user
    password = f.field_with(:name => 'password')
    password.value = @bot_pass
  end.submit
end


pid = fork do
  loop do
    page = @scraper.get 'https://mobile.twitter.com/i/connect'
    latest = page.search('table.activity').first
    unless latest.nil?
      action = latest.search('div.user').text.delete(' ')
      if action.include? 'fav'
        action = 'favorited'
      elsif action.include? 'retweet'
        action = 'retweeted'
      else
        action = 'followed'
      end
      user = latest.search('div.user').search('a').first["href"]
      user = "@" + user.delete('/')
      id = user + "-" + action
      if @tweets.find("id" => id).to_a.empty?
        @tweets.insert({"id" => id});
        unless @unwanted.include? user
          @tweeter.get 'https://mobile.twitter.com/compose/tweet' do |tweet_page|
            tweet_form = tweet_page.form_with(:class => "tweetform") do |t_f|
              tweet = t_f.field_with(:name => 'tweet[text]')
              tweet.value = action + ' by ' + user
            end.submit
          end
        end
      end
    end
    sleep 30
  end
end
Process.detach(pid)

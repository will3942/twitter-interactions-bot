require 'rubygems'
require 'mechanize'
require 'mongo'

@scraper_user = '' #twitter username whose interactions you want to track
@scraper_pass = '' #twitter user's password whose interactions you want to track

@bot_user = '' #twitter username who will tweet activity (the bot)
@bot_pass = '' #twitter bot's password

@unwanted = [] #array of users to ignore e.g ['@google', '@engadget']

require './app'

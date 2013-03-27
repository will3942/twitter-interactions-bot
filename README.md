twitter-interactions-bot
========================

Simple Ruby bot, scrapes mobile web to get latest interactions. Adds them to a mongodb database and then tweets about them on a different bot twitter account.

Requirements
--------

Ruby  
MongoDB

Installation
--------

1.  Install the required gems: ``` sudo gem install mechanize mongo ```
2.  Fill in the variables @scraper_user, @scraper_pass, @bot_user, @bot_pass in config.ru
3.  Fill in the unwanted users in the @unwanted array in config.ru
4.  ``` ruby config.ru ```

Contact
--------

Find me @Will3942, mail@definedcode.com

A working example is @will3942bot

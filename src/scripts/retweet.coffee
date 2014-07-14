# Description
#   retweet
#
# Dependencies:
#   "q": "^1.0.1",
#   "twitter": "^0.2.9"
#
# Configuration:
#   HUBOT_RETWEET_API_KEY
#   HUBOT_RETWEET_API_SECRET
#   HUBOT_RETWEET_ACCESS_TOKEN
#   HUBOT_RETWEET_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot retweet <tweet url> - share a tweet
#
# Author:
#   bouzuya <m@bouzuya.net>
#
{Promise} = require 'q'
Twitter = require 'twitter'

module.exports = (robot) ->

  retweet = (id) ->
    new Promise (resolve, reject) ->
      new Twitter(
        consumer_key: process.env.HUBOT_RETWEET_API_KEY
        consumer_secret: process.env.HUBOT_RETWEET_API_SECRET
        access_token_key: process.env.HUBOT_RETWEET_ACCESS_TOKEN
        access_token_secret: process.env.HUBOT_RETWEET_ACCESS_TOKEN_SECRET
      ).retweetStatus id, (data) ->
        if data instanceof Error
          reject(data)
        else
          resolve(data)

  pattern = /retweet (https?:\/\/twitter.com\/[^\/]+\/status\/(\d+))\s*$/i
  robot.respond pattern, (res) ->
    url = res.match[1]
    id = res.match[2]
    retweet id
      .then ->
        res.send url
      , (e) ->
        robot.logger.error e
        res.send 'retweet error'

require '../helper'
Twitter = require 'twitter'

describe 'retweet', ->
  beforeEach (done) ->
    @kakashi.scripts = [require '../../src/scripts/retweet']
    @kakashi.users = [{ id: 'bouzuya', room: 'hitoridokusho' }]
    @kakashi.start().then done, done

  afterEach (done) ->
    @kakashi.stop().then done, done
    @sinon.restore()

  describe 'receive "@hubot retweet https://twitter.com/..."', ->
    beforeEach ->
      @twitter = @sinon.stub Twitter.prototype,
                             'retweetStatus',
                             (id, callback) -> callback({})

    it 'send "https://twitter.com/..."', (done) ->
      tweetUrl = 'https://twitter.com/bouzuya/status/488164193720217600'
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot retweet ' + tweetUrl
      @kakashi
        .timeout 5000
        .receive sender, message
        .then =>
          expect(@kakashi.send.callCount).to.equal(1)
          expect(@kakashi.send.firstCall.args[1]).to.equal(tweetUrl)
        .then (-> done()), done

  describe 'receive "@hubot retweet http://example.com/"', ->
    beforeEach ->
      @twitter = @sinon.stub Twitter.prototype,
                             'retweetStatus',
                             (id, callback) -> callback({})

    it 'don\'t send message', (done) ->
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot retweet http://example.com/'
      @kakashi
        .receive sender, message
        .then =>
          expect(@kakashi.send.callCount).to.equal(0)
        .then (-> done()), done

  describe 'has error', ->
    beforeEach ->
      @twitter = @sinon.stub Twitter.prototype,
                             'retweetStatus',
                             (id, callback) -> callback(new Error())

    it 'send "retweet error"', (done) ->
      tweetUrl = 'https://twitter.com/bouzuya/status/488164193720217600'
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot retweet ' + tweetUrl
      @kakashi
        .timeout 5000
        .receive sender, message
        .then =>
          expect(@kakashi.send.callCount).to.equal(1)
          expect(@kakashi.send.firstCall.args[1]).to.equal('retweet error')
        .then (-> done()), done

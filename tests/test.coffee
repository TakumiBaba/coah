fs = require 'fs'
path = require 'path'
_ = require 'lodash'
ioc = require 'socket.io-client'
assert = require 'assert'
request = require 'supertest'

if fs.existsSync path.resolve 'config', 'env.json'
  _.extend process.env, require path.resolve 'config', 'env'

delete process.env.PORT
process.env.NODE_ENV = 'test'
process.env.SESSION_SECRET or= process.env.SECURITYSESSIONID

{io, app, server} = require '../config/app.coffee'

createClient = (server, opts = {}) ->
  addr = server.address()
  addr = server.listen().address() unless addr
  opts['force new connection'] = yes
  return ioc.connect "ws://#{addr.address}:#{addr.port}", opts

describe 'coah', ->

  it 'should be display index', (done) ->
    index = fs.readFileSync (path.resolve 'public', 'index.html'), 'utf-8'
    request(app).get('/').expect(200).expect(index).end(done)

  unless parseInt process.env.DISABLE_WEBSOCKET
    it 'socket should ping pong', (done) ->
      socket = createClient server

      close = (err) ->
        err = (new Error err) if err
        socket.removeAllListeners 'ping'
        socket.removeAllListeners 'pong'
        socket.disconnect()
        return done err

      socket.on 'pong', -> close null
      socket.emit 'ping'


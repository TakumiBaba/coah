# Dependency

fs = require 'fs'
path = require 'path'
http = require 'http'
express = require 'express'
mongoose = require 'mongoose'
passport = require 'passport'
direquire = require 'direquire'

# Database

unless process.env.DISABLE_MONGODB
  mongoose.connect process.env.MONGO_DB

# Application

session = require path.resolve 'config', 'session'

app = exports.app = express()
app.disable 'x-powerd-by'
app.set 'events', direquire path.resolve 'app', 'events'
app.set 'models', direquire path.resolve 'app', 'models'
app.set 'helper', direquire path.resolve 'app', 'helper'
app.use express.favicon()
unless process.env.NODE_ENV is 'test'
  app.use express.logger 'dev'
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser()
app.use session.middleware
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static path.resolve 'public'

if process.env.NODE_ENV isnt 'production'
  app.use express.errorHandler()

# Server

server = exports.server = http.createServer app

# Routes

route = require path.resolve 'config', 'routes'
route.http app

# WebSocket

unless parseInt process.env.DISABLE_WEBSOCKET
  redis = require 'socket.io/node_modules/redis'
  io = exports.io = (require 'socket.io').listen server,
    'browser client minification': yes
    'browser client etag': yes
    'log': no
  io.set 'store', new (require 'socket.io/lib/stores/redis')
    redisPub: redis.createClient()
    residSub: redis.createClient()
    redisClient: redis.createClient()
  io.set 'authorization', (data, accept) ->
    data.user = {}
    data.auth = no
    return accept null, yes unless data.headers?.cookie?
    (express.cookieParser process.env.SESSION_SECRET) data, {}, (err) ->
      return accept err, no if err
      cookies = data.signedCookies['connect.sid']
      return session.store.load cookies, (err, session) ->
        return accept err, no if err
        [data.auth, data.user] = [yes, session.passport.user] if session
        return accept null, yes

  route.websocket app, io


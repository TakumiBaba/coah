# Dependency

fs = require 'fs'
path = require 'path'
http = require 'http'
_ = require 'lodash'
session = require 'connect-redis'
express = require 'express'
mongoose = require 'mongoose'
passport = require 'passport'
direquire = require 'direquire'

pkg = require path.resolve 'package'

# Database

mongoose.connect process.env.MONGODB

# Session

session_store = new (session express)
  prefix: "sess_#{pkg.name}:"

# Application

app = exports.app = express()
app.disable 'x-powerd-by'
app.set 'events', direquire path.resolve 'events'
app.set 'models', direquire path.resolve 'models'
app.set 'helper', direquire path.resolve 'helper'
app.use express.favicon()
unless process.env.NODE_ENV is 'test'
  app.use express.logger 'dev'
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
  store: session_store
  secret: process.env.SESSION_SECRET
  cookie: expires: no
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

redis = require 'socket.io/node_modules/redis'
io = exports.io = (require 'socket.io').listen server,
  'browser client minification': yes
  'browser client etag': yes
  'log': no
io.set 'store', new (require 'socket.io/lib/stores/redis')
  redisPub: redis.createClient()
  residSub: redis.createClient()
  redisClient: redis.createClient()
io.set 'authorization', (data, done) ->
  _.defaults data, { user: {}, auth: no }
  return done null, yes unless data.headers?.cookie?
  (express.cookieParser process.env.SESSION_SECRET) data, {}, (err) ->
    return done err, no if err
    cookies = data.signedCookies['connect.sid']
    return session_store.load cookies, (err, sess) ->
      return done err, no if err
      [data.auth, data.user] = [yes, sess.passport.user] if sess
      return done null, yes

route.websocket app, io


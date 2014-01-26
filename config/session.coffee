path = require 'path'
debug = require('debug')('coah:session')
express = require 'express'
redisstore = require 'connect-redis'

pkg = require path.resolve 'package.json'

store = new (redisstore express)
  prefix: "sess_#{pkg.name}:"

module.exports =
  store: store
  middleware: express.session
    store: store
    secret: process.env.SESSION_SECRET
    cookie: expires: no


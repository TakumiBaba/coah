# Environment

process.env.NODE_ENV = 'test'

# Dependencies

_ = require 'lodash'
fs = require 'fs'
path = require 'path'
assert = require 'assert'
request = require 'supertest'
{app} = require '../config/app.coffee'
direquire = require 'direquire'

describe 'coah', ->

  # direquire

  it 'should be load events from directory', (done) ->
    fromDir = direquire path.resolve 'app', 'events'
    fromApp = app.get 'events'
    if _.keys(fromDir).toString() is _.keys(fromApp).toString()
      return done null
    return done no

  it 'should be load models from directory', (done) ->
    fromDir = direquire path.resolve 'app', 'models'
    fromApp = app.get 'models'
    if _.keys(fromDir).toString() is _.keys(fromApp).toString()
      return done null
    return done no

  it 'should be load helper from directory', (done) ->
    fromDir = direquire path.resolve 'app', 'helper'
    fromApp = app.get 'helper'
    if _.keys(fromDir).toString() is _.keys(fromApp).toString()
      return done null
    return done no

  # テストすることがない

  #it 'sohuld be index', (done) ->
  #  request(app)
  #    .get('/')
  #    .expect(200)
  #    .end done

  #it 'should be static file serving', (done) ->
  #  file = fs.readFileSync path.resolve('public', 'css', 'style.css'), 'utf-8'
  #  request(app)
  #    .get('/css/style.css')
  #    .expect(200)
  #    .expect(file)
  #    .end done


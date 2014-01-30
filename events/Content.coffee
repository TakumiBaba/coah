debug = require('debug')('coah:events:content')

exports.Content = (app) ->

  {User} = app.get 'models'

  index: (req, res) ->
    debug 'index'
    return res.render 'index', title: 'Express City'

  user: (req, res, next) ->
    debug 'user'
    # User.findOne name: req.params.username, {}, {}, (err, user) ->
    #   debug err if err
    return res.render 'user'


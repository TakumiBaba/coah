exports.Content = (app) ->

  {User} = app.get 'models'

  index: (req, res) ->
    return res.render 'index', title: 'Express City'

  user: (req, res, next) ->
    return res.render 'user'

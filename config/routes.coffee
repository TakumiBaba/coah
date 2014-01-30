exports.http = (app) ->

  Content = (app.get 'events').Content app

  app.get '/', Content.index


#exports.websocket = (app, io) ->


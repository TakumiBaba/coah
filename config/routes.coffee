exports.http = (app) ->

  Content = (app.get 'events').Content app

  #app.get '/', Content.index


exports.websocket = (app, io) ->

  io.on 'connection', (socket) ->
    socket.on 'ping', (data) ->
      socket.emit 'pong', data


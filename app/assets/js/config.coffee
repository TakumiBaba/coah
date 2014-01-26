cdn = '//cdnjs.cloudflare.com/ajax/libs'

require.config
  paths:
    jquery: [
      "#{cdn}/jquery/2.0.3/jquery.min"
      '/vendor/jquery/jquery.min'
    ]
    underscore: [
      "#{cdn}/lodash.js/2.4.1/lodash.min"
      '/vendor/lodash/dist/lodash.min'
    ]
    backbone: [
      "#{cdn}/backbone.js/1.1.0/backbone-min"
      '/vendor/backbone/backbone-min'
    ]
    stickit: [
      "#{cdn}/backbone.stickit/0.7.0/backbone.stickit.min"
      './app/vendor/backbone.stickit/backbone.stickit'
    ]
    marionette: [
      "#{cdn}/backbone.marionette/1.4.1-bundled/backbone.marionette.min"
      '/vendor/marionette/lib/backbone.marionette.min'
    ]
  shim:
    jquery: exports: '$'
    underscore: exports: '_'
    backbone:
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    stickit:
      deps: ['backbone']
    marionette:
      deps: ['stickit', 'backbone']
      exports: 'Marionette'

require ['models', 'views'], (models, views) ->
  console.log models, views


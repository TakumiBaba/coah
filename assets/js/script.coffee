App = new Backbone.Marionette.Application()


App.addRegions
  mainRegions: '#content'


class Post extends Backbone.Model
  defaults:
    title: ''
    points: 0
    postedAgo: ''
    postedBy: ''
    url: ''

  vote: ->
    @set 'points', (@get 'points') + 1
    @collection.sort().trigger 'reset'

  unvote: ->
    @set 'points', (@get 'points') - 1
    @collection.sort().trigger 'reset'


class Posts extends Backbone.Collection
  model: Post
  url: '//api.ihackernews.com/page'

  parse: (res) ->
    return _.sortBy res.items, (item) ->
      return -1 * item.points

  comparator: (post) ->
    return -1 * post.get 'points'


class PostView extends Backbone.Marionette.ItemView
  template: '#tmpl-post'
  tagName: 'tr'
  events:
    'click .vote': 'vote'
    'click .unvote': 'unvote'

  initialize: ->
    @listenTo @model, 'change:score', @render

  vote: ->
    @model.vote()

  unvote: ->
    @model.unvote()


class PostsView extends Backbone.Marionette.CompositeView
  tagName: 'table'
  id: 'posts'
  template: '#tmpl-posts'
  itemView: PostView

  initialize: ->
    @listenTo @collection, 'sort', @renderCollection

  onRender: ->
    @collection.fetch
      data: format: 'jsonp'
      dataType: 'jsonp'
      error: ->
        alert 'Errors on HN API'

  appendHtml: (collectionView, itemView) ->
    (collectionView.$ 'tbody').append itemView.el


App.addInitializer (options) ->
  posts = new Posts()
  postsView = new PostsView collection: posts
  App.mainRegions.show postsView


$ ->
  # posts = new Posts()
  # # posts.add new Post title: 'A RESTful Micro-Framework in Go'
  # # posts.add new Post title: 'Functional Programming 101 - With Clojure'
  # # posts.add new Post title: 'What’s New in Node.js v0.12'

  App.start()

  # posts.add new Post title: 'Node.js and the new web front-end'

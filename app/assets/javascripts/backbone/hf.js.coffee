#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Hf =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  
  init: (options) ->

    new Hf.Routers.PropertiesRouter()
    Backbone.history.start()
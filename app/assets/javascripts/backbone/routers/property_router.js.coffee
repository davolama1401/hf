class Hf.Routers.PropertiesRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    "": "home"
    
  home: ->
    properties = new Hf.Collections.PropertiesCollection()
    view = new Hf.Views.PropertiesView(collection: properties)
    $('#app').html(view.render().el)
  

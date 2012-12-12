class Hf.Routers.PropertiesRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    "": "home"
    ":zip/:min/to/:max": "search"
    
  home: ->
    properties = new Hf.Collections.PropertiesCollection()
    view = new Hf.Views.PropertiesView(
      collection: properties
    )
    $('#app').html(view.render().el)
  
  
  search: (zip, min, max)->
    properties = new Hf.Collections.PropertiesCollection()
    view = new Hf.Views.PropertiesView(
      collection: properties
      zip: zip
      min: min
      max: max
    )
    $('#app').html(view.render().el)

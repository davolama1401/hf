class Hf.Routers.PropertiesRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    "": "home"
    ":zip/:min/to/:max": "search"
    ":id": "showProperty"
    
  home: ->
    if @view and @view.unbind
      @view.unbind()
      
    properties = new Hf.Collections.PropertiesCollection()
    @view = new Hf.Views.PropertiesView(
      collection: properties
    )
    @view.on('view:properties:click', @handlePropertyClick, @)
    $('#app').html(@view.render().el)
  
  
  search: (zip, min, max)->
    if @view and @view.unbind
      @view.unbind()

    properties = new Hf.Collections.PropertiesCollection()
    @view = new Hf.Views.PropertiesView(
      collection: properties
      zip: zip
      min: min
      max: max
    )
    
    @view.on('view:properties:click', @handlePropertyClick, @)
    $('#app').html(@view.render().el)


  showProperty: (propertyId) ->
    property = new Hf.Models.Property(id: propertyId)
    property.fetch()
    @view = new Hf.Views.PropertyView(
      model: property
    )
    
    $('#app').html(@view.render().el)

  handlePropertyClick: (propertyId) =>
    @navigate("##{propertyId}",
      trigger: true
    )
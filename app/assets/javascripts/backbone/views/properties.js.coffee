class Hf.Views.PropertyView extends Backbone.View
  render: ->
    return this
  
class Hf.Views.PropertiesListView extends Backbone.View
  initialize: (options) ->
    if @collection?
      @collection.on('reset', @addAll, @)
      
  render: ->
    @addAll()
    return this
    
  addAll: ->
    @$el.html("")
    if @collection? and @collection.length > 0
      @collection.forEach(@addOne, this)

  addOne: (property) ->
    propertyView = new Hf.Views.PropertyView(model: property)
    @$el.append(propertyView.render().el)

class Hf.Views.PropertySearchView extends Backbone.View
  template:
    '<div class="navbar">' +
      '<div class="navbar-inner">' +
        '<div class="container">' +
          '<a class="brand" href="#">FindHomer.com</a>' +
          '<form class="navbar-form pull-right">' +
            '<input type="text" id="zip" placeholder="Address or Zipcode">' +
            '<input type="text" id="min" placeholder="Min Price">' +
            '<input type="text" id="max" placeholder="Max Price">' +
            '<button type="submit" class="btn">Search</button>' +
          '</form>' +
        '</div>' +
      '</div>' +
    '</div>'
  
  events:
    "submit form": "doSearch"
  
  initialize: (options) ->
    
  render: ->
    @$el.html(@template)

    return this
    
  doSearch: (e) =>
    if e
      e.preventDefault()
      e.stopPropagation()
      
    zip = @$('#zip').val()
    min = @$('#min').val()
    max = @$('#max').val()
    
    alert("zip: #{zip}, min: #{min}, max: #{max}")
    @collection.fetch
      data:
        zip: zip
        min: min
        max: max
    
class Hf.Views.PropertiesView extends Backbone.View
  
  template: 
    "<div id='search'></div>" +
    "<div id='properties'></div>"
  
  initialize: (options) ->
    
  render: ->
    @$el.html(@template)

    searchView = new Hf.Views.PropertySearchView(collection: @collection)
    @$('#search').html(searchView.render().el)
    
    propertiesListView = new Hf.Views.PropertiesListView(collection: @collection)
    @$('#properties').html(propertiesListView.render().el)
    
    return this
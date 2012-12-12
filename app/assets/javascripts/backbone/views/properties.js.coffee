class Hf.Views.PropertyView extends Backbone.View
  className: "hero-unit"
  addressTemplate:
    "<%= address.line1 %> <br />" +
    "<%= address.city %>, <%= address.state %> <%= address.zip %>  <br />"

  photoTemplate: 
    '<div class="item">' +
      '<img src="<%= url %>" class="img-polaroid">' +
    '</div>'

  noPhotosTemplate:
    "No photos available"

  photosTemplate:
    '<div id="myCarousel<%= id%>" class="carousel slide" data-pause="hover">' +
      '<div id="photos_container" class="carousel-inner">' +
      '</div>' +
      '<a class="left carousel-control" href="#myCarousel<%= id%>" data-slide="prev">‹</a>' +
      '<a class="right carousel-control" href="#myCarousel<%= id%>" data-slide="next">›</a>' +
    '</div>'

  descriptionTemplate:
    "<%= description %>"
  
  descriptionTemplate:
    "<%= description %>"
  
  mainTemplate:
    '<div class="row-fluid">' +
      "<div id='photos' class='span2'></div>" +
      "<div id='address' class='span10'></div>" +
    '</div>' +
    '<div class="row-fluid">' +
      "<div id='price'></div>" +
    '</div>' +
    '<div class="row-fluid">' +
      "<div id='description'></div>" +
    '</div>'

  render: ->
    @$el.html(@mainTemplate)
    
    modelJSON = @model.toJSON()
    @renderPhotos(modelJSON)
    @renderAddress(modelJSON)
    @renderPrice(modelJSON)
    @renderDescription(modelJSON)

    return this

  renderPhotos: (modelJSON)->
    if modelJSON.photos?
      @$('#photos').html(_.template(@photosTemplate, modelJSON))
      i = 0
      while i < modelJSON.photos.length
        @$('#photos_container').append(_.template(@photoTemplate, modelJSON.photos[i]))
        @$('.item').addClass('active') if i == 0
        i++
    else
      @$('#photos').html(@noPhotosTemplate)

  renderAddress: (modelJSON)->
    @$('#address').html(_.template(@addressTemplate, modelJSON))
  
  renderPrice: (modelJSON)->
    @$('#price').append(modelJSON.price) if modelJSON.price?
  
  renderDescription: (modelJSON)->
    @$('#description').append(modelJSON.description) if modelJSON.description?
    
    
class Hf.Views.PropertiesListView extends Backbone.View
  resultsTemplate: "<div id='properties-left' class='span1'></div>" +
    "<div id='properties' class='span10'></div>" +
    "<div id='properties-right' class='span1'></div>"

  emptyTemplate: "<div>No properties found</div>"
  
  initialize: (options) ->
    if @collection?
      @collection.on('reset', @addAll, @)
      @collection.on('prefetch', @showSpinner, @)
      
  render: ->
    return this
    
  showSpinner: (e) ->
    if e
      e.preventDefault()
      e.stopPropagation()
    
    @$el.html("Searching...")
    
  addAll: ->
    @$el.html("")
    if @collection? and @collection.length > 0
      @$el.append(@resultsTemplate)
      @collection.forEach(@addOne, @)
    else
      @$el.append(@emptyTemplate)

  addOne: (property) ->
    propertyView = new Hf.Views.PropertyView(model: property)
    @$('#properties').append(propertyView.render().el)

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
    
    @collection.trigger('prefetch')
    @collection.fetch
      data:
        zip: zip
        min: min
        max: max
    
class Hf.Views.PropertiesView extends Backbone.View
  
  template: 
    "<div id='search'></div>" +
    "<div id='meta'></div>" + #what should I put here?
    "<div id='properties'></div>"
  
  initialize: (options) ->
    
  render: ->
    @$el.html(@template)

    searchView = new Hf.Views.PropertySearchView(collection: @collection)
    @$('#search').html(searchView.render().el)
    
    propertiesListView = new Hf.Views.PropertiesListView(collection: @collection)
    @$('#properties').html(propertiesListView.render().el)
    
    return this
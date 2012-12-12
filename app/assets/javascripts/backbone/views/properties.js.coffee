class Hf.Views.PropertyView extends Backbone.View
  className: "hero-unit"
  addressTemplate:
    "<%= type %></div>" +
    "<address>" +
    "<strong><%= address.line1 %> </strong><br>" +
    "<strong><%= address.city %>, <%= address.state %> <%= address.zip %></strong><br>" +
    "</address>"
  primaryPhotoTemplate:
    '<div class="hidden-phone">' +
    '<img src="<%= url %>" class="img-polaroid">' +
    '</div>'

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

  detailsTemplate:
    "<div>Price: <%= price %>, Beds: <%= bed %>, Baths(total): <%= bath.total %></div>"
  
  mainTemplate:
    '<div class="row-fluid">' +
      "<div id='primary_photo' class='span2'></div>" +
      "<div id='address' class='span8'></div>" +
    '</div>' +
    '<div class="row-fluid">' +
      "<div id='details'></div>" +
    '</div>' +
    '<div class="row-fluid hidden-phone">' +
      "<div id='description'></div>" +
    '</div>'

  render: ->
    @$el.html(@mainTemplate)
    
    modelJSON = @model.toJSON()
    @renderPrimaryPhoto(modelJSON)
    @renderAddress(modelJSON)
    @renderDetails(modelJSON)
    @renderDescription(modelJSON)

    return this

  renderPrimaryPhoto: (modelJSON)->
    if modelJSON.primaryPhoto?
      @$('#primary_photo').html(_.template(@primaryPhotoTemplate, modelJSON.primaryPhoto))
    else
      @$('#primary_photo').html(@noPhotosTemplate)

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
  
  renderDetails: (modelJSON)->
    @$('#details').html(_.template(@detailsTemplate, modelJSON))
  
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

class Hf.Views.PropertyPaginationView extends Backbone.View

  template:
    '<div class="pagination pagination-centered">' +
      '<ul>' +
        '<li id="prev"><a href="#">Prev</a></li>' +
        '<li id="next"><a href="#">Next</a></li>' +
      '</ul>' +
    '</div>'
    
  
  initialize: (options)->
    @collection.on('reset', @render, @)
    
    if @collection? and @collection.meta?
      metaData = @collection.meta
      @setVariables(metaData)
  
  render: ->
    if @collection? and @collection.length > 0
      @setVariables(@collection.meta)
      @$el.html(@template)
      
      if @currentPage == 1
        @$('li#prev').addClass('disabled')

      if @currentPage == @totalPages
        @$('li#next').addClass('disabled')

      i = 1
      while i <= @totalPages
        if i == @currentPage
          @$('li#next').before("<li class='disabled'><a href='#'>#{i}</a></li>")
        else
          @$('li#next').before("<li><a href='#'>#{i}</a></li>")
        i++
      
    return this

  setVariables: (metaData) ->
    @totalPages = metaData.totalPages || 0
    @currentPage = metaData.currentPage || 0
    
class Hf.Views.PropertySearchView extends Backbone.View
  template:
    '<div class="navbar">' +
      '<div class="navbar-inner">' +
        '<div class="container">' +
          '<a class="brand" href="#">HomeFinder.com</a>' +
          '<form class="navbar-form pull-right">' +
            '<input type="text" id="zip" placeholder="Address or Zipcode">' +
            '<input type="text" id="min" placeholder="Min Price">' +
            '<input type="text" id="max" placeholder="Max Price">' +
            '<button type="submit" class="btn">Search</button>' +
          '</form>' +
        '</div>' +
      '</div>' +
    '</div>' +
    '<div id="pagination"></div>'
  
  events:
    "submit form": "doSearch"
  
  initialize: (options) ->
    if options? and options.zip? and options.min? and options.max?
      @zip = options.zip
      @min = options.min
      @max = options.max
    
    @paginationView = new Hf.Views.PropertyPaginationView(collection: @collection)
    @paginationView.on('paginate', @doPagination, @)
    
  render: ->
    @$el.html(@template)
    @$('#pagination').html(@paginationView.render().el)
    
    if @zip? and @min? and @max?
      @$('#zip').val(@zip)
      @$('#min').val(@min)
      @$('#max').val(@max)
      @zip = null
      @min = null
      @max = null
      @doSearch()
      
    return this
    
  collectSearchCriteria: ->
    searchCriteria = {}
    searchCriteria.zip = @$('#zip').val()
    searchCriteria.min = @$('#min').val()
    searchCriteria.max = @$('#max').val()
    return searchCriteria
    
  executeSearch: (searchCriteria) ->
    if searchCriteria? and searchCriteria.zip
      @collection.trigger('prefetch')
      @collection.fetch
        data:
          zip:  searchCriteria.zip
          min:  searchCriteria.min
          max:  searchCriteria.max
          page: searchCriteria.page
    else
      alert("you must at least enter a zipcode")
    
  doSearch: (e) =>
    if e
      e.preventDefault() if e.preventDefault
      e.stopPropagation() if e.stopPropagation
      
    searchCriteria = @collectSearchCriteria()
    @executeSearch(searchCriteria)

  doPagination: (page) =>
    searchCriteria = @collectSearchCriteria()
    searchCriteria.page = page
    @executeSearch(searchCriteria)
      
class Hf.Views.PropertiesView extends Backbone.View
  
  template: 
    "<div id='search'></div>" +
    "<div id='meta'></div>" + #what should I put here?
    "<div id='properties'></div>"
  
  initialize: (options) ->
    @searchView = new Hf.Views.PropertySearchView(
      collection: @collection
      zip: options.zip
      min: options.min
      max: options.max
    )

    @propertiesListView = new Hf.Views.PropertiesListView(collection: @collection)
    
  render: ->
    @$el.html(@template)
    @$('#search').html(@searchView.render().el)  
    @$('#properties').html(@propertiesListView.render().el)
    
    return this
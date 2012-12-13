class Hf.Views.PropertyView extends Backbone.View
  navTemplate:
    '<div class="navbar">' +
      '<div class="navbar-inner">' +
        '<div class="container">' +
          '<a class="brand" href="#">HomeFinder.com</a>' +
        '</div>' +
      '</div>' +
    '</div>'
  

  photoTemplate:
    '<div class="item">' +
      '<img src="<%= urlLarge %>" alt="" style="margin: auto;">' +
    '</div>'
  
  photosTemplate:
    '<div class="well">' +
      '<h4>Property photos</h4>' +
      '<div id="photoCarousel" class="carousel slide">' +
        '<div id="photos_container" class="carousel-inner">' +
        '</div>' +
        '<a class="left carousel-control" href="#photoCarousel" data-slide="prev">‹</a>' +
        '<a class="right carousel-control" href="#photoCarousel" data-slide="next">›</a>' +
      '</div>' +
    '</div>'

  noPhotosTemplate:
    "No photos available"
    
  propertyTemplate:
    '<div class="row-fluid"><a href="#" id="back_to_results">< back to search results</a></div>' +
    '<div class="row-fluid">' + 
      '<div class="span12">' + 
        '<div class="media">' +
          '<a class="pull-left" href="#"><img class="media-object" src="<%= primaryPhoto.urlLarge %>"></a>' +
          '<div class="media-body">' +
            '<h4 class="media-heading">' +
              '<address> ' +
                '<%= address.line1 %> <br> ' +
                '<%= address.city%>, <%= address.state %> <%= address.zip %> <br> ' +
              '</address> ' +
            '</h4>' +
            '<h4 class="media-heading">Property Description</h4>' +
            '<p><%= description %></p>' +
            '<h4 class="media-heading">Agent Information</h4>' +
            '<p>' +
              '<address>' +
                '<%= agent.name %> <br>' +
                'E: <a href="mailto:<%= agent.email %>"><%= agent.email %></a>, P: <a href="tel:<%= agent.phone %>"><%= agent.phone %></a> <br>' +
                'Web: <a href="<%= agent.siteUrl %>"><%= agent.siteUrl %></a> <br>' +
                '<a href="<%= agent.listingsUrl %>">View Listings</a> <br>' +
              '</address>' +
            '</p>' +
            '<h4 class="media-heading">More property information</h4>' +
            '<p>' +
              "<div>Price: <%= price %>" + 
              "<% if (typeof(bed) != 'undefined') {%>" +
              ", Beds: <%= bed %>" +
              "<% } else { %>" +
              ", Beds: Unknown" +
              "<% } %>" +
              "<% if (typeof(bath) != 'undefined') {%>" +
              ", Baths(total): <%= bath.total %></div>" +
              "<% } else { %>" +
              ", Baths(total): Unknown </div>" +
              "<% } %>" +
            '</p>' +
          '</div>' +
        '</div>' +
      '</div>' +
    '</div>' +
    '<div class="row-fluid">' + 
      '<div id="photos" class="span12">' +
      '</div>' +
    '</div>'
    
  template: 
    "<div id='nav'></div>" +
    "<div id='property' class='span10'></div>"
  
  events:
    "click a#back_to_results": "handleBackToResults"
  
  initialize: (options) ->
    @model.on 'change', @render, @
    
  handleBackToResults: (e) ->
    if e
      e.preventDefault()
      e.stopPropagation()
      
    window.history.back()
    
  render: ->
    @$el.html("")
    
    if @model.get('address')
      @$el.html(@template)
      @$('#nav').html(@navTemplate)
      @$('#property').html(_.template(@propertyTemplate, @model.toJSON()))
      @renderPhotos()
    
    return this
    
  renderPhotos: ->
    if @model.get('photos')
      photos = @model.get('photos')
      @$('#photos').html(@photosTemplate)
      i = 0
      while i < photos.length
        @$('#photos_container').append(_.template(@photoTemplate, photos[i]))
        @$('.item').addClass('active') if i == 0
        i++
    else
      @$('#photos').html(@noPhotosTemplate)
    
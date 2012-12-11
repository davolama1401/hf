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
  
  template: "<div id='search'></div>"
  
  initialize: (options) ->
    
  render: ->
    @$el.html(@template)

    searchView = new Hf.Views.PropertySearchView(collection: @collection)
    @$('#search').html(searchView.render().el)
    
    return this
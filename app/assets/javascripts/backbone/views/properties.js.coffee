class Hf.Views.PropertySearchMetaView extends Backbone.View
  template:
    '<p>Total matches: <%= totalMatched %></p>'
    {"meta"=>
      {"totalMatched"=>100,
       "totalPages"=>5,
       "currentPage"=>1,
       "facets"=>
        {"searchByType"=>
          {"1"=>
            {"id"=>1,
             "name"=>"All Homes for Sale",
             "count"=>100,
             "isSelected"=>false},
           "3"=>
            {"id"=>3,
             "name"=>"Agent & Broker Listings",
             "count"=>74,
             "isSelected"=>false},
           "4"=>
            {"id"=>4,
             "name"=>"Owner & Classifieds",
             "count"=>1,
             "isSelected"=>false},
           "5"=>
            {"id"=>5, "name"=>"Foreclosures", "count"=>25, "isSelected"=>false}},
         "city"=>[{"name"=>"Chicago", "count"=>100, "isSelected"=>false}],
         "neighborhood"=>
          [{"name"=>"Lakeview", "count"=>93, "isSelected"=>false},
           {"name"=>"Roscoe Village", "count"=>4, "isSelected"=>false},
           {"name"=>"DePaul", "count"=>1, "isSelected"=>false},
           {"name"=>"Near North Side", "count"=>1, "isSelected"=>false},
           {"name"=>"North Center", "count"=>1, "isSelected"=>false}],
         "county"=>[{"name"=>"Cook", "count"=>100, "isSelected"=>false}],
         "zip"=>[{"name"=>"60657", "count"=>100, "isSelected"=>false}]},
       "area"=>
        {"cities"=>["Chicago"],
         "state"=>"IL",
         "county"=>"Cook",
         "type"=>"zip",
         "name"=>"60657",
         "listingsCount"=>100,
         "latitude"=>0,
         "longitude"=>0,
         "url"=>
          "http://www.homefinder.com/zip-code/60657/min_price_350000/max_price_450000/"},
       "searchResultsUrl"=>
        "http://www.homefinder.com/zip-code/60657/min_price_350000/max_price_450000/",
       "executionTime"=>0.14519095420837},

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
    "<div id='meta'></div>" +
    "<div id='properties'></div>"
  
  initialize: (options) ->
    
  render: ->
    @$el.html(@template)

    searchView = new Hf.Views.PropertySearchView(collection: @collection)
    @$('#search').html(searchView.render().el)
    
    propertiesListView = new Hf.Views.PropertiesListView(collection: @collection)
    @$('#properties').html(propertiesListView.render().el)
    
    return this
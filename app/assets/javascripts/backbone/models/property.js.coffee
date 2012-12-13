class Hf.Models.Property extends Backbone.Model
  urlRoot:  '/api/properties'
  
  parse: (data) ->
    if !data
      return []
    else if data.data
      return data.data.listing
    else
      return data

class Hf.Collections.PropertiesCollection extends Backbone.Collection
  model: Hf.Models.Property
  url: '/api/properties'
  
  parse: (data) ->
    if !data.data
      @meta = null
      return []
    @meta = data.data.meta
    return data.data.listings

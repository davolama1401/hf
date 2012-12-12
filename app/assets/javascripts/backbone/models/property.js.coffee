class Hf.Models.Property extends Backbone.Model
  urlRoot:  '/api/properties'

class Hf.Collections.PropertiesCollection extends Backbone.Collection
  model: Hf.Models.Property
  url: '/api/properties'
  
  parse: (data) ->
    if !data
      @meta = null
      return []
    @meta = data.data.meta
    return data.data.listings

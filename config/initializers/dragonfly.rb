require 'mongoid'
require 'dragonfly'

app = Dragonfly[:uploads]
app.datastore = Dragonfly::DataStorage::MongoDataStore.new

# Allow all mongoid models to use the macro 'file_accessor'
app.define_macro_on_include(Mongoid::Document, :file_accessor)

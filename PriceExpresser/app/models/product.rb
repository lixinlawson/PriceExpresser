require 'elasticsearch/model'

class Product < ActiveRecord::Base
 has_many :prices
 has_many :subs
 validates :product_name, presence: true,length: { minimum: 2 }
 
 include Elasticsearch::Model
 include Elasticsearch::Model::Callbacks

 settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :product_name, analyzer: 'english', index_options: 'offsets'
      indexes :description, analyzer: 'english'
    end
  end


  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['product_name^10', 'description']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            product_name: {},
            description: {}
          }
        }
      }
    )
  end
  def to_param
      product_name
  end
end

Product.__elasticsearch__.client.indices.delete index: Product.index_name rescue nil

Product.__elasticsearch__.client.indices.create \
  index: Product.index_name,
  body: { settings: Product.settings.to_hash, mappings: Product.mappings.to_hash }

Product.import


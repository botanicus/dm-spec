# habtm
# Product.relationships[:colors]
#<DataMapper::Associations::RelationshipChain @parent_model=Product, @name=:color_products, @mutable=true, @child_key=#<PropertySet:{#<Property:ColorProduct:product_slug>}>, @child_model="Color", @parent_key=#<PropertySet:{#<Property:Product:slug>}>, @remote_relationship_name="colors", @options={:repository_name=>:default, :near_relationship_name=>:color_products, :parent_key=>nil, :child_key=>nil, :remote_relationship_name=>"colors", :child_model=>"Color", :min=>0, :parent_model=>Product, :max=>Infinity}, @near_relationship_name=:color_products>

module DataMapperMatchers
  class HasAndBelongsToMany
    # args<Symbol>: :products
    def initialize(name)
      @name = name
    end
    
    # args<Model>: Category
    def matches?(model)
      @model = model
      relationship = @model.relationships[@name]
      return false unless relationship
      relationship.class == DataMapper::Associations::RelationshipChain && relationship.child_model == @model
    end
    
    def description
      "has and belongs to many #{@name}"
    end
    
    def failure_message
      # TODO: filter just n:n relationships
      relationships = @model.relationships.map { |name, relationship| relationship.name }.inspect
      "expected to has and belongs to many #@name, but has just the following relationships: #{relationships}"
    end
    
    def negative_failure_message
      "expected not to has and belongs to many #@name, but had"
    end
  end

  def has_and_belongs_to_many(name)
    HasAndBelongsToMany.new(name)
  end
end

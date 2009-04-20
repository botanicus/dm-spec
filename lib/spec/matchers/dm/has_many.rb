# has 1
# Product.relationships[:item]
#<DataMapper::Associations::Relationship @parent_model=Product, @name=:item, @child_key=#<PropertySet:{#<Property:OrderItem:product_slug>}>, @child_model=OrderItem, @parent_key=#<PropertySet:{#<Property:Product:slug>}>, @options={:min=>1, :class_name=>"OrderItem", :max=>1}>

# has n
# Category.relationships[:products]
#<DataMapper::Associations::Relationship @parent_model=Category, @name=:products, @child_key=#<PropertySet:{#<Property:Product:category_slug>}>, @child_model=Product, @parent_key=#<PropertySet:{#<Property:Category:slug>}>, @options={:min=>0, :max=>Infinity}>

module DataMapperMatchers
  class HasMany
    def initialize(name, options)
      @name    = name
      @options = options
    end
    
    # args<Model>: Category
    def matches?(model)
      @model = model
      relationship = @model.relationships[@name]
      return false unless relationship
      relationship.parent_model == @model && @options.all? { |key, value| relationship.options[key] == value }
    end

    def description
      "has many"
    end
    
    def failure_message
      # TODO: filter just has many relationships
      properties = @model.properties.entries.map { |property| property.name }.inspect
      "expected to has many #@name, but has just the following properties: #{properties}"
    end
    
    def negative_failure_message
      "expected to not has many #@name, but had"
    end
  end

  def has_many(name, options = Hash.new)
    defaults = {:min => 0, :max => 1.0 / 0}
    HasMany.new(name, defaults.merge(options))
  end

  def has_one(name, options = Hash.new)
    defaults = {:min => 1, :max => 1}
    HasMany.new(name, defaults.merge(options))
  end
end

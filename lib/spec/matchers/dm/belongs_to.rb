# belongs to
# Product.relationships[:category]
#<DataMapper::Associations::Relationship @parent_model=Category, @name=:category, @child_key=#<PropertySet:{#<Property:Product:category_slug>}>, @child_model=Product, @parent_key=#<PropertySet:{#<Property:Category:slug>}>, @options={}>

module DataMapperMatchers
  class BelongsTo
    # args<Symbol>: :products
    def initialize(name)
      @name = name
    end
    
    # args<Model>: Category
    def matches?(model)
      @model = model
      relationship = @model.relationships[@name]
      return false unless relationship
      relationship.name == @name && relationship.child_model == @model
    end
    
    def description
      "belongs to"
    end
    
    def failure_message
      belonging = @model.relationships.select { |name, relationship| relationship.name == @name && relationship.child_model == @model }
      belonging.map! { |array| array.first }
      if belonging.empty?
        "expected to belongs to #@name, but does not belongs to any model"
      else
        "expected to belongs to #@name, but belongs to just the following relationships: #{belonging.inspect}"
      end
    end
    
    def negative_failure_message
      "expected not to belongs to #@name, but belonged"
    end
  end

  def belongs_to(name)
    BelongsTo.new(name)
  end
end

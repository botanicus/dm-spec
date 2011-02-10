# Category.properties[:expected]
# => #<Property:Category:expected>
# Category.properties.has_property? :expected
# => true

module DataMapperMatchers
  class HasProperty
    def initialize(expected)
      @expected = expected
    end
    
    # Category.should has_property(:id)
    def matches?(model)
      @model = model
      return @model.properties.named?(@expected)
    end
    
    def description
      "has property '#{@expected}'"
    end
    
    def failure_message
      properties = @model.properties.entries.map { |property| property.name }
      "expected to has property #@expected, but has just the following properties: #{properties}"
    end
    
    def negative_failure_message
      "expected to not has property #@expected, but had"
    end
  end

  def has_property(expected)
    HasProperty.new(expected)
  end
end

# Category.properties[:expected]
# => #<Timestamps:Category:expected>
# Category.properties.has_timestamps? :expected
# => true

module DataMapperMatchers
  class HasTimestamps
    def initialize(*expected)
      # Post.should has_timestamps => :created_at, :updated_at
      expected.push(:at) if expected.empty?
      if [:at, :on].include?(expected.first)
        # Post.should has_timestamps(:at)
        @expected = ["created_#{expected}", "updated_#{expected}"]
      else
        # Post.should has_timestamps(:created_at)
        @expected = expected
      end
    end
    
    # Category.should has_timestamps(:id)
    def matches?(model)
      @model = model
      loaded && included && has_timestamps
    end

    def loaded
      $LOADED_FEATURES.any? { |file| File.basename(file).eql?("dm-timestamps.rb") }
    end

    def included
      @model.respond_to?(:timestamps) # DataMapper::Timestamp model is included
    end

    def has_timestamps
      @expected.all { |method| model.new.respond_to?(method) }
    end
    
    def description
      "has timestamps"
    end
    
    def failure_message
      properties = @model.properties.entries.map { |timestamps| timestamps.name }
      "expected to has timestamps #@expected, but has just the following properties: #{properties}"
    end
    
    def negative_failure_message
      "expected not to not timestamps #@expected, but had"
    end
  end

  def has_timestamps(expected)
    HasTimestamps.new(expected)
  end
end

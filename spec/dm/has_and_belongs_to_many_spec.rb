require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "spec/matchers/dm/has_and_belongs_to_many"

class Post
  include DataMapper::Resource
  property :id, Serial
  has n, :tags, :through => Resource
end

class Tag
  include DataMapper::Resource
  property :id, Serial
  has n, :posts, :through => Resource
end

describe DataMapperMatchers::BelongsTo do
  it "should pass for working associations" do
    Post.should has_and_belongs_to_many(:tags)
    Tag.should has_and_belongs_to_many(:posts)
  end

  it "should fail for non existing working associations" do
    lambda { Post.should_not has_and_belongs_to_many(:tags) }.should fail
  end

  it "should fail for non existing working associations" do
    lambda { Post.should has_and_belongs_to_many(:items) }.should fail_with("expected to has and belongs to many items, but has just the following relationships: [:post_tags, :post_tags, :category]")
  end
end

require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "spec/matchers/dm/has_timestamps"

class Post
  include DataMapper::Resource
  property :id, Serial
  belongs_to :category
end

class Category
  include DataMapper::Resource
  property :id, Serial
  has n, :posts
end

describe DataMapperMatchers::HasTimestamps do
  it "should pass for working associations" do
    Post.should belongs_to(:category)
  end

  it "should fail for non existing working associations" do
    lambda { Post.should_not belongs_to(:category) }.should fail_with("expected not to belongs to category, but belonged")
  end

  it "should fail for non existing working associations" do
    lambda { Post.should belongs_to(:items) }.should fail_with("expected to belongs to items, but has just the following relationships: [:post_tags, :post_tags, :category]")
  end
end

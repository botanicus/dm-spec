require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "spec/matchers/dm/belongs_to"

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

describe DataMapperMatchers::BelongsTo do
  it "should pass for working associations" do
    lambda { Post.should belongs_to(:category) }.should_not fail
  end

  it "should fail for non existing working associations" do
    lambda { Post.should_not belongs_to(:category) }.should fail_with("expected not to belongs to category, but belonged")
  end

  it "should fail for non existing working associations" do
    lambda { Post.should belongs_to(:items) }.should fail_with("expected to belongs to items, but does not belongs to any model")
  end
end

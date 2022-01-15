require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      article_id = "1"
      expect(get: "/articles/#{article_id}/comments").to route_to("comments#index", article_id: article_id)
    end

    it "routes to #create" do
      article_id = "1"
      expect(post: "/articles/#{article_id}/comments").to route_to("comments#create", article_id: article_id)
    end
  end
end

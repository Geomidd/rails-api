require 'rails_helper'

RSpec.describe '/articles routes' do
  it 'routes to articles#index' do
    # expect(get '/articles').to route_to(controller: 'articles', action: 'index')
    aggregate_failures do
      expect(get '/articles').to route_to('articles#index')
      expect(get '/articles?page[number]=3').to route_to('articles#index', page: { 'number' => '3'})
    end
  end

  it 'routes to articles#show' do
    id = '1'
    expect(get "articles/#{id}").to route_to('articles#show', id: id)
  end

  it "should route to articles#create" do
    expect(post "/articles").to route_to("articles#create")
  end

  it "should route to articles#update" do
    id = "1"
    expect(put "/articles/#{id}").to route_to("articles#update", id: id)
    expect(patch "/articles/#{id}").to route_to("articles#update", id: id)
  end

  it "should route to articles#destroy" do
    id = "1"
    expect(delete "/articles/#{id}").to route_to("articles#destroy", id: id)
  end
end
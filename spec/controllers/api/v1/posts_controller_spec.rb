require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'POST #create' do

    context 'with valid params' do
      let(:user) { create(:user) }
      let(:post_params) do {
            title: "post_title",
            content: "post_content",
            user_ip: "127.0.0.1",
            login: user.login
      }
      end

      it 'creates new post' do
        expect { post :create, params: post_params, format: :json }.to change(Post, :count).by(+1)
      end

      it 'have post params keys in response' do
        post :create, params: post_params, format: :json
        json = JSON.parse(response.body)
        expect(json).to include("title")
        expect(json).to include("content")
        expect(json).to include("user_id")
        expect(json).to include("user_ip")
        expect(json).to include("average_rating")
      end

      it 'have created post attribute values in response' do
        post :create, params: post_params, format: :json
        json = JSON.parse(response.body)
        expect(json["title"]).to eql("post_title")
        expect(json["content"]).to eql("post_content")
        expect(json["average_rating"]).to eql(0.0)
        expect(json["user_id"]).to eql(user.id)
      end

      it 'returns response code 200' do
        post :create, params: post_params, format: :json
        expect(response).to have_http_status 200
      end
    end

    context 'with invalid params' do
      let(:post_params) do {
          title: "",
          content: "",
          user_ip: "",
          login: ""
      }
      end

      it 'does not create new posts' do
        expect { post :create, params: post_params, format: :json }.to_not change(Post, :count)
      end

      it 'does not create new users' do
        expect { post :create, params: { post: post_params }, format: :json }.to_not change(User, :count)
      end

      it 'returns response code 422' do
        post :create, params: { post: post_params }, format: :json
        expect(response).to have_http_status 422
      end

      it 'returns validation errors' do
        post :create, params: { post: post_params }, format: :json
        json = JSON.parse(response.body)
        expect(json).to eql([["title", "Can't be blank"], ["content", "Can't be blank"], ["login", "Can't be blank"]])
      end
    end

  end

  describe 'POST #estimate' do
    let(:user) { create :user }
    let(:post_params) do {
        title: "post_title",
        content: "post_content",
        user_id: user.id,
    }
    end
    let(:rated_post) { Post.create(post_params) }
    let(:rate_params) do
      {
          rate: 4,
          post_id: rated_post.id
      }
    end
    let(:rating) { Rating.create(post_id: rated_post.id, rate: 0) }
    let(:invalid_params) do
      {
          rate: '1',
          post_id: 1
      }
    end

    context 'with valid params' do
      it 'creates new rate for post' do
        expect{ post :estimate, params: rate_params, format: :json }.to change(rated_post.ratings, :count).by(+1)
      end

      it 'returns response code 200' do
        post :estimate, params: rate_params, format: :json
        expect(response).to have_http_status 200
      end

      it 'update posts average rating and return updated value' do
        post :estimate, params: rate_params, format: :json
        rated_post.reload
        expect(rated_post.average_rating).to eql(4.0)
        json = JSON.parse(response.body)
        expect(json).to eql(4.0)
      end
    end

    context 'with invalid params' do
      it 'does not create new rate' do
        expect { post :estimate, params: invalid_params, format: :json }.to_not change(Rating, :count)
      end

      it 'returns response code 422' do
        post :estimate, params: invalid_params, format: :json
        expect(response).to have_http_status 422
      end

      it 'returns validation error if post doesnt exist' do
        post :estimate, params: invalid_params, format: :json
        json = JSON.parse(response.body)
        expect(json).to eql(["Can't find post with id 1'"])
      end

      it 'returns validation error if rate value is not correct' do
        post :estimate, params: {post_id: rated_post.id, rate: 'eaer'}, format: :json
        json = JSON.parse(response.body)
        expect(json).to eql([["rate", "Must be a number"], ["rate", "Value must be between 1 and 5"]])
      end
    end
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:post1) { Post.create!(user_id: user.id, title: '1', content: '1', average_rating: 1.0) }
    let(:post2) { Post.create!(user_id: user.id, title: '2', content: '2', average_rating: 2.0) }
    let(:post3) { Post.create!(user_id: user.id, title: '3', content: '3', average_rating: 3.0) }

    before(:each) do
      post1
      post2
      post3
    end

    it 'returns posts with count' do
      get :index, params: { count: 2 }, format: :json
      json = JSON.parse(response.body)
      ids = json.map { |post| post['id'] }
      expect(ids).to eql([post3.id, post2.id])
    end

    it 'returns all posts if count nil' do
      get :index, format: :json
      json = JSON.parse(response.body)
      ids = json.map { |post| post['id'] }
      expect(ids).to eql([post3.id, post2.id, post1.id])
    end

    it 'returns posts with count' do
      get :index, params: { count: 2 }, format: :json
      json = JSON.parse(response.body)
      ids = json.map { |post| post['id'] }
      expect(ids).to eql([post3.id, post2.id])
    end

    it 'returns response code 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #by_ip' do
    let(:user1) { User.create(login: 'spiderman') }
    let(:user2) { User.create(login: 'ironman') }

    let(:post1) { Post.create!(user_id: user1.id, title: '1', content: '1', user_ip: '1.1.1.1') }
    let(:post2) { Post.create!(user_id: user2.id, title: '2', content: '2', user_ip: '1.1.1.1') }
    let(:post3) { Post.create!(user_id: user1.id, title: '3', content: '3', user_ip: '2.2.2.2') }

    before(:each) do
      post1
      post2
      post3
    end

    it 'returns array with grouped by ip posts' do
      get :by_ip, format: :json
      json = JSON.parse(response.body)
      expect(json).to eql([{"ip"=>"1.1.1.1/32", "logins"=>["ironman", "spiderman"]}])
    end
  end
end
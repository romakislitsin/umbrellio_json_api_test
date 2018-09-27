module Api::V1
  class PostsController < ApplicationController
    def index
      posts = Post.by_top_rated(params[:count])
      render status: 200, json: posts, each_serializer: TopRatedPostsSerializer
    end

    def by_ip
      posts = GroupedPostsService.by_ip
      render status: 200, json: posts
    end

    def create
      post = PostCreator.new(post_params).call
      errors = PostValidator.new(post_params).call
      if errors.blank?
        post.save
        render status: 200, json: post
      else
        render status: 422, json: errors
      end
    end

    def estimate
      begin post = Post.find(params[:post_id])
        rate = RateCreator.new(rate_params).call
        errors = RatingValidator.new(rate_params).call
      rescue
        errors = ["Can't find post with id #{params[:post_id]}'"]
      end

      if errors.blank?
        rate.save
        post.update_attributes(average_rating: post.check_average_rating)
        render status: 200, json: post.average_rating
      else
        render status: 422, json: errors
      end
    end

    private
    def post_params
      params.permit(:title, :content, :user_ip, :login)
    end

    def rate_params
      params.permit(:post_id, :rate)
    end
  end
end

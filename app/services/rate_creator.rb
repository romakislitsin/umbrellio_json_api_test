class RateCreator
  def initialize(params)
    @post_id = params[:post_id]
    @rate = params[:rate]
  end

  def call
    Rating.new(post_id: @post_id,
               rate: @rate
               )
  end
end
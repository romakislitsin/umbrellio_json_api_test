class RatingValidator
  def initialize(params)
    @post = params[:post_id]
    @rate = params[:rate].to_f
  end

  def call
    @errors = []
    validate_rate
    validate_rate_value
  end

  private
  def validate_rate
    @errors << [:rate, "Must be a number"] unless @rate.is_a?(Integer)
  end

  def validate_rate_value
    @errors << [:rate, "Value must be between 1 and 5"] if (1..5).exclude?(@rate)
  end
end
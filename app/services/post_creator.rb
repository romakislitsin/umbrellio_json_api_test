class PostCreator
  def initialize(params)
      @title = params[:title]
      @content = params[:content]
      @ip = params[:user_ip]
      @login = params[:login]
  end

  def call
    return unless @login
    user = User.find_or_create_by(login: @login)
    Post.new(title: @title,
             content: @content,
             user: user,
             user_ip: @ip
    )
  end
end
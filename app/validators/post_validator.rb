class PostValidator
  def initialize(params)
    @title = params[:title]
    @content = params[:content]
    @login = params[:login]
  end

  def call
    @errors = []
    title_cant_be_blank
    content_cant_be_blank
    login_cant_be_blank
  end

  private
  def title_cant_be_blank
    @errors << [:title, "Can't be blank"] if @title.blank?
  end

  def content_cant_be_blank
    @errors << [:content, "Can't be blank"] if @content.blank?
  end

  def login_cant_be_blank
    @errors << [:login, "Can't be blank"] if @login.blank?
  end
end
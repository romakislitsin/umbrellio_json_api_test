class GroupedPostsService
  def self.by_ip
    Post.joins(:user)
        .select('text(posts.user_ip) AS ip, array_agg(DISTINCT users.login) AS logins')
        .having('count(DISTINCT users.login) > 1')
        .group('posts.user_ip')
        .as_json(except: [:id])
  end
end
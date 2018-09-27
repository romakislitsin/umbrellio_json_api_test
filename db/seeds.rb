USERS_COUNT  = 100
IPS_COUNT    = 50
POSTS_COUNT  = 200_000
RATED_POSTS_COUNT = 2000

puts "\n> Create users"
logins = []
USERS_COUNT.times do
  user = User.create(login: Faker::Internet.unique.user_name)
  logins << user.login
  print '.'
end
puts "\n> Done (#{User.count} users)"

puts "\n> Generate ips"
ips = []
IPS_COUNT.times do
  ips << Faker::Internet.unique.ip_v4_address
  print '.'
end

puts "\n> Create posts"
POSTS_COUNT.times do
  post_params = {
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph,
      user_ip: ips.sample,
      login: logins.sample
  }
  post = PostCreator.new(post_params).call
  post.save
end
puts "\n> Done (#{Post.count} posts)"

puts "\n> Create ratings"
posts = Post.first(200).map {|post| post.id}
RATED_POSTS_COUNT.times do
  rating_params = {
      post_id: posts.sample,
      rate: rand(1..5)
  }
  rating = RateCreator.new(rating_params).call
  rating.save
  rating.post.update_average_rating
end
puts "\n> Done (#{Rating.count} rated posts)"

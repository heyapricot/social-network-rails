module PostsHelper
  def displayLikers(post)
    n = post.likers.count
    case n
    when 1
      "#{post.likers.first.fullname}"
    when 2
      "#{post.likers.first.fullname} and #{post.likers.second.fullname}"
    when 3
      "#{post.likers.first.fullname}, #{post.likers.second.fullname} and #{post.likers.third.fullname}"
    when n > 3
      "#{post.likers.first.fullname}, #{post.likers.second.fullname} and #{n - 2} others"
    end
  end
end

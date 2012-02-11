module CommentsHelper
  def has_comment_rights?(comment)
    (current_user && comment.user_id == current_user.id) ? true : false
  end 
end

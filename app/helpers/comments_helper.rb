module CommentsHelper
  def has_comment_rights?(comment)
    current_user && comment.user_id == current_user.id
  end 
end

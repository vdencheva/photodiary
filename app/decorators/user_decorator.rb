class UserDecorator < ApplicationDecorator
  decorates :user

  def avatar_src(size = :standard)
    user.send("avatar_#{size}") || h.asset_path("noavatar_#{size}.png")
  end
end
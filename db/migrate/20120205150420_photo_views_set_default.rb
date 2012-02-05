class PhotoViewsSetDefault < ActiveRecord::Migration
  def up
    change_column_default(:photos,:views,0)
  end

  def down
  end
end

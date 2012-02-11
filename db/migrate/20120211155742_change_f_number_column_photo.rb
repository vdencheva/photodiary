class ChangeFNumberColumnPhoto < ActiveRecord::Migration
  def up
    change_column :photos, :f_number, :string
  end

  def down
    change_column :photos, :f_number, :text
  end
end

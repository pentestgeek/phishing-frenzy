class AddAdminIdToModels < ActiveRecord::Migration
  def change
    add_reference :campaigns, :admin, index: true, foreign_key: true
    add_reference :templates, :admin, index: true, foreign_key: true
  end
end

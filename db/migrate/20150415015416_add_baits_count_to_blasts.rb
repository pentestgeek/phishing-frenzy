class AddBaitsCountToBlasts < ActiveRecord::Migration
  def self.up
    add_column :blasts, :baits_count, :integer, default: 0

    # assign counters for existing records
    Blast.reset_column_information
    Blast.all.each do |b|
      Blast.update_counters b.id, :baits_count => b.baits.length
    end
  end

  def self.down
    remove_column :blasts, :baits_count
  end
end

class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.string :for
      t.integer :kms

      t.timestamps
    end
  end
end

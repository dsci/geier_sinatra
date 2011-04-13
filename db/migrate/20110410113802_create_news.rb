class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news, :force => true do |t|
      t.string :title
      t.text :text
      t.string :author
      t.string :tags
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end

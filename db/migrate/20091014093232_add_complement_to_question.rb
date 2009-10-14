class AddComplementToQuestion < ActiveRecord::Migration
  
  def self.up
    add_column :questions, :complement, :text
  end

  
  def self.down
    remove_column :questions, :complement
  end
  
end

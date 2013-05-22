# encoding: UTF-8
class AlterQuestionsAddDefaultValueToRequirement < ActiveRecord::Migration
  def self.up
    change_column :questions, :required, :string, default: '', null: false
  end

  def self.down
    change_column :questions, :required, :string, default: nil, null: true
  end
end
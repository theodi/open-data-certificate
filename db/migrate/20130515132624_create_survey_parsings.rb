class CreateSurveyParsings < ActiveRecord::Migration
  def change
    create_table :survey_parsings do |t|
      t.string :file_name
      t.string :md5

      t.timestamps
    end

    add_index :survey_parsings, :file_name
  end
end

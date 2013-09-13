class UpdateTranslationTextSize < ActiveRecord::Migration
  def up
    change_column :survey_translations, :translation, :text, :limit => 16777215 #mysql mediumtext
  end

  def down
    change_column :survey_translations, :translation, :text, :limit => 65535 #mysql text
  end
end

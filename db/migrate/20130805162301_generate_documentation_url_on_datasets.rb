class GenerateDocumentationUrlOnDatasets < ActiveRecord::Migration
  def up
    Dataset.all.each {|d| d.documentation_url}
  end

  def down
  end
end

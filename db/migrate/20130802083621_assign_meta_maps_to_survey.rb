class AssignMetaMapsToSurvey < ActiveRecord::Migration
  def up
    meta = {
        dataset_title: "dataTitle", 
        dataset_curator: "publisher",
        dataset_documentation_url: "documentationUrl"
      }.to_yaml
    
    Survey.update_all({meta_map: meta}, {meta_map: nil})
  end

  def down
  end
end

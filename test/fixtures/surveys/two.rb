# gb == Survey::DEFAULT_ACCESS_CODE
survey "gb", :meta_map => {dataset_title: 'title', dataset_curator: 'title', dataset_documentation_url: 'title' }  do
  section "first" do
    q_title 'name?'
    a_1 'title', :string
  end
end
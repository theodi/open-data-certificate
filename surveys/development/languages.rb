# encoding: UTF-8
survey "dv1", :full_title => 'Language Test (dv1)', :dataset_title => 'dataTitle', :dataset_curator => 'dataTitle', default_locale_name: 'English' do
  translations :en =>:default, :es => "../translations/languages.es.yml", :he => "../translations/languages.he.yml", :ko => "../translations/languages.ko.yml"

  section_one "One", display_header: false do

    q_dataTitle "What's a good title for this data?"
    a_1 'Data Title', :string

    q_name "What is your name?"
    a_name :string, :help_text => "My name is..."
  
  end
  section_two "Two" do
    q_color "What is your favorite color?"
    a_name :string

    label_translate_me "does this translate"

    q_pavlingMgp 'am I mandatory', :required => :standard
    a_nameMgp :string, :help_text => "required...", :requirement => 'standard_7'
    dependency :rule => 'A'
    condition_A :q_color, "==", {:string_value => "red", :answer_reference => "name"}

    label 'You should be awesome',
          :custom_renderer => '/partials/requirement_standard',
          :requirement => 'standard_7'
    dependency :rule => 'A'
    condition_A :q_color, "==", {:string_value => "red", :answer_reference => "name"}

  end
end

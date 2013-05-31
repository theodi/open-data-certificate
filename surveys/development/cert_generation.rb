survey 'Certificate Generator',  :dataset_title => 'q_dataTitle', 
  :description => 'This is a development survey to test out the generation of the certificates' do
  
  section 'General', :display_header => false do
    

    q_dataTitle 'What\'s a good title for this data?',
                :text_as_statement => 'Data Title',
                :display_on_certificate => true,
                :help_text => 'We need to know this to populate your dataset'

    a_1 'what you call the data', :string


    # we won't show this question
    q_releaseType 'Data release type?', :pick => :one,
                :text_as_statement => 'Data Title'

    a_oneoff 'a one-off release of a single dataset'
    a_collection 'a one-off release of a set of related datasets'
    a_series 'ongoing release of a series of related datasets'
    a_service 'a service or API for accessing open data'

  end

  section_legal 'Legal Information' do

    q_publisherRights 'Do you have the rights to publish the data as open data?',
                      :pick => :one,
                      :required => :required,
                      :text_as_statement => 'Curators publishing rights',
                      :display_on_certificate => true
    a_yes 'yes, you have the right to publish the data as open data',
          :text_as_statement => 'curator has the right to publish the data as open data'   
    a_no 'no, you don\'t have the right to publish the data as open data',
          :text_as_statement => 'curator doesn\'t have the right to publish the data as open data'
    a_unsure 'you don\'t know whether you have the right to publish the data as open data',
          :text_as_statement => 'curator doesn\'t know if they have the right to publish the data as open data'


    # include if dependency met
    q_publisherOrigin 'Was *all* this data originally created or gathered by you?',
      :pick => :one,
      :required => :required,
      :text_as_statement => 'Data was gathered by curator',
      :display_on_certificate => true

    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no'
    a_true 'yes'


  end

  section_practical 'Practical Information' do

    # not shown
    q_linkedTo 'Is documentation about the data findable within three clicks of your organisation\'s home page?',
      :pick => :one
    a_false 'no'
    a_true 'yes'

  end

end
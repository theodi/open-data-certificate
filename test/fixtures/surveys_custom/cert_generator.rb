survey 'cert-generator', 
  dataset_title: 'dataTitle', 
  dataset_curator: 'dataTitle', 
  description: '' do
  
  section 'General', :display_header => false do
    

    q_dataTitle 'What\'s a good title for this data?'

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
                      :required => :required
    a_yes 'yes, you have the right to publish the data as open data'
    a_no 'no, you don\'t have the right to publish the data as open data'
    a_unsure 'you don\'t know whether you have the right to publish the data as open data'


    # include if dependency met
    q_publisherOrigin 'Was *all* this data originally created or gathered by you?',
      :pick => :one,
      :required => :required

    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no'
    a_true 'yes'

    q_chooseAny 'Choose some of these options',
      :pick => :any,
      :required => :required

    a_one '1'
    a_two '2'
    a_three '3'


  end

  section_practical 'Practical Information' do

    # not shown
    q_linkedTo 'Is documentation about the data findable within three clicks of your organisation\'s home page?',
      :pick => :one
    a_false 'no'
    a_true 'yes'

  end

end
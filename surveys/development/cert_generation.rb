survey 'Certificate Generator' do

  section 'General' do
    
    q_dataTitle 'What\'s a good title for this data?'
    a_1 'Data Title', :string

    q_releaseType 'Data release type?', :pick => :one
    a_oneoff 'a one-off release of a single dataset'
    a_collection 'a one-off release of a set of related datasets'
    a_series 'ongoing release of a series of related datasets'
    a_service 'a service or API for accessing open data'

  end

end
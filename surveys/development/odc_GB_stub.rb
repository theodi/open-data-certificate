survey 'GB',
  :full_title => 'United Kingdom',
  :default_mandatory => 'false',
  :dataset_title => 'dataTitle',
  :status => 'beta',
  :description => '<p>This self-assessment questionnaire generates an open data certificate and badge you can publish to tell people all about this open data. We also use your answers to learn how organisations publish open data.</p><p>When you answer these questions it demonstrates your efforts to comply with relevant UK legislation. You should also check which other laws and policies apply to your sector, especially if you’re outside the UK (which these questions don’t cover).</p><p><strong>You do not need to answer all the questions to get a certificate.</strong> Just answer those you can.</p>' do

  translations :en => :default
  section_general 'General Information',
    :description => '',
    :display_header => false do

    q_dataTitle 'What\'s this data called?',
      :help_text => 'People see the name of your open data in a list of similar ones so make this as unambiguous and descriptive as you can in this tiny box so they quickly identify what\'s unique about it.',
      :required => :required
    a_1 'Data Title',
      :string,
      :placeholder => 'Data Title',
      :required => :required

    q_documentationUrl 'Where is it described?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is described at',
      :help_text => 'Give a URL for people to read about the contents of your open data and find more detail. It can be a page within a bigger catalog like data.gov.uk.'
    a_1 'Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation URL',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'You should have a <strong>web page that offers documentation</strong> about the open data you publish so that people can understand its context, content and utility.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'You must have a <strong>web page that gives documentation</strong> and access to the open data you publish so that people can use it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Who publishes this data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is published by',
      :help_text => 'Give the name of the organisation who publishes this data. It’s probably who you work for unless you’re doing this on behalf of someone else.',
      :required => :required
    a_1 'Data Publisher',
      :string,
      :placeholder => 'Data Publisher',
      :required => :required

    q_publisherUrl 'What website is the data published on?',
      :display_on_certificate => true,
      :text_as_statement => 'The data is published on',
      :help_text => 'Give a URL to a website, this helps us to group data from the same organisation even if people give different names.'
    a_1 'Publisher URL',
      :string,
      :input_type => :url,
      :placeholder => 'Publisher URL'

    q_releaseType 'What kind of release is this?',
      :pick => :one,
      :required => :required
    a_oneoff 'a one-off release of a single dataset',
      :help_text => 'This is a single file and you don’t currently plan to publish similar files in the future.'
    a_collection 'a one-off release of a set of related datasets',
      :help_text => 'This is a collection of related files about the same data and you don’t currently plan to publish similar collections in the future.'
    a_series 'ongoing release of a series of related datasets',
      :help_text => 'This is a sequence of datasets with planned periodic updates in the future.'
    a_service 'a service or API for accessing open data',
      :help_text => 'This is a live web service that exposes your data to programmers through an interface they can query.'

  end

end

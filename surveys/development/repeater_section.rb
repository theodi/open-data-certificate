# encoding: UTF-8
survey "repeater-section", full_title: 'Repeater Section', dataset_title: 'dataTitle', dataset_curator: 'dataTitle' do
  
  section_one "One", display_header: false do

    q_dataTitle "What's a good title for this data?"
    a_1 'Data Title', :string

    repeater 'Listing' do
      q_listing 'Where is it listed?',
        :display_on_certificate => true,
        :text_as_statement => 'The data appears in this collection',
        :help_text => 'Give a URL where this data is listed within a relevant collection. For example, data.gov.uk (if it\'s UK public sector data), hub.data.ac.uk (if it\'s UK academia data) or a URL for search engine results.',
        :required => :required
      a_1 'Listing URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Listing URL'

    end

  end

end

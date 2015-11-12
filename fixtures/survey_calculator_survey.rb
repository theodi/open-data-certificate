survey 'GB',
  :full_title => 'United Kingdom',
  :status => 'beta',
  :description => '<p>This self-assessment questionnaire generates an open data certificate and badge you can publish to tell people all about this open data. We also use your answers to learn how organisations publish open data.</p><p>When you answer these questions it demonstrates your efforts to comply with relevant UK legislation. You should also check which other laws and policies apply to your sector, especially if you’re outside the UK (which these questions don’t cover).</p><p><strong>You do not need to answer all the questions to get a certificate.</strong> Just answer those you can.</p>' do

  translations :en => :default
  section_general 'General Information',
    :description => '',
    :display_header => false do

    q_dataTitle 'What\'s this data called?',
      :discussion_topic => :dataTitle,
      :help_text => 'People see the name of your open data in a list of similar ones so make this as unambiguous and descriptive as you can in this tiny box so they quickly identify what\'s unique about it.',
      :required => :required
    a_1 'Data Title',
      :string,
      :placeholder => 'Data Title'

    q_optionalQuestion 'Completely optional question'
    a_1 'Say anything',
      :string,
      :placeholder => 'Say anything...'

    q_documentationUrl 'Where is it described?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'This data is described at',
      :help_text => 'Give a URL for people to read about the contents of your open data and find more detail. It can be a page within a bigger catalog like data.gov.uk.'
    a_1 'Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation URL',
      :corresponding_requirements => ['pilot_1', 'basic_1']

    label_pilot_1 'You should have a <strong>web page that offers documentation</strong> about the open data you publish so that people can understand its context, content and utility.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'You must have a <strong>web page that gives documentation</strong> and access to the open data you publish so that people can use it.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_2 'Rights',
      :help_text => 'your right to share this data with people'

    q_publisherRights 'Do you have the rights to publish this data as open data?',
      :discussion_topic => :gb_publisherRights,
      :help_text => 'If your organisation didn\'t originally create or gather this data then you might not have the right to publish it. If you’re not sure, check with the data owner because you will need their permission to publish it.',
      :corresponding_requirements => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'yes, you have the rights to publish this data as open data',
      :corresponding_requirements => ['standard_1']
    a_no 'no, you don\'t have the rights to publish this data as open data'
    a_unsure 'you\'re not sure if you have the rights to publish this data as open data'
    a_complicated 'the rights in this data are complicated or unclear'

    label_standard_1 'You should have a <strong>clear legal right to publish this data</strong>.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_group_3 'Licensing',
      :help_text => 'how you give people permission to use this data'

    q_copyrightURL 'Where have you published the rights statement for this dataset?',
      :discussion_topic => :gb_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'The rights statement is at',
      :help_text => 'Give the URL to a page that describes the right to re-use this dataset. This should include a reference to its license, attribution requirements, and a statement about relevant copyright and database rights. A rights statement helps people understand what they can and can\'t do with the data.'
    a_1 'Rights Statement URL',
      :string,
      :input_type => :url,
      :placeholder => 'Rights Statement URL',
      :corresponding_requirements => ['pilot_4']

    label_pilot_4 'You should <strong>publish a rights statement</strong> that details copyright, database rights, licensing and how people should give attribution to the data.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Under which licence can people reuse this data?',
      :discussion_topic => :gb_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'This data is available under',
      :help_text => 'Remember that whoever originally gathers, creates, verifies or presents a database automatically gets rights over it. There may also be copyright in the organisation and selection of data. So people need a waiver or a licence which proves that they can use the data and explains how they can do that legally. We list the most common licenses here; if there are no database rights or copyright, they\'ve expired, or you\'ve waived them, choose \'Not applicable\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_odc_by 'Open Data Commons Attribution License',
      :text_as_statement => 'Open Data Commons Attribution License'
    a_odc_odbl 'Open Data Commons Open Database License (ODbL)',
      :text_as_statement => 'Open Data Commons Open Database License (ODbL)'
    a_odc_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_ogl_uk 'UK Open Government Licence',
      :text_as_statement => 'UK Open Government Licence'
    a_na 'Not applicable',
      :text_as_statement => ''
    a_other 'Other...',
      :text_as_statement => ''

    q_copyrightStatementMetadata 'Does your rights statement include machine-readable versions of',
      :discussion_topic => :gb_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'The rights statement includes data about',
      :help_text => 'It\'s good practice to embed information about rights in machine-readable formats so people can automatically attribute this data back to you when they use it.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    a_dataLicense 'data licence',
      :text_as_statement => 'its data licence',
      :corresponding_requirements => ['standard_4']
    a_contentLicense 'content licence',
      :text_as_statement => 'its content licence',
      :corresponding_requirements => ['standard_5']
    a_attribution 'attribution text',
      :text_as_statement => 'what attribution text to use',
      :corresponding_requirements => ['standard_6']
    a_attributionURL 'attribution URL',
      :text_as_statement => 'what attribution link to give',
      :corresponding_requirements => ['standard_7']
    a_copyrightNotice 'copyright notice or statement',
      :text_as_statement => 'a copyright notice or statement',
      :corresponding_requirements => ['exemplar_1']
    a_copyrightYear 'copyright year',
      :text_as_statement => 'the copyright year',
      :corresponding_requirements => ['exemplar_2']
    a_copyrightHolder 'copyright holder',
      :text_as_statement => 'the copyright holder',
      :corresponding_requirements => ['exemplar_3']
    a_databaseRightYear 'database right year',
      :text_as_statement => 'the database right year',
      :corresponding_requirements => ['exemplar_4']
    a_databaseRightHolder 'database right holder',
      :text_as_statement => 'the database right holder',
      :corresponding_requirements => ['exemplar_5']

    label_standard_4 'You should provide <strong>machine-readable data in your rights statement about the licence</strong> for this data, so automatic tools can use it.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_exemplar_1 'You should provide <strong>machine-readable data in your rights statement about the copyright statement or notice of this data</strong>, so automatic tools can use it.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_group_4 'Privacy',
      :help_text => 'how you protect people\'s privacy'

    q_machineReadable 'Is this data machine-readable?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'This data is',
      :help_text => 'People prefer data formats which are easily processed by a computer, for speed and accuracy. For example, a scanned photocopy of a spreadsheet would not be machine-readable but a CSV file would be.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :corresponding_requirements => ['pilot_16']

    label_pilot_16 'You should <strong>provide your data in a machine-readable format</strong> so that it\'s easy to process.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'The documentation includes machine-readable data for',
      :pick => :any
    a_title 'title',
      :text_as_statement => 'title',
      :corresponding_requirements => ['standard_36']
    a_description 'description',
      :text_as_statement => 'description',
      :corresponding_requirements => ['standard_37']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :corresponding_requirements => ['standard_38']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :corresponding_requirements => ['standard_39']
    a_accrualPeriodicity 'frequency of releases',
      :text_as_statement => 'release frequency',
      :corresponding_requirements => ['standard_40']
    a_identifier 'identifier',
      :text_as_statement => 'identifier',
      :corresponding_requirements => ['standard_41']
    a_landingPage 'landing page',
      :text_as_statement => 'landing page',
      :corresponding_requirements => ['standard_42']
    a_language 'language',
      :text_as_statement => 'language',
      :corresponding_requirements => ['standard_43']
    a_publisher 'publisher',
      :text_as_statement => 'publisher',
      :corresponding_requirements => ['standard_44']
    a_spatial 'spatial/geographical coverage',
      :text_as_statement => 'spatial/geographical coverage',
      :corresponding_requirements => ['standard_45']
    a_temporal 'temporal coverage',
      :text_as_statement => 'temporal coverage',
      :corresponding_requirements => ['standard_46']
    a_theme 'theme(s)',
      :text_as_statement => 'theme(s)',
      :corresponding_requirements => ['standard_47']
    a_keyword 'keyword(s) or tag(s)',
      :text_as_statement => 'keyword(s) or tag(s)',
      :corresponding_requirements => ['standard_48']
    a_distribution 'distribution(s)',
      :text_as_statement => 'distribution(s)'

    label_standard_36 'You should <strong>include a machine-readable data title in your documentation</strong> so that people know how to refer to it.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_documentationMetadata, '!=', :a_title

    label_standard_37 'You should <strong>include a machine-readable data description in your documentation</strong> so that people know what it contains.',
      :is_requirement => true
    dependency :rule => 'A'
    condition_A :q_documentationMetadata, '!=', :a_description

    repeater 'Account' do

      q_account 'Which social media accounts can people reach you on?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Contact the curator through these social media accounts',
        :help_text => 'Give URLs to your social media accounts, like your Twitter or Facebook profile page.',
        :required => :required

      a_1 'Social Media URL',
        :string,
        :input_type => :url,
        :placeholder => 'Social Media URL'

    end

  end

end

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

  section_legal 'Legal Information',
    :description => 'Rights, licensing and privacy' do

    label_group_2 'Rights',
      :help_text => 'your right to share this data with people',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Do you have the rights to publish this data as open data?',
      :help_text => 'If your organisation didn\'t originally create or gather this data then you might not have the right to publish it. If you’re not sure, check with the data owner because you will need their permission to publish it.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'yes, you have the rights to publish this data as open data'
    a_no 'no, you don\'t have the rights to publish this data as open data'
    a_unsure 'you\'re not sure if you have the rights to publish this data as open data'

    label_basic_2 'You must have the <strong>right to publish your data</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_publisherOrigin 'Was <em>all</em> this data originally created or gathered by you?',
      :display_on_certificate => true,
      :text_as_statement => 'This data was',
      :help_text => 'If any part of this data was sourced outside your organisation by other individuals or organisations then you need to give extra information about your right to publish it.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'originally created or generated by its curator'

    q_thirdPartyOrigin 'Was some of this data extracted or calculated from other data?',
      :help_text => 'An extract or smaller part of someone else\'s data still means your rights to use it might be affected. There might also be legal issues if you analysed their data to produce new results from it.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_3']

    label_basic_3 'You indicated that this data wasn\'t originally created or gathered by you, and wasn\'t crowdsourced, so it must have been extracted or calculated from other data sources.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Are <em>all</em> sources of this data already published as open data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is created from',
      :help_text => 'You\'re allowed to republish someone else\'s data if it\'s already under an open data licence or if their rights have expired or been waived. If any part of your data is not like this then you\'ll need legal advice before you can publish it.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'open data sources',
      :requirement => ['basic_4']

    label_basic_4 'You should get <strong>legal advice to make sure you have the right to publish this data</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Was some of this data crowdsourced?',
      :display_on_certificate => true,
      :text_as_statement => 'Some of this data is',
      :help_text => 'If your data includes information contributed by people outside your organisation, you need their permission to publish their contributions as open data.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'crowdsourced',
      :requirement => ['basic_5']

    label_basic_5 'You indicated that the data wasn\'t originally created or gathered by you, and wasn\'t extracted or calculated from other data, so it must have been crowdsourced.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Did contributors to your data use their judgement?',
      :help_text => 'If people used their creativity or judgement to contribute data then they have copyright over their work. For example, writing a description or deciding whether or not to include some data in a dataset would require judgement. So contributors must transfer or waive their rights, or license the data to you before you can publish it.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl 'Where is the Contributor Licence Agreement (CLA)?',
      :display_on_certificate => true,
      :text_as_statement => 'The Contributor Licence Agreement is at',
      :help_text => 'Give a link to an agreement that shows contributors allow you to reuse their data. A CLA will either transfer contributor\'s rights to you, waive their rights, or license the data to you so you can publish it.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'Contributor Licence Agreement URL',
      :string,
      :input_type => :url,
      :placeholder => 'Contributor Licence Agreement URL',
      :required => :required

    q_cldsRecorded 'Have all contributors agreed to the Contributor Licence Agreement (CLA)?',
      :help_text => 'Check all contributors agree to a CLA before you reuse or republish their contributions. You should keep a record of who gave contributions and whether or not they agree to the CLA.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_6']

    label_basic_6 'You must get <strong>contributors to agree to a Contributor Licence Agreement</strong> (CLA) that gives you the right to publish their work as open data.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Where do you describe sources of this data?',
      :display_on_certificate => true,
      :text_as_statement => 'The sources of this data are described at',
      :help_text => 'Give a URL that documents where your data was sourced from (its provenance) and the rights under which you publish the data. Do this even if the data wasn\'t originally created or gathered by you and even though you have the rights to publish it.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Data Sources Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Data Sources Documentation URL',
      :requirement => ['pilot_2']

    label_pilot_2 'You should document <strong>where your data came from and the rights under which you publish it</strong>, so people are assured they can use parts which came from third parties.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Is documentation about the sources of this data also in machine-readable format?',
      :display_on_certificate => true,
      :text_as_statement => 'The curator has published',
      :help_text => 'Information about data sources should be human-readable so people can understand it, as well as in a metadata format that computers can process. When everyone does this it helps other people find out how the same open data is being used and justify its ongoing publication.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable data about the sources of this data',
      :requirement => ['standard_1']

    label_standard_1 'You should <strong>include machine-readable data about the sources of your data</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Licensing',
      :help_text => 'how you give people permission to use your data',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Where do you describe copyright and database rights?',
      :display_on_certificate => true,
      :text_as_statement => 'Copyright and database rights are described at',
      :help_text => 'Give a URL to a rights statement which shows who owns copyright and database rights to the data. This statement also says what you allow people to do with this data under licence and it helps them understand the terms under which you make it available.'
    a_1 'Rights Statement URL',
      :string,
      :input_type => :url,
      :placeholder => 'Rights Statement URL',
      :requirement => ['pilot_3']

    label_pilot_3 'You should have a <strong>web page that states your copyright</strong> and details of how people should give attribution to your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_copyrightStatementMetadata 'Does your rights statement include machine-readable versions of',
      :display_on_certificate => true,
      :text_as_statement => 'The rights statement includes data about',
      :help_text => 'It\'s good practice to embed information about licences in machine-readable formats so people can automatically attribute your data back to you when they use it.',
      :help_text_more_url => 'http://labs.creativecommons.org/2011/ccrel-guide/',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_license 'licences',
      :text_as_statement => 'the data licence',
      :requirement => ['standard_2']
    a_attribution 'attribution',
      :text_as_statement => 'what attribution to use',
      :requirement => ['exemplar_1']
    a_attributionURL 'attribution URL',
      :text_as_statement => 'what attribution link to give',
      :requirement => ['exemplar_2']
    a_morePermissions 'other permissions or alternative licences',
      :text_as_statement => 'other permissions for use'
    a_useGuidelines 'non-binding use guidelines',
      :text_as_statement => 'guidelines for use'

    label_standard_2 'You should provide <strong>machine-readable data in your copyright statement about licences</strong> which affect your data so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_license

    label_exemplar_1 'You should provide <strong>machine-readable data in your copyright statement about attribution</strong> of your data so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_exemplar_2 'You should provide <strong>machine-readable data in your copyright statement about the URL of your data</strong> that must be linked to, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    q_dataLicence 'Under which licence can people reuse this data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is available under',
      :help_text => 'Remember that whoever originally gathers, creates, verifies or presents a database automatically gets rights over it. So people need a waiver or a licence which proves that they can use the data and explains how they can do that legally. We list the most common licenses here; if there are no database rights, they\'ve expired, or you\'ve waived them, choose \'Not applicable\'.',
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
    a_uk_ogl 'UK Open Government Licence',
      :text_as_statement => 'UK Open Government Licence'
    a_na 'Not applicable',
      :text_as_statement => ''
    a_other 'Other...',
      :text_as_statement => ''

    q_dataNotApplicable 'Why does a licence not apply to this data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is not licensed because',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'there are no database rights in this data',
      :text_as_statement => 'there are no database rights in it',
      :help_text => 'Database rights apply if you spent substantial effort gathering, verifying or presenting it. There are no database rights if, for example, the data is created from scratch, presented in an obvious way, and not checked against anything.'
    a_expired 'database rights have expired',
      :text_as_statement => 'the database rights have expired',
      :help_text => 'Database rights last ten years. If data was last changed over ten years ago then database rights have expired.'
    a_waived 'database rights have been waived',
      :text_as_statement => '',
      :help_text => 'This means no one owns the rights and anyone can do whatever they want with this data.'

    q_dataWaiver 'Which waiver do you use to waive database rights?',
      :display_on_certificate => true,
      :text_as_statement => 'Database rights have been waived with',
      :help_text => 'You need a statement to show people you\'ve done this so that they understand they can do whatever they like with this data. Standard waivers already exist like PDDL and CCZero but you can write your own with legal advice.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Other...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Where is the waiver for the database rights?',
      :display_on_certificate => true,
      :text_as_statement => 'Database rights have been waived with',
      :help_text => 'Give a URL to your own publicly available waiver so people can check that it does waive your database rights.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'Waiver URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Waiver URL'

    q_otherDataLicenceName 'What is the name of your licence?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is available under',
      :help_text => 'If you use a different licence, we need the name so people can see it on your Open Data Certificate.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Other Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Other Licence Name'

    q_otherDataLicenceURL 'Where is your licence?',
      :display_on_certificate => true,
      :text_as_statement => 'This licence is at',
      :help_text => 'Give a URL to the licence, so people can see it on your Open Data Certificate and check that it\'s publicly available.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Other Licence URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Other Licence URL'

    q_otherDataLicenceOpen 'Is the licence an open licence?',
      :help_text => 'If you aren\'t sure what an open licence is then read the <a href="http://opendefinition.org/">Open Knowledge Definition</a> definition. Next, choose your licence from the <a href="http://licenses.opendefinition.org/">Open Definition Advisory Board open licence list</a>. If a licence isn\'t in their list, it\'s either not open or hasn\'t been assessed yet.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_7']

    label_basic_7 'You must <strong>publish open data under an open licence</strong> so that people can use it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentLicence 'Under which licence can others reuse content?',
      :display_on_certificate => true,
      :text_as_statement => 'The content is available under',
      :help_text => 'Remember that whoever spends intellectual effort creating content automatically gets rights over it but creative content does not include facts. So people need a waiver or a licence which proves that they can use the content and explains how they can do that legally. We list the most common licenses here; if there is no copyright in the content, it\'s expired, or you\'ve waived them, choose \'Not applicable\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc_by 'Creative Commons Attribution',
      :text_as_statement => 'Creative Commons Attribution'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike',
      :text_as_statement => 'Creative Commons Attribution Share-Alike'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_uk_ogl 'UK Open Government Licence',
      :text_as_statement => 'UK Open Government Licence'
    a_na 'Not applicable',
      :text_as_statement => ''
    a_other 'Other...',
      :text_as_statement => ''

    q_contentNotApplicable 'Why doesn\'t a licence apply to this data?',
      :display_on_certificate => true,
      :text_as_statement => 'The content in this data is not licensed because',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_na
    a_norights 'there is no copyright in this data',
      :text_as_statement => 'there is no copyright',
      :help_text => 'Copyright only applies to data if you spent intellectual effort creating what\'s in it, for example, by writing text that\'s within the data, or deciding whether particular data is included. There\'s no copyright if the data only contains facts where no judgements were made about whether to include them or not.'
    a_expired 'copyright has expired',
      :text_as_statement => 'copyright has expired',
      :help_text => 'Copyright lasts for a fixed amount of time, based on either the number of years after the death of its creator or its publication. You should check when the content was created or published because if that was a long time ago, copyright might have expired.'
    a_waived 'copyright has been waived',
      :text_as_statement => '',
      :help_text => 'This means no one owns copyright and anyone can do whatever they want with this data.'

    q_contentWaiver 'Which waiver do you use to waive copyright?',
      :display_on_certificate => true,
      :text_as_statement => 'Copyright has been waived with',
      :help_text => 'You need a statement to show people you\'ve done this, so they understand that they can do whatever they like with this data. Standard waivers already exist like PDDL and CCZero but you can write your own with legal advice.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_na
    condition_B :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Other...',
      :text_as_statement => 'Other...'

    q_contentOtherWaiver 'Where is the waiver for the copyright?',
      :display_on_certificate => true,
      :text_as_statement => 'Copyright has been waived with',
      :help_text => 'Give a URL to your own publicly available waiver so people can check that it does waive your copyright.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_contentLicence, '==', :a_na
    condition_B :q_contentNotApplicable, '==', :a_waived
    condition_C :q_contentWaiver, '==', :a_other
    a_1 'Waiver URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Waiver URL'

    q_otherContentLicenceName 'What\'s the name of the licence?',
      :display_on_certificate => true,
      :text_as_statement => 'The content is available under',
      :help_text => 'If you use a different licence, we need its name so people can see it on your Open Data Certificate.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Licence Name'

    q_otherContentLicenceURL 'Where is the licence?',
      :display_on_certificate => true,
      :text_as_statement => 'The content licence is at',
      :help_text => 'Give a URL to the licence, so people can see it on your Open Data Certificate and check that it\'s publicly available.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Licence URL'

    q_otherContentLicenceOpen 'Is the licence an open licence?',
      :help_text => 'If you aren\'t sure what an open licence is then read the <a href="http://opendefinition.org/">Open Knowledge Definition</a> definition. Next, choose your licence from the <a href="http://licenses.opendefinition.org/">Open Definition Advisory Board open licence list</a>. If a licence isn\'t in their list, it\'s either not open or hasn\'t been assessed yet.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 'You must <strong>publish open data under an open licence</strong> so that people can use it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_other
    condition_B :q_otherContentLicenceOpen, '==', :a_false

    label_group_4 'Privacy',
      :help_text => 'how you protect people\'s privacy',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Can individuals be identified from this data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data contains',
      :pick => :one,
      :required => :pilot
    a_not_personal 'no, the data is not about people or their activities',
      :text_as_statement => 'no data about individuals',
      :help_text => 'Remember that individuals can still be identified even if data isn\'t directly about them. For example, road traffic flow data combined with an individual\'s commuting patterns could reveal information about that person.'
    a_summarised 'no, the data has been aggregated so individuals can\'t be identified',
      :text_as_statement => 'aggregated data',
      :help_text => 'Statistical analysis can aggregate data so that individuals are no longer be identifiable.'
    a_individual 'yes, there is a risk that individuals be identified, for example by third parties with access to extra information',
      :text_as_statement => 'information that could identify individuals',
      :help_text => 'Some data is legitimately about individuals like civil service pay or public expenses for example.'

    q_appliedAnon 'Have you attempted to reduce or remove the possibility of individuals being identified?',
      :display_on_certificate => true,
      :text_as_statement => 'This data about individuals has been',
      :help_text => 'Anonymisation reduces the risk of individuals being identified from the data you publish. The best technique to use depends on the kind of data you have and this is explored in the <a href="http://www.ico.org.uk/news/latest_news/2012/~/media/documents/library/Data_Protection/Practical_application/anonymisation_code.ashx">ICO Anonymisation Code of Practice</a>.',
      :help_text_more_url => 'http://www.ico.org.uk/news/latest_news/2012/~/media/documents/library/Data_Protection/Practical_application/anonymisation_code.ashx',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'anonymised'

    q_lawfulDisclosure 'Are you required or permitted by law to publish this data about individuals?',
      :display_on_certificate => true,
      :text_as_statement => 'By law, this data about individuals',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'must be published',
      :requirement => ['pilot_4']

    label_pilot_4 'You should <strong>only publish personal data without anonymisation if you are required or permitted to do so by law</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Where do you document your right to publish data about individuals?',
      :display_on_certificate => true,
      :text_as_statement => 'The right to publish this data about individuals is documented at'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'Disclosure Rationale URL',
      :string,
      :input_type => :url,
      :placeholder => 'Disclosure Rationale URL',
      :requirement => ['standard_4']

    label_standard_4 'You should <strong>document your right to publish data about individuals</strong> for people who use your data and for those affected by disclosure.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_privacyImpactAssessmentExists 'Have you carried out a Privacy Impact Assessment?',
      :display_on_certificate => true,
      :text_as_statement => 'The curator has',
      :help_text => 'A <a href="http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx">Privacy Impact Assessment</a> is how you measure risks to the privacy of individuals in your data as well as the use and disclosure of that information.',
      :help_text_more_url => 'http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'not carried out a Privacy Impact Assessment'
    a_true 'yes',
      :text_as_statement => 'carried out a Privacy Impact Assessment',
      :requirement => ['pilot_5']

    label_pilot_5 'You should <strong>do a Privacy Impact Assessment</strong> if you publish data about individuals.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_false

    q_privacyImpactAssessmentUrl 'Where is your Privacy Impact Assessment published?',
      :display_on_certificate => true,
      :text_as_statement => 'The Privacy Impact Assessment is published at',
      :help_text => 'Give a URL to where people can check how you have assessed the privacy risks to individuals. This may be redacted or summarised if it contains sensitive information.',
      :help_text_more_url => 'http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    a_1 'Privacy Impact Assessment URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Impact Assessment URL',
      :requirement => ['standard_5']

    label_standard_5 'You should <strong>publish your Privacy Impact Assessment</strong> so people can understand how you have assessed the risks of disclosing data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_privacyImpactAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_piaAudited 'Has your Privacy Impact Assessment been independently audited?',
      :display_on_certificate => true,
      :text_as_statement => 'The Privacy Impact Assessment has been',
      :help_text => 'It\'s good practice to check your assessment was done correctly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_privacyImpactAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_6']

    label_standard_6 'You should <strong>have your Privacy Impact Assessment audited independently</strong> to ensure it has been carried out correctly.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_privacyImpactAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_piaAudited, '==', :a_false

    q_individualConsentURL 'Where is the privacy notice for individuals affected by your data?',
      :display_on_certificate => true,
      :text_as_statement => 'Individuals affected by this data have this privacy notice',
      :help_text => 'When you collect data about individuals you must tell them how that data will be used. People who use your data need this to make sure they comply with the Data Protection Act.',
      :help_text_more_url => 'http://www.ico.org.uk/for_organisations/data_protection/the_guide/principle_2'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    a_1 'Privacy Notice URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Notice URL',
      :requirement => ['pilot_6']

    label_pilot_6 'You should <strong>tell people what purposes the individuals in your data consented to you using their data for</strong>. So that they use your data for the same purposes and comply with the Data Protection Act.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Is there someone in your organisation who is responsible for data protection?',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_dbStaffConsulted 'Have you involved them in the Privacy Impact Assessment process?',
      :display_on_certificate => true,
      :text_as_statement => 'The individual responsible for data protection',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'has been consulted',
      :requirement => ['pilot_7']

    label_pilot_7 'You should <strong>involve the person responsible for data protection</strong> in your organisation before you publish this data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Has your anonymisation approach been independently audited?',
      :display_on_certificate => true,
      :text_as_statement => 'The anonymisation of the data has been',
      :help_text => 'It is good practice to make sure your process to remove personal identifiable data works properly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_7']

    label_standard_7 'You should <strong>have your anonymisation process audited independently</strong> by an expert to ensure it is appropriate for your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_social 'Social Information',
    :description => 'Documentation, support and services' do

    label_group_15 'Documentation',
      :help_text => 'how you help people understand the context and content of your data',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :display_on_certificate => true,
      :text_as_statement => 'The documentation includes machine-readable data for',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'title',
      :text_as_statement => 'title',
      :requirement => ['standard_30']
    a_description 'description',
      :text_as_statement => 'description',
      :requirement => ['standard_31']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :requirement => ['standard_32']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :requirement => ['standard_33']
    a_accrualPeriodicity 'frequency of releases',
      :text_as_statement => 'release frequency',
      :requirement => ['standard_34']
    a_identifier 'identifier',
      :text_as_statement => 'identifier',
      :requirement => ['standard_35']
    a_landingPage 'landing page',
      :text_as_statement => 'landing page',
      :requirement => ['standard_36']
    a_language 'language',
      :text_as_statement => 'language',
      :requirement => ['standard_37']
    a_publisher 'publisher',
      :text_as_statement => 'publisher',
      :requirement => ['standard_38']
    a_spatial 'spatial/geographical coverage',
      :text_as_statement => 'spatial/geographical coverage',
      :requirement => ['standard_39']
    a_temporal 'temporal coverage',
      :text_as_statement => 'temporal coverage',
      :requirement => ['standard_40']
    a_theme 'theme(s)',
      :text_as_statement => 'theme(s)',
      :requirement => ['standard_41']
    a_keyword 'keyword(s) or tag(s)',
      :text_as_statement => 'keyword(s) or tag(s)',
      :requirement => ['standard_42']
    a_distribution 'distribution(s)',
      :text_as_statement => 'distribution(s)'
  end
end

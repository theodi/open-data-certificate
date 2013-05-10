survey 'Open Data Certificate Questionnaire',
  :default_mandatory => 'false' do

  section 'General Information' do

    q_dataTitle 'What\'s a good title for this data?',
      :help_text => 'This is the title that we will give to the open data within the Open Data Certificate. It will probably be the same as what you call the data elsewhere, but you should aim to be unambiguous, and consider the fact that there might be certificates for lots of similar open data.'
    a_1 'Data Title',
      :string,
      :placeholder => 'Data Title',
      :required => :required

    q_documentationUrl 'Where is the data described?',
      :help_text => 'This should be the URL of a page that describes the open data and what it contains. This might be a page that describes the dataset within a catalog such as data.gov.uk. We ask for this page because it\'s useful for reusers to know about it, and because if it\'s written well then we can fill in a lot of things in this questionnaire based on the information within that page.'
    a_1 'Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation URL',
      :requirement => 'pilot_1'

    label 'You should have a page that provides documentation about the open data you are publishing so that reusers can understand its context, content and utility.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label 'You must have a page that provides documentation and access to the open data you are publishing so that reusers can get hold of it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'What\'s the name of the curating organisation?',
      :help_text => 'This is the organisation that the open data will be associated with the Open Data Certificate. It should be the organisation that manages the creation of and curates the open data. The data might actually be published by someone else, such as central government or a third-party contractor.'
    a_1 'Data Curator',
      :string,
      :placeholder => 'Data Curator',
      :required => :required

    q_publisherUrl 'What\'s the website for the curating organisation?',
      :help_text => 'This should be the main website for your organisation or group. We use this to provide a link through to your organisation and to help us gather together all the open data curated by your organisation even if different people spell your organisation\'s name differently.'
    a_1 'Curator URL',
      :string,
      :input_type => :url,
      :placeholder => 'Curator URL'

    q_releaseType 'What kind of data release is this?',
      :pick => :one,
      :required => :required
    a_oneoff 'a one-off release of a single dataset',
      :help_text => 'Choose this option if the open data release is the publication of a single file, such as a spreadsheet, with no intention to publish similar files in the future.'
    a_collection 'a one-off release of a set of related datasets',
      :help_text => 'Choose this option if the open data release is the publication of a collection of related files, such as several spreadsheets created from the same underlying data, with no intention to publish similar collections in the future.'
    a_series 'ongoing release of a series of related datasets',
      :help_text => 'Choose this open if you are releasing a series of datasets on a regular schedule, such as releasing a particular dataset every month.'
    a_service 'a service or API for accessing open data',
      :help_text => 'Choose this option if you are providing an API or a web service. This option includes linked data publications where underlying data is exposed through a website.'

  end

  section 'Legal Information' do

    label 'Rights',
      :help_text => 'ensuring that you have the right to publish the data',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Do you have the rights to publish the data as open data?',
      :help_text => 'Unless all the data was originally created or gathered by your organisation, you might not have the right to republish it. We ask this question to check that you have considered the ownership of the data. If you aren\'t sure, we will ask further questions about the source of the data you\'re publishing to find out.',
      :pick => :one,
      :required => :required
    a_yes 'yes, you have the right to publish the data as open data'
    a_no 'no, you don\'t have the right to publish the data as open data'
    a_unsure 'you don\'t know whether you have the right to publish the data as open data'

    label 'You must have the right to publish data that you publish.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_publisherOrigin 'Was *all* this data originally created or gathered by you?',
      :help_text => 'If not all the data was originally created or gathered by you then you might not have the right to republish it. Answer \'no\' to this question if the data includes information that was sourced from outside your organisation, or if it includes data that other individuals or organisations have contributed. We ask this question to work out whether we have to ask about other organisations or people who might own some of the data.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no'
    a_true 'yes'

    q_thirdPartyOrigin 'Was some of this data extracted or calculated from other data?',
      :help_text => 'You might have extracted data from another dataset, for example through an online service. Or you might have downloaded someone else\'s dataset and analysed it to create the data. In both these cases, we need to check that there are no legal barriers to you republishing the results of this data.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes'

    label 'You have said that the data wasn\'t originally created or gathered by you, and wasn\'t crowd-sourced, so it must have been extracted or calculated from other data sources.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Are *all* the other data sources published as open data by their owners?',
      :help_text => 'Open data is data that has been published under an open data licence or where the rights over that data have expired or been waived. If your data is created based on other data that is published as open data, then you can republish it. If your data incorporates data that is not published as open data, you will need to get legal advice to ensure that you can reuse that data and republish the results.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You should get legal advice to ensure that you have the right to republish this data.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Was some of this data crowd-sourced?',
      :help_text => 'Crowd-sourcing involves collating data that is contributed by people operating outside your organisation. We ask about crowd-sourcing because if the data includes information that was contributed by others, you need to ensure that they granted their permission to publish their contributions as open data.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes'

    label 'You have said that the data wasn\'t originally created or gathered by you, and wasn\'t extracted or calculated from other data, so it must have been crowd-sourced.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Did contributions require judgement?',
      :help_text => 'The individuals who contributed to your data may have needed to employ their creativity or judgement to make their contributions. For example, writing a description or choosing whether or not to include some data in a dataset would require judgement. If judgement is involved, the contributors will have copyright over their contributions, so we will then need to check that they have transferred or waived their rights, or licensed the data, to you.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl 'Where is the Contributor Licence Agreement (CLA)?',
      :help_text => 'A Contributor Licence Agreement is an agreement with contributors that ensures that you can reuse the data that they contribute. It will either transfer the rights in the contributions to you, waive their rights, or license the data to you such that you can republish it.[Read more...](http://en.wikipedia.org/wiki/Contributor_License_Agreement)'
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

    q_cldsRecorded 'Have all contributors agreed to the CLA?',
      :help_text => 'All contributors need to agree to a Contributor Licence Agreement (CLA) so that you can reuse or republish their contributions. You should keep a record of who has provided contributions and whether or not they have agreed to the CLA.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You must obtain agreement to a Contributor Licence Agreement from the contributors to your data to give you the right to republish their contributions as open data.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Where do you describe the sources of the data?',
      :help_text => 'If not all the data was originally created or gathered by you then even if you have the rights to publish it, it is good practice to document where the data was sourced from (its provenance) and the rights under which you are publishing the data.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Data Sources Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Data Sources Documentation URL',
      :requirement => 'pilot_2'

    label 'You should document where the data was sourced from and the rights under which you are publishing the data so reusers are assured that they can reuse the parts sourced from third parties.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Does the documentation about the sources of the data include machine-readable data?',
      :help_text => 'The documentation about the sources of the data needs to be human-readable, so that reusers can work out what it says, but it also helps if it contains machine-readable metadata. This helps those people who publish open data to find out how their data is being used, which helps them to justify its ongoing publication.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no'
    a_true 'yes'

    label 'You should include machine-readable data about the sources of data that you\'re using.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label 'Licensing',
      :help_text => 'giving other people permission to reuse the data',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Where is your copyright statement?',
      :help_text => 'A copyright statement states who owns the copyright and database rights in the data, and it says what you are allowing reusers can do with that data, usually by indicating its licence. We are asking where it is to check that you have one, to point reusers to it, and so we can automatically find out more about the terms under which you\'re making the data available.'
    a_1 '',
      :string,
      :input_type => :url,
      :requirement => 'pilot_3'

    label 'You should have a page that states your copyright over the data and provides details of any attribution that people should use so that reusers understand how they can reuse it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A'

    q_copyrightStatementMetadata 'Does your copyright statement include machine-readable data for:',
      :help_text => 'If you have a copyright statement, it is good to embed within it machine-readable information about the licence under which you are making your data available. We can use this to automatically fill in parts of this questionnaire. Others can use it to automatically create attribution statements when they reuse your data.[Read more...](http://labs.creativecommons.org/2011/ccrel-guide/)',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_license 'licences',
      :requirement => 'standard_2'
    a_attribution 'attribution',
      :requirement => 'exemplar_1'
    a_attributionURL 'attribution URL',
      :requirement => 'exemplar_2'
    a_morePermissions 'additional permissions or alternative licences'
    a_useGuidelines 'non-binding use guidelines'

    label 'You should provide machine-readable data in your copyright statement about the licences that should be used when the data is reused so that automated tools can flag the data as open data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_license

    label 'You should provide machine-readable data in your copyright statement about the attribution that should be used when the data is reused so that automated tools can use the information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label 'You should provide machine-readable data in your copyright statement about the URL that should be linked to when the data is reused so that automated tools can use the information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    q_dataLicence 'Under which licence can others reuse the data?',
      :help_text => 'The creator of a database automatically gets database rights where they spend substantial effort gathering, verifying and presenting data. You need to have a waiver or a licence that covers the database rights in the data so reusers know that they can reuse it. The licences that are listed here are the ones that are most commonly used; if there are no database rights, they\'ve expired, or you\'ve waived them, choose \'Not applicable\'. We ask about the licence because we want to make sure that the data is actually open for others to reuse from a legal perspective.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_odc-by 'Open Data Commons Attribution License'
    a_odc-by-sa 'Open Data Commons Open Database License (ODbL)'
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons CCZero'
    a_ogl 'UK Open Government Licence'
    a_na 'Not applicable'
    a_other 'Other...'

    q_dataNotApplicable 'Why is a licence not applicable for this data?',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'there is no database right in this data',
      :help_text => 'You only have a database right in this data if you have spent substantial effort gathering, verifying or presenting the data. It\'s possible that there\'s no database right in the data, for example if the data is created from scratch, presented in an obvious way, and not checked against anything.'
    a_expired 'the applicable database rights have expired',
      :help_text => 'Database rights last for ten years. If the data was last changed more than ten years ago, then the database rights within it will have expired.'
    a_waived 'the applicable database rights have been waived',
      :help_text => 'You can waive your database rights, which means that no one owns them and anyone can do whatever they want with the data.'

    q_dataWaiver 'Which waiver are you using to waive database rights?',
      :help_text => 'If you waive your database right, you need to have a statement that says that you\'ve done so, so that reusers know that they can do whatever they like with the data. There are existing waivers that you can use (PDDL and CCZero). You can author your own, but you should have legal advice if you do.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons CCZero'
    a_other 'Other...'

    q_dataOtherWaiver 'Where is the waiver for the database rights?',
      :help_text => 'If you have created your own waiver, we ask where it is so that we can check that it\'s publicly available and so that we can point reusers to it so they can check that it does in fact waive your database rights.'
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'Waiver URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Waiver URL'

    q_otherDataLicenceName 'What\'s the name of the licence?',
      :help_text => 'If you are using another licence, we ask for its name so that we can refer to it within the Open Data Certificate.'
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 '',
      :string,
      :required => :required

    q_otherDataLicenceURL 'What\'s the location the licence?',
      :help_text => 'If you are using another licence, we ask for a pointer to it so that we can link to it from within your Open Data Certificate and so that we can check that it is publicly accessible.'
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 '',
      :string,
      :input_type => :url,
      :required => :required

    q_otherDataLicenceOpen 'Is the licence an open licence?',
      :help_text => 'The [Open Knowledge Definition](http://opendefinition.org/) defines what an open data licence is and the [Open Definition Advisory Board]() maintain a list of [open licences](http://licenses.opendefinition.org/). If the licence is not given in that list, it it is either not open or hasn\'t yet been assessed.[Read more...](http://opendefinition.org/)',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes'

    label 'You must publish open data under an open licence so that others can reuse it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentLicence 'Under which licence can others reuse the content?',
      :help_text => 'The creator of content automatically gets copyright over that content when they spend intellectual effort creating it. Note that creative content does not include facts. You need to have a waiver or licence that covers the copyright in the data so reusers know that they can reuse it. The licences that are listed here are the ones that are most commonly used; if there is no copyright in the data, it\'s expired, or you\'ve waived copyright, choose \'Not applicable\'. We ask about the licence because we want to make sure that the data is actually open for others to reuse from a legal perspective.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc-by 'Creative Commons Attribution'
    a_cc-by-sa 'Creative Commons Attribution Share-Alike'
    a_cc0 'Creative Commons CCZero'
    a_ogl 'UK Open Government Licence'
    a_na 'Not applicable'
    a_other 'Other...'

    q_contentNotApplicable 'Why is a licence not applicable for this data?',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_na
    a_norights 'there is no copyright in this data',
      :help_text => 'You only have a copyright in this data if you have spent creative intellectual effort creating it, for example by creating text that is included within the data, or exercising judgement in choosing whether particular data is included. It\'s possible that there\'s no copyright in the data, for example if it only contains facts with no judgement involved in selecting what to include.'
    a_expired 'the applicable copyright has expired',
      :help_text => 'Copyright lasts for a fixed length of time, based on either a number of years after the death of its creator or the publication of the content. If the content was created or published a long time ago, the copyright may have expired.'
    a_waived 'the applicable copyright has been waived',
      :help_text => 'You can waive your copyright, which means that no one owns it and anyone can do whatever they want with the data.'

    q_contentWaiver 'Which waiver are you using to waive copyright?',
      :help_text => 'If you waive your copyright, you need to have a statement that says that you\'ve done so, so that reusers know that they can do whatever they like with the data. You can use an existing waiver (CCZero) or you can author your own, but you should have legal advice if you do.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_na
    condition_B :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero'
    a_other 'Other...'

    q_contentOtherWaiver 'Where is the waiver for the copyright?',
      :help_text => 'If you have created your own waiver, we ask where it is so that we can check that it\'s publicly available and so that we can point reusers to it so they can check that it does in fact waive your copyright.'
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
      :help_text => 'If you are using another licence, we ask for its name so that we can refer to it within the Open Data Certificate.'
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Licence Name'

    q_otherContentLicenceURL 'What\'s the location the licence?',
      :help_text => 'If you are using another licence, we ask for a pointer to it so that we can link to it from within your Open Data Certificate and so that we can check that it is publicly accessible.'
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Licence URL'

    q_otherContentLicenceOpen 'Is the licence an open licence?',
      :help_text => 'The [Open Knowledge Definition](http://opendefinition.org/) defines what an open data licence is and the [Open Definition Advisory Board]() maintain a list of [open licences](http://licenses.opendefinition.org/). If the licence is not given in that list, it it is either not open or hasn\'t yet been assessed.[Read more...](http://opendefinition.org/)',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes'

    label 'You must publish open data under an open licence so that others can reuse it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_other
    condition_B :q_otherContentLicenceOpen, '==', :a_false

    label 'Privacy',
      :help_text => 'ensuring that you protect people\'s privacy',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Could the source of this data be personal data under the Data Protection Act?',
      :pick => :one,
      :required => :pilot
    a_not_personal 'no, the data could never be personal data as it is not about people or their activity',
      :help_text => 'Data that is about the activity of people can be personal data if there\'s the potential for it to be combined with other data to identify individuals. For example, data about road traffic flows is about people\'s activity and could be combined with other information (about an individual\'s commuting patterns) to reveal information about that individual.'
    a_personal 'yes, the source of this data is classified as personal data within your organisation',
      :help_text => 'Personal data is data that relates to a living individual who can be identified from the data or from the data in combination with other information. If your organisation has other information that can be used to identify the individuals in the source of this data, then it must be classified as personal data within your organisation.[Read more...](http://www.ico.org.uk/for_organisations/data_protection/the_guide/key_definitions)'
    a_possibly 'yes, the source of this data could be classified as personal data if held by other people who have access to additional information',
      :help_text => 'Personal data is data that relates to a living individual who can be identified from the data or from the data in combination with other information. Even if your organisation doesn\'t have other information that could be used to identify the individuals in the source of this data, it may be that other people do have access to such information.[Read more...](http://www.ico.org.uk/for_organisations/data_protection/the_guide/key_definitions)'

    q_consentExempt 'Is this data exempt from the non-disclosure provisions of the Data Protection Act?',
      :help_text => 'There are exemptions from the non-disclosure provisions of the Data Protection Act, which mean that organisations do not have to comply with the normal non-disclosure provisions.[Read more...](http://www.ico.org.uk/for_organisations/data_protection/the_guide/exemptions)',
      :pick => :one,
      :required => :pilot
    dependency :rule => '(A or B)'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    a_false 'no'
    a_true 'yes'

    q_privacyImpactAssessmentUrl 'Where is your privacy impact assessment published?',
      :help_text => 'A [Privacy Impact Assessment](http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx) is a process for identifying privacy risks to individuals in the collection, use and disclosure of information. We ask where it is published because this enables us to check that it exists.[Read more...](http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx)'
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    a_1 'Privacy Impact Assessment URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Impact Assessment URL',
      :requirement => 'pilot_4'

    label 'You should carry out a a privacy impact assessment to identify risks of releasing the data, mitigations against those risks, and to put in place processes that ensure that any breaches are handled effectively.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    condition_D :q_privacyImpactAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_piaAudited 'Has your Privacy Impact Assessment been independently audited?',
      :help_text => 'An independent audit of a privacy impact assessment will check that the assessment has been carried out correctly. We ask if it has been independently audited to assess the rigour of the privacy impact assessment.',
      :pick => :one
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    condition_D :q_privacyImpactAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no'
    a_true 'yes'

    label 'You should have your privacy impact assessment independently audited to ensure that it has been carried out correctly.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => '(A or B) and C and D and E'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    condition_D :q_privacyImpactAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_E :q_piaAudited, '==', :a_false

    q_individualConsentURL 'Where is the privacy notice you provide to affected individuals published?',
      :help_text => 'Unless you are exempt from the non-disclosure provisions of the Data Protection Act, you are required to give individuals privacy notices when collecting data about them, which should specify the purposes for which that data will be used. We ask where these are because reusers need to be able to look at them so that they can stick within the confines of the Data Protection Act when they are handling the data.[Read more...](http://www.ico.org.uk/for_organisations/data_protection/the_guide/principle_2)'
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    a_1 'Privacy Notice URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Notice URL',
      :requirement => 'pilot_5'

    label 'You should inform potential reusers about the purposes of processing personal data which individuals were informed of, so that reusers can comply with the Data Protection Act and use the data consistently with that consent.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    condition_D :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_personalDataAnonymisation 'Has your anonymisation approach been audited?',
      :help_text => 'An audit of your anonymisation approach will ensure that you have carried out the appropriate anonymisation technique for your data, and carried it out effectively. This can be done by a specialist within your organisation or an independent third party.',
      :pick => :one
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    a_false 'no'
    a_true 'yes'

    label 'You should engage an expert to audit your anonymisation approach to ensure that it is appropriate for your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_false
    condition_D :q_personalDataAnonymisation, '==', :a_false

    q_privacyImpactAssessment 'Have you carried out a privacy impact assessment?',
      :help_text => 'A [Privacy Impact Assessment](http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx) is a process for identifying privacy risks to individuals in the collection, use and disclosure of information. Even if you are exempt from the non-disclosure provisions of the Data Protection Act, you should carry out a privacy impact assessment so that you are aware of the possible risks of making the data open. We do not expect you to publish this privacy impact assessment because it might contain sensitive information about the risks that you are prepared to take.[Read more...](http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx)',
      :pick => :one
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You should carry out a a privacy impact assessment to identify risks of releasing the data, mitigations against those risks, and to put in place processes that ensure that any breaches are handled effectively.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_true
    condition_D :q_privacyImpactAssessment, '==', :a_false

  end

  section 'Practical Information' do

    label 'Findability',
      :help_text => 'helping reusers to locate the data',
      :customer_renderer => '/partials/fieldset'

    q_linkedTo 'Is documentation about the data findable within three clicks of your organisation\'s home page?',
      :help_text => 'The documentation about the data that should be findable is the page that you have given as the Documentation URL. This should be findable by clicking on links from the home page of your organisation (not through searching).',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should ensure that reusers can easily find your data from your organisation\'s home page.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A'

    q_listed 'Is the data listed somewhere, alongside data from the wider sector?',
      :help_text => 'You can make your data easier to find by making sure that it is listed within relevant data catalogs and by ensuring it turns up in relevant search results.',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should ensure that reusers can locate your data through searching for it in locations that list available data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A'

    repeater 'Listing' do

      dependency :rule => 'A'      condition_A :q_listed, '==', :a_true      q_listing 'Where is the data listed?',
        :help_text => 'Give a URL that leads to a listing of this data alongside data from the wider sector.  For example, give a URL for a search that includes this data\'s listing on data.gov.uk (if it\'s UK public sector data), hub.data.ac.uk (if it\'s UK academia data), MEDIN (if it\'s marine data), or the URL of a search on Google or Bing.'
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Listing URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Listing URL'

    end

    label 'Accuracy',
      :help_text => 'providing assurance that the data is up to date',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Does the data underlying the API change over time?',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'no, the API simply provides easy access to unchanging data',
      :help_text => 'Some APIs are created by processing a single unchanging dataset: the purpose of the API is to make accessing this data easier, particularly when there is lots of that data.'
    a_changing 'yes, the API provides instant access to changing data',
      :help_text => 'Some APIs are created over changeable data, and the primary purpose of the API is to provide up-to-date access to this data.'

    q_timeSensitive 'Will this data go out of date?',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'yes, this data will go out of date over time',
      :help_text => 'For example, a dataaset that contains the current location of bus stops will go out of date over time, as some bus stops are moved or new bus stops created.'
    a_timestamped 'yes, this data will go out of date over time but the data is timestamped',
      :help_text => 'For example, demography statistics usually include a timestamp to indicate the time at which the statistics were relevant.',
      :requirement => 'pilot_7'
    a_false 'no, this data does not contain any time-sensitive information',
      :help_text => 'For example, a dataset that contains the results of an experiment will not go out of date because the data accurately reports the results of the experiment.',
      :requirement => 'standard_7'

    label 'You should include timestamps in your data when releasing data that will go out of date over time, so that reusers know the time period it relates to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label 'You should publish updates to data that goes out of date so that the information you provide does not go stale.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Does the data you capture change on at least a daily basis?',
      :help_text => 'Indicate whether you create or gather new data continuously, such that the underlying data changes most days. We ask about this because when data changes frequently it also goes out of date quickly, so we need to check that the releases that you are making are also made quickly and frequently.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no'
    a_true 'yes'

    q_seriesType 'What type of dataset series is this?',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'regular copies of the complete database',
      :help_text => 'Select this option if you are publishing copies of the contents of your database at regular intervals. For example, you would choose this option if you had a database of bus stops and created a new, updated, version of that dataset every day. We ask this because when you are creating database dumps, it is often useful for reusers to be able to access a feed of the changes to the database so that they can keep their copies up to date.'
    a_aggregate 'regular aggregates of changing data',
      :help_text => 'Select this option if you are creating new datasets at regular intervals. This might be because you are creating aggregates because the underlying data cannot be released as open data. Or it might be that you only publish the data that is new since the last publication.'

    q_changeFeed 'Is a feed of changes made available?',
      :help_text => 'Indicate whether you make available a feed of the changes that occur to the data that you capture, such as new entries or amendments to existing entries. A feed might be in a format such as RSS or Atom, or a custom data format.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no'
    a_true 'yes'

    label 'You should provide a feed of changes in your data so that it\'s easy for reusers to keep their copies up to date.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'How frequently do you create a new release?',
      :help_text => 'We ask about the frequency with which you publish new datasets in the series because this determines how out of date the data that you are making available will get before reusers can get an update to their data.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'less frequently than once a month'
    a_monthly 'at least every month',
      :requirement => 'pilot_8'
    a_weekly 'at least every week',
      :requirement => 'standard_8'
    a_daily 'at least every day',
      :requirement => 'exemplar_4'

    label 'You should create a new dataset release every month so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label 'You should create a new dataset release every week so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label 'You should create a new dataset release every day so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'What is the delay between creating a dataset and publishing it?',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'longer than the gap between releases',
      :help_text => 'For example, if you are creating a new version of the dataset every day, then choose this option if it takes more than a day for the dataset to then be published.'
    a_reasonable 'about the same as the gap between releases',
      :help_text => 'For example, if you are creating a new version of the dataset every day, then choose this option if it takes about a day for the dataset to then be published.',
      :requirement => 'pilot_9'
    a_good 'less than half the gap between releases',
      :help_text => 'For example, if you are creating a new version of the dataset every day, then choose this option if it takes less than twelve hours for the data to then be published.',
      :requirement => 'standard_9'
    a_minimal 'there is minimal or no delay',
      :help_text => 'Choose this option if the delay is in the order of a few seconds if the datasets are created frequently, or a few minutes if they are made less frequently.',
      :requirement => 'exemplar_5'

    label 'You should have a delay between creating and publishing a dataset that is less than the gap between releases so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label 'You should have a delay between creating and publishing a dataset that is less than half the gap between releases so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label 'You should have minimal or no delay between creating and publishing datasets so that reusers can access up-to-date information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Do you also provide dumps of the dataset?',
      :help_text => 'A dump is an extract of the data into a static file that developers can download to get hold of the whole dataset. Being able to access a dump of the whole dataset enables different kinds of analyses than API access.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no'
    a_true 'yes'

    label 'You should enable reusers to download the entire dataset so that they can analyse it in its entirety.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'How frequently do you create a new dump?',
      :help_text => 'Providing new database dumps within a short period ensures that new developers can get started with up-to-date data whenever they start looking at the data.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'less frequently than once a month'
    a_monthly 'at least every month',
      :requirement => 'pilot_10'
    a_weekly 'within a week of any change',
      :requirement => 'standard_11'
    a_daily 'within a day of any change',
      :requirement => 'exemplar_6'

    label 'You should create a new database dump every month, so that new reusers can get hold of an up-to-date dump.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label 'You should create a new database dump within a week of any change, so that new reusers do not have long to wait for an up-to-date dump.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label 'You should create a new database dump within a day of any change, so that new reusers can easily get hold of an up-to-date dump.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Will this data be corrected if it contains errors?',
      :help_text => 'Indicate whether the data will be corrected in cases where errors are discovered within the data. We ask this because it is good practice to correct data that is revealed to contain errors (especially as you should be using this data yourself), and because if you do correct the data you need to provide additional support for reusers who will need to be informed of these corrections.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You should correct data that is found to contain errors so that all users benefit from improvements in accuracy.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label 'Quality',
      :help_text => 'helping reusers to understand where there might be problems in the data',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Where are known issues with the quality of the data documented?',
      :help_text => 'There are usually areas within any non-trivial data where there are known quality problems. For example, maybe the equipment that collected the data malfunctioned for a day, or the data was migrated between two systems and errors crept in during that migration. Documenting these helps reusers to have a better understanding of the data that they are using.'
    a_1 'Quality Issues URL',
      :string,
      :input_type => :url,
      :placeholder => 'Quality Issues URL',
      :requirement => 'standard_13'

    label 'You should document any known issues with the quality of the data so that reusers can understand how much they can rely on the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'

    q_qualityControlUrl 'Where is your quality control process described?',
      :help_text => 'A quality control process checks the quality of the data on an ongoing basis, either by hand or automatically, or through a combination of techniques. Having a publicly available description of your quality control process reassures reusers that you are checking the quality of the data that you are making available, and helps them to identify places that could be improved.'
    a_1 'Quality Control Process Description URL',
      :string,
      :input_type => :url,
      :placeholder => 'Quality Control Process Description URL',
      :requirement => 'exemplar_7'

    label 'You should document your quality control process so that reusers can understand how much they can rely on the data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A'

    label 'Guarantees',
      :help_text => 'helping reusers to understand how much to rely on the data',
      :customer_renderer => '/partials/fieldset'

    q_serviceAvailability 'What is the guaranteed availability of the service?',
      :help_text => 'You will probably have in place a service-level agreement (SLA) with the service provider for the servers that you are using to host the data. These SLAs should indicate guaranteed up-time for the servers, and hence the availability of your data.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_minimal 'there are minimal guarantees about the availability of the service'
    a_99 'at least 99% availability',
      :requirement => 'pilot_11'
    a_99_9 'at least 99.9% availability',
      :requirement => 'standard_14'
    a_99_999 'at least 99.999% availability',
      :requirement => 'exemplar_8'

    label 'You should guarantee at least 99% availability (less than 3.65 days downtime/year) of the service so that reusers know they can rely on it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_99
    condition_C :q_serviceAvailability, '!=', :a_99_9
    condition_D :q_serviceAvailability, '!=', :a_99_999

    label 'You should guarantee at least 99.9% availability (less than 8.76 hours downtime/year) of the service so that reusers know they can rely on it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_99_9
    condition_C :q_serviceAvailability, '!=', :a_99_999

    label 'You should guarantee at least 99.999% availability (less than 5.26 minutes downtime/year) of the service so that reusers know they can rely on it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_99_999

    q_onGoingAvailability 'For how long will the data be available in this way?',
      :pick => :one
    a_experimental 'this data may disappear at any time'
    a_short 'this data is available experimentally but should be around for another year or so',
      :requirement => 'pilot_12'
    a_medium 'this data is included in your medium-term plans and should therefore be around for a couple of years',
      :requirement => 'standard_15'
    a_long 'this data is part of your business-as-usual operation and will continue to be published long term',
      :requirement => 'exemplar_9'

    label 'You should provide a guarantee to reusers that the data will be available in this form for about a year so that they know they can rely on it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label 'You should provide a guarantee to reusers that the data will be available in this form in the medium term so that they know they can rely on it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label 'You should provide a guarantee to reusers that the data will be available in this form long term so that they know they can rely on it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section 'Technical Information' do

    label 'Locations',
      :help_text => 'helping reusers to access the data',
      :customer_renderer => '/partials/fieldset'
    dependency :rule => '(A or B or C or D)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true

    q_datasetUrl 'What\'s the URL of the dataset?',
      :help_text => 'This should be the URL of the dataset itself (for example a CSV file). This is a different URL from the page that describes the dataset. We ask this to ensure that the dataset is available on the web, and that it can be linked to directly, as this helps reusers to access the data.'
    dependency :rule => '(A or B or C or D) and E'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_oneoff
    a_1 'Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dataset URL',
      :requirement => 'pilot_13'

    label 'You must provide either a URL for the dataset or a URL for documentation about it so that reusers can find it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_oneoff
    condition_F :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_G :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label 'You should have a URL that is a direct link to the data itself so that reusers can access it easily.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_oneoff
    condition_F :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_G :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'How do you publish the datasets in the series?',
      :pick => :any
    dependency :rule => '(A or B or C or D) and E'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    a_current 'the data at a single "current" dataset URL is regularly updated',
      :help_text => 'Having a single "current" dataset URL means that there is one URL from which reusers can always download the most recent version of the dataset.',
      :requirement => 'standard_16'
    a_template 'the URLs for each release follow a regular pattern',
      :help_text => 'Having URLs that follow a regular pattern means publishing datsets at URLs where the date of publication is part of the URL itself. For example, if you published a dataset each month then you would include the month (eg `2013-04`) as part of the URL. This helps reusers to understand when the dataset dates from, and helps them write scripts that collect together all the published datasets or fetch new ones each time they\'re released.',
      :requirement => 'pilot_14'
    a_list 'you publish a list of the releases',
      :help_text => 'Having a list of the releases means having a web page or a feed (such as Atom or RSS) that contains details of each release, including a link through to each individual release and a description of when it dates from. Reusers can use these lists to understand the frequency and regularity of your publication, and to help them write scripts that collect together all the published datasets or fetch new ones each time they\'re released.',
      :requirement => 'standard_17'

    label 'You should have a single URL that can always be used to download the current version of the dataset so that reusers can access it easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_current

    label 'You should use a regular pattern in the URLs for different releases so that reusers can easily get hold of each of those releases.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_template

    label 'You should have a document or feed that provides a list of all the available releases so that reusers can create scripts to download all of them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_list

    label 'You must provide access to releases of your data through a current URL, a discoverable series of URLs or through a documentation page so that reusers can locate it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => '(A or B or C or D) and E and (F and G and H and I)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_G :q_versionManagement, '!=', :a_current
    condition_H :q_versionManagement, '!=', :a_template
    condition_I :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'What\'s the URL of the current dataset?',
      :help_text => 'This should be the single URL that always gives the current version of the dataset itself (for example a CSV file). The content at this URL should change each time a new version is released. This should not be a page describing the dataset.'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '==', :a_current
    a_1 'Current Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dataset URL',
      :required => :required

    q_versionsTemplateUrl 'What\'s the URL template for the releases?',
      :help_text => 'This should be a template that outlines the structure of the URLs that are used when publishing different releases. Use `{<var>variable</var>}` within the URL template to indicate changeable parts of the URL. For example `http://example.com/data/monthly/mydata-{YY}{MM}.csv`'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '==', :a_template
    a_1 'Version Template URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version Template URL',
      :required => :required

    q_versionsUrl 'What\'s the URL that gives a list of releases?',
      :help_text => 'This should be the URL of a page or feed that provides a machine-readable list of the previous versions of the dataset. If the list goes over several pages, then give the URL of the first page and make sure there are links to other pages.'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '==', :a_list
    a_1 'Version List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version List URL',
      :required => :required

    q_endpointUrl 'What\'s the endpoint for the API?',
      :help_text => 'This should be a URL that provides a starting point for scripts that access the API. If the API supports it, this should be a service description document, which enables the script to work out the kinds of services that are offered by the API.'
    dependency :rule => '(A or B or C or D) and E'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    a_1 'Endpoint URL',
      :string,
      :input_type => :url,
      :placeholder => 'Endpoint URL',
      :requirement => 'standard_18'

    label 'You must provide either a URL for the API endpoint or a URL for the documentation about it so that reusers can find it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_G :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label 'You should have a service description document or similar single entry point for your API so that reusers can access it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_G :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'How do you publish the database dumps?',
      :pick => :any
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    a_current 'the data at a single "current" dump URL is regularly updated',
      :help_text => 'Having a single "current" dump URL means that there is one URL from which reusers can always download the most recently created dump.',
      :requirement => 'standard_19'
    a_template 'the URLs for each release follow a regular pattern',
      :help_text => 'Having URLs that follow a regular pattern means publishing dumps at URLs where the date of publication is part of the URL itself. For example, if you published a dump each month then you would include the month (eg `2013-04`) as part of the URL. This helps reusers to understand when the dump dates from, and helps them write scripts that collect together all the published dumps (to carry out comparisons, for example) or fetch new ones each time they\'re released.',
      :requirement => 'exemplar_10'
    a_list 'you publish a list of the releases',
      :help_text => 'Having a list of the dumps means having a web page or a feed (such as Atom or RSS) that contains details of each dump, including a link through to each individual release and a description of when it dates from. Reusers can use these lists to understand the frequency and regularity of your publication, and to help them write scripts that collect together all the published datasets or fetch new ones each time they\'re released.',
      :requirement => 'exemplar_11'

    label 'You should have a single URL that can always be used to download the current dump of the database so that reusers can find it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '!=', :a_current

    label 'You should use a regular pattern in the URLs for different dumps so that reusers can easily get hold of the dump for a particular time period.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '!=', :a_template

    label 'You should have a document or feed that provides a list of all the available dumps so that reusers can create scripts to download all of them.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'What\'s the URL of the current dump?',
      :help_text => 'This should be the URL that always gives the most recent dump of the database itself (for example as a CSV file). The content at this URL should change each time a new dump is created.'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '==', :a_current
    a_1 'Current Dump URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dump URL',
      :required => :required

    q_dumpsTemplateUrl 'What\'s the URL template for the dumps?',
      :help_text => 'This should be a template that outlines the structure of the URLs that are used when publishing different dumps. Use `{<var>variable</var>}` within the URL template to indicate changeable parts of the URL. For example `http://example.com/data/monthly/mydata-{YY}{MM}.csv`'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '==', :a_template
    a_1 'Dump Template URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump Template URL',
      :required => :required

    q_dumpsUrl 'What\'s the URL that gives a list of available dumps?',
      :help_text => 'Enter the URL of a page or feed that provides a machine-readable list of the available dumps of the database.'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '==', :a_list
    a_1 'Dump List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump List URL',
      :required => :required

    q_changeFeedUrl 'What\'s the URL that provides a feed of changes?',
      :help_text => 'This should be the URL of a page or feed that provides a machine-readable list of the previous versions of the dataset. If the list goes over several pages, then give the URL of the first page and make sure there are links to other pages.'
    dependency :rule => '(A or B or C or D) and E'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_changeFeed, '==', :a_true
    a_1 'Change Feed URL',
      :string,
      :input_type => :url,
      :placeholder => 'Change Feed URL',
      :required => :required

    label 'Formats',
      :help_text => 'helping reusers to work with the data',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Is the data machine-readable?',
      :help_text => 'A machine-readable format is one in which the information can be easily extracted from the data by a computer. For example, scanned photocopies of spreadsheets would not be machine-readable, but a CSV file would be.',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should provide the data in a machine-readable format so that it\'s easy to reuse.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A'

    q_openStandard 'Is the data in an open standard format?',
      :help_text => 'An open standard is one that is written through a defined fair, transparent and collaborative process and that anyone can implement. For example, XML, CSV and JSON are open standards.[Read more...](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf)',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should provide the data in an open standard format so that reusers can use common tools to process it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A'

    q_dataType 'What kind of data are you publishing?',
      :pick => :any
    a_documents 'human-readable documents',
      :help_text => 'Human-readable documents are those that are intended for human consumption. Examples would be policy documents, white papers, reports, meeting minutes and so on. These will usually have some structure to them, but the majority of the information within them is text.'
    a_statistical 'statistical data, such as counts, averages and percentages',
      :help_text => 'Statistical data includes numeric data such as counts, averages or percentages. Examples would be census results, traffic flow information or crime statistics.'
    a_geographic 'geographic information, such as points and boundaries',
      :help_text => 'Geographic information is any data that can be plotted on a map. These may be points or boundaries or lines.'
    a_structured 'other kinds of structured data',
      :help_text => 'Other kinds of structured data would include things like event details, railway timetables, contact information: anything that can be interpreted as data, analysed and presented in multiple ways.'

    q_documentFormat 'Do the formats used for documents include:',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'one that exposes the semantic structure of documents, such as HTML, Docbook or Markdown',
      :help_text => 'Documents are typically structured into chapters or sections, with headings and tables, lists and figures, terms and their definitions. Formats such as HTML, Docbook and Markdown that label these structures make it easy to automatically create summaries such as tables of contents and glossaries, and make it easy to apply different styling to the document to make it appear differently.',
      :requirement => 'standard_21'
    a_format 'one that focuses on the format of documents, such as OOXML or PDF',
      :help_text => 'Because documents are made for human consumption, they are typically created with great emphasis on how the document looks. Formats such as OOXML and PDF emphasise appearance: the use of particular fonts and colours and the positioning of different elements within the page. These are good for human consumption, but (despite being machine-readable) aren\'t as easy for machines to process or re-style.',
      :requirement => 'pilot_16'
    a_unsuitable 'only those not designed for documents, such as Excel, JSON or CSV',
      :help_text => 'Formats such as Excel or CSV are suited to tabular data. Formats such as JSON are suited for structured data. Because of the way they are structured, documents aren\'t suited to these formats.'

    label 'You should publish documents in a format that exposes their semantic structure so that it\'s easy to display in different styles.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label 'You should publish documents in a format that is designed for documents so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Do the formats used for statistical data include:',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'one that exposes the structure of the statistical hypercube data, such as SDMX or Data Cube',
      :help_text => 'Statistical data typically fits into a hypercube in which individual observations are related to a particular measure and a set of dimensions. Each observation may also be related to a number of annotations that provide additional context. Formats such as [SDMX](http://sdmx.org/) and [Data Cube](http://www.w3.org/TR/vocab-data-cube/) are designed to express this underlying structure of statistical data.',
      :requirement => 'exemplar_12'
    a_tabular 'one that treats the statistical data as a table, such as CSV',
      :help_text => 'Statistical data can be arranged within a table of rows and columns. This lacks the expressiveness about the underlying hypercube, but is easy to process.',
      :requirement => 'standard_22'
    a_format 'one that focuses on the format of tabular data, such as Excel',
      :help_text => 'Excel and other spreadsheet formats typically emphasise the appearance of data, using italic or bold text, or indentation within fields, or the width of lines between rows, to indicate its underlying structure. This styling helps humans to understand the meaning of the data, but is hard for computers to interpret, and thus makes the data less reusable than it might otherwise be.',
      :requirement => 'pilot_17'
    a_unsuitable 'only those not designed for statistical or tabular data, such as Word or PDF',
      :help_text => 'Formats that are oriented towards human-readable documents, such as Word or PDF, are not suitable for statistical data, as they completely obscure the underlying structure of the data.'

    label 'You should publish statistical data in a format that exposes its dimensions and measures so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label 'You should publish tabular data in a format that exposes the tables of data so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label 'You should publish tabular data in a format that is designed for tabular data so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Do the formats used for geographic data include:',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'one designed for geographic data, such as KML or GeoJSON',
      :help_text => 'Geographic data describes points, lines and boundaries. Formats that are designed for geographic data expose these kinds of structures in the data, which makes it easier to process automatically.',
      :requirement => 'standard_23'
    a_generic 'a generic structured data format, such as JSON, XML or CSV',
      :help_text => 'Geographic data can be expressed using any format that can be used for normal structured data, particularly if it only holds data about points.',
      :requirement => 'pilot_18'
    a_unsuitable 'only those not designed for geographic data, such as Word or PDF',
      :help_text => 'Formats that are oriented towards human-readable documents, such as Word or PDF, are not suitable for geographic data, as they completely obscure the underlying structure of the data.'

    label 'You should publish geographic data in a format designed for geographic data so that it\'s easy to use with existing tools.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label 'You should publish geographic data as structured data so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Do the formats used for structured data include:',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'one designed for structured data, such as JSON, XML, Turtle or CSV',
      :help_text => 'Structured data formats break down data into a basic structure of things which have values for a known set of properties. These predictable formats are easy for machines to process.',
      :requirement => 'pilot_19'
    a_unsuitable 'only those not designed for structured data, such as Word or PDF',
      :help_text => 'Formats that are oriented towards human-readable documents, such as Word or PDF, are not suitable for structured data, as they completely obscure its underlying structure.'

    label 'You should publish structured data in a format designed for structured data so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Are you using URLs to identify things in the data?',
      :help_text => 'Data is usually about things, often things in the real world such as schools and roads. Identifying these things using URLs provides a mechanism for people to find out more about the thing that is being described by the data. If data from different sources consistently uses the same URL to refer to the same thing, those different data sources can be combined easily, to create more useful data. URLs can usefully be used in place of identifying numbers or codes.',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should use URLs to identify things in the data, so that they can be easily referenced and combined with other data about those things.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A'

    q_resolvingUrls 'Do the URLs resolve to information about those things?',
      :help_text => 'A URL that resolves to information about something is one that, when put in a browser, provides you with additional data. For example there are resolvable URLs for [companies](http://opencorporates.com/companies/gb/08030289) and [postcodes](http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE). These provide human-readable pages but are also linked to underlying data which scripts can process.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You should provide a page of information about each of the things in your data so that reusers can easily find and share that information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingUrls, '==', :a_false

    q_existingExternalUrls 'Do external URLs exist for any of those things?',
      :help_text => 'These may be other websites, outside your control, that provide URLs for the things that you are naming through URLs within your data. For example, your data might include postcodes, when there are URLs for postcodes that are supported on the Ordnance Survey website.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Do those external URLs serve reliable data?',
      :help_text => 'Just because other websites support URLs for things (such as companies or postcodes), that doesn\'t necessarily make those sites reliable. However, often if a publisher has gone to the trouble of supporting URLs for things, they will have taken other steps to ensure the data quality and reliability. You can see, for example, if the data has an open data certificate. Whether you consider the website reliable is a judgement call.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Does the data use those external URLs?',
      :help_text => 'If there are URLs that resolve to reliable data for the things that you are describing in your data, you should reuse those URLs in your data. This reduces the duplication and enhances the ability for data from different sources to be brought together.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label 'You should use existing external URLs in your data so that it\'s easy to combine with other data that uses those URLs.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label 'Trust',
      :help_text => 'helping reusers to understand how much to trust the data',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Do you provide machine-readable provenance for the data?',
      :help_text => 'The provenance of data is a trace of how it was created and processed prior to publication. This can help establish trust in the data that you are publishing by enabling reusers to trace back how the data has been handled.[Read more...](http://www.w3.org/TR/prov-primer/)',
      :pick => :one
    a_false 'no'
    a_true 'yes'

    label 'You should provide a machine-readable provenance trail for the data so that reusers can trace how it has been processed.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A'

    q_digitalCertificate 'Where do you describe how reusers can verify the data they receive?',
      :help_text => 'If you are delivering important data, reusers should be able to verify that the data that they receive is the same as the data that you are publishing. For example, you might digitally sign the data that you publish, so that reusers can tell if it has been tampered with.'
    a_1 'Verification Process URL',
      :string,
      :input_type => :url,
      :placeholder => 'Verification Process URL',
      :requirement => 'exemplar_16'

    label 'You should describe how reusers can verify whether the data they receive is the same as that originally published by you, so that they know whether to trust it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A'

  end

  section 'Social Information' do

    label 'Documentation',
      :help_text => 'helping reusers to understand the context and content of the data',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'title',
      :requirement => 'pilot_20'
    a_description 'description',
      :requirement => 'pilot_21'
    a_issued 'release date',
      :requirement => 'pilot_22'
    a_modified 'modification date',
      :requirement => 'standard_25'
    a_accrualPeriodicity 'frequency of releases',
      :requirement => 'standard_26'
    a_identifier 'identifier',
      :requirement => 'standard_27'
    a_landingPage 'landing page',
      :requirement => 'standard_28'
    a_language 'language',
      :requirement => 'standard_29'
    a_publisher 'publisher',
      :requirement => 'standard_30'
    a_spatial 'spatial/geographical coverage',
      :requirement => 'standard_31'
    a_temporal 'temporal coverage',
      :requirement => 'standard_32'
    a_theme 'theme(s)',
      :requirement => 'standard_33'
    a_keyword 'keyword(s) or tag(s)',
      :requirement => 'standard_34'
    a_distribution 'distribution(s)'

    label 'You should include a title for the data in your documentation so that reusers know how to refer to it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label 'You should include a description of the data in your documentation so that reusers know what it contains.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label 'You should include a release date in your documentation so that reusers know how current it is.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label 'You should include the last modification date in your documentation so that reusers know whether the copy they have is up to date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label 'You should indicate in your documentation how frequently new versions of the data will be released so reusers can tell if it will be updated at all, and if so how frequently they will need to check it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label 'You should include a canonical URL for the data in your documentation so that different reusers know how to point to it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label 'You should include a canonical URL for the documentation itself in your documentation so that different reusers know how to point to it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label 'You should include the language of the data in your documentation so that reusers know whether they will be able to understand it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label 'You should indicate the publisher of the data in your documentation as reusers may use this information to determine how much to trust the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label 'You should include an indication of the geographic area the data covers in your documentation so that reusers understand what is included within it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label 'You should include the time period the data covers in your documentation so that reusers understand what is included within it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label 'You should include a general theme for the data in your documentation so that reusers know roughly what it\'s about.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label 'You should include keywords or tags for the data in your documentation to help reusers to search for the data effectively.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Does your documentation include machine-readable metadata for each distribution on:',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'title',
      :requirement => 'pilot_23'
    a_description 'description',
      :requirement => 'pilot_24'
    a_issued 'release date',
      :requirement => 'pilot_25'
    a_modified 'modification date',
      :requirement => 'standard_35'
    a_license 'licence',
      :requirement => 'standard_36'
    a_accessURL 'URL for accessing the data',
      :help_text => 'This metadata should be used when the distribution is not a download (eg if it\'s a pointer to an API)'
    a_downloadURL 'URL for downloading the dataset'
    a_byteSize 'size in bytes'
    a_mediaType 'media type of the download'

    label 'You should include a title for each distribution within the documentation so reusers know how to refer to it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label 'You should include a description of each distribution within the documentation so reusers know what it contains.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label 'You should include a release date for each distribution within the documentation so that reusers know how current it is.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_25'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label 'You should include the last modification date for each distribution within the documentation so reusers know whether their copy of it is up to date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label 'You should include a reference to the licence or waiver that applies to each distribution within the documentation so reusers know what they can do with the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_license

    q_serviceDocumentation 'Where is the documentation for the API?'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 '',
      :string,
      :input_type => :url,
      :requirement => 'pilot_26'

    label 'You should provide documentation about how the API works so that reusers can find out how to use it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Do the data formats use vocabularies?',
      :help_text => 'Formats such as JSON, XML or Turtle provide a generic syntax and need to be supplemented with a schema for developers to understand it.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Where is the documentation for the vocabularies?'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 '',
      :string,
      :input_type => :url,
      :requirement => 'standard_37'

    label 'You should provide documentation for any vocabulary you use within the data you publish so that reusers know how to interpret the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Are there any codes used within the data?',
      :help_text => 'Data often includes codes for things like geographical areas, spending categories or diseases; these codes need to be explained for reusers.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Where are the codes documented?'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 '',
      :string,
      :input_type => :url,
      :requirement => 'standard_38'

    label 'You should provide documentation for the codes used within your data so that reusers know how to interpret the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label 'Support',
      :help_text => 'giving reusers contact with people who can help them',
      :customer_renderer => '/partials/fieldset'

    q_contactEmail 'What\'s the contact email address for questions about this data?',
      :help_text => 'Provide an email address that people can contact with queries about the data.'
    a_1 'Contact Email Address',
      :string,
      :input_type => :email,
      :placeholder => 'Contact Email Address',
      :requirement => 'pilot_27'

    label 'You should have a contact email address so that people can get in touch with you about any questions about the data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_27'
    dependency :rule => 'A'

    q_forum 'Where do you recommend people discuss this dataset?',
      :help_text => 'Provide a URL for the forum or mailing list where developers using this dataset should discuss it.'
    a_1 'Forum or Mailing List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Forum or Mailing List URL',
      :requirement => 'standard_39'

    label 'You should indicate a place where people using this dataset should discuss the data so that they can support each other.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A'

    q_correctionReporting 'Where do you describe how to provide corrections?',
      :help_text => 'Provide a link to a page that describes how people should provide corrections if they discover errors in  the data.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Instructions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Instructions URL',
      :requirement => 'standard_40'

    label 'You should provide instructions for people who discover errors in the data so that they know how to report them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Where do you describe how to learn about corrections?',
      :help_text => 'Provide a link to a page that describes how corrections will be communicated to reusers of the data.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Notification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Notification URL',
      :requirement => 'standard_41'

    label 'You should provide an announcement mailing list or a feed to which reusers can subscribe to learn of corrections to the data so that they can keep their local copies up to date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionEmail 'What\'s the contact email address for confidentiality concerns?'
    dependency :rule => '(A or B)'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    a_1 'Confidentiality Contact Email Address',
      :string,
      :input_type => :email,
      :placeholder => 'Confidentiality Contact Email Address',
      :requirement => 'pilot_28'

    label 'You should provide a contact email address so that reusers with concerns about disclosure of personal details within the data can get in touch.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_28'
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_dataProtectionEmail, '==', {:string_value => '', :answer_reference => '1'}

    label 'Services',
      :help_text => 'providing reusers with tools to help work with the data',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Where do you list tools for working with the data?',
      :help_text => 'Provide a link to a page that lists the tools that people and developers can use when working with the data.'
    a_1 'Tool URL',
      :string,
      :input_type => :url,
      :placeholder => 'Tool URL',
      :requirement => 'exemplar_17'

    label 'You should provide a list of software libraries and other tools that help developers who want to work with the data so that reusers can find and reuse them rather than building them from scratch.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A'

  end

end

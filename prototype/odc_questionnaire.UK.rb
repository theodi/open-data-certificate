survey 'Open Data Certificate Questionnaire',
  :default_mandatory => 'false' do

  section_general 'General Information' do

    q_dataTitle 'What\'s this data called?',
      :help_text => 'People see the name of your open data in a list of similar ones so make this as unambiguous and descriptive as you can in this tiny box so they quickly identify what\'s unique about it.'
    a_1 'Data Title',
      :string,
      :placeholder => 'Data Title',
      :required => :required

    q_documentationUrl 'Where is it described?',
      :help_text => 'Give a URL for people to read about the contents of your open data and find more detail. It can be a page within a bigger catalog like data.gov.uk.'
    a_1 'Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation URL',
      :requirement => 'pilot_1'

    label_pilot_1 'You should have a **web page that offers documentation** about the open data you publish so that people can understand its context, content and utility.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'You must have a **web page that gives documentation** and access to the open data you publish so that people can use it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Who curates this data?',
      :help_text => 'Give the name of the organisation who looks after this data. It’s probably who you work for unless you’re doing this on behalf of someone else.'
    a_1 'Data Curator',
      :string,
      :placeholder => 'Data Curator',
      :required => :required

    q_publisherUrl 'Where is the curator\'s website?',
      :help_text => 'Give a URL to a website, this helps us to group data from the same organisation even if people give different names.'
    a_1 'Curator URL',
      :string,
      :input_type => :url,
      :placeholder => 'Curator URL'

    q_releaseType 'What kind of release is this?',
      :pick => :one,
      :required => :required
    a_oneoff 'a one-off release of a single dataset',
      :help_text => 'This is a single file and you don’t plan to publish similar files in the future.'
    a_collection 'a one-off release of a set of related datasets',
      :help_text => 'This is a collection of related files about the same data and you don’t plan to publish similar collections in the future.'
    a_series 'ongoing release of a series of related datasets',
      :help_text => 'This is a sequence of datasets with planned periodic updates in the future.'
    a_service 'a service or API for accessing open data',
      :help_text => 'This is a live web service that exposes your data to programmers through an interface they can query.'

  end

  section_legal 'Legal Information' do

    label_group_1 'Rights',
      :help_text => 'your right to share this data with people',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Do you have the rights to publish this data as open data?',
      :help_text => 'If your organisation didn\'t originally create or gather this data then you might not have the right to publish it. If you’re not sure, check with the data owner because you will need their permission to publish it.',
      :pick => :one,
      :required => :required
    a_yes 'yes, you have the rights to publish this data as open data'
    a_no 'no, you don\'t have the rights to publish this data as open data'
    a_unsure 'you\'re not sure if you have the rights to publish this data as open data'

    label_basic_2 'You must have the **right to publish your data**.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_publisherOrigin 'Was *all* this data originally created or gathered by you?',
      :help_text => 'If any part of this data was sourced outside your organisation by other individuals or organisations then you need to give extra information about your right to publish it.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no'
    a_true 'yes'

    q_thirdPartyOrigin 'Was some of this data extracted or calculated from other data?',
      :help_text => 'An extract or smaller part of someone else\'s data still means your rights to use it might be affected. There might also be legal issues if you analysed their data to produce new results from it.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes'

    label_basic_3 'You indicated that this data wasn\'t originally created or gathered by you, and wasn\'t crowdsourced, so it must have been extracted or calculated from other data sources.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Are *all* sources of this data already published as open data?',
      :help_text => 'You\'re allowed to republish someone else\'s data if it\'s already under an open data licence or if their rights have expired or been waived. If any part of your data is not like this then you\'ll need legal advice before you can publish it.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no'
    a_true 'yes'

    label_basic_4 'You should get **legal advice to make sure you have the right to publish this data**.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Was some of this data crowdsourced?',
      :help_text => 'If your data includes information contributed by people outside your organisation, you need their permission to publish their contributions as open data.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes'

    label_basic_5 'You indicated that the data wasn\'t originally created or gathered by you, and wasn\'t extracted or calculated from other data, so it must have been crowdsourced.',
      :custom_renderer => '/partials/requirement_basic'
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
      :help_text => 'Give a link to an agreement that shows contributors allow you to reuse their data. A CLA will either transfer contributor\'s rights to you, waive their rights, or license the data to you so you can publish it.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement'
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
    a_true 'yes'

    label_basic_6 'You must get **contributors to agree to a Contributor Licence Agreement** (CLA) that gives you the right to publish their work as open data.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Where do you describe sources of this data?',
      :help_text => 'Give a URL that documents where your data was sourced from (its provenance) and the rights under which you publish the data. Do this even if the data wasn\'t originally created or gathered by you and even though you have the rights to publish it.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Data Sources Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Data Sources Documentation URL',
      :requirement => 'pilot_2'

    label_pilot_2 'You should document **where your data came from and the rights under which you publish it**, so people are assured they can use parts which came from third parties.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Is documentation about the sources of this data also in machine-readable format?',
      :help_text => 'Information about data sources should be human-readable so people can understand it, as well as in a metadata format that computers can process. When everyone does this it helps other people find out how the same open data is being used and justify its ongoing publication.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_1'

    label_standard_1 'You should **include machine-readable data about the sources of your data**.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_2 'Licensing',
      :help_text => 'how you give people permission to use your data',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Where is your rights statement?',
      :help_text => 'Give a URL to a rights statement which shows who owns copyright and database rights to the data. This statement also says what you allow people to do with this data under licence. We share it with people who use your data and it helps them understand the terms under which you make it available.'
    a_1 'Rights statement URL',
      :string,
      :input_type => :url,
      :placeholder => 'Rights statement URL',
      :requirement => 'pilot_3'

    label_pilot_3 'You should have a **web page that states your copyright** and details of how people should give attribution to your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A'

    q_copyrightStatementMetadata 'Does your rights statement include machine-readable versions of',
      :help_text => 'It\'s good practice to embed information about licences in machine-readable formats so people can automatically attribute your data back to you when they use it.',
      :help_text_more_url => 'http://labs.creativecommons.org/2011/ccrel-guide/',
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

    label_standard_2 'You should provide **machine-readable data in your copyright statement about licences** which affect your data so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_license

    label_exemplar_1 'You should provide **machine-readable data in your copyright statement about attribution** of your data so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_exemplar_2 'You should provide **machine-readable data in your copyright statement about the URL of your data** that must be linked to, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    q_dataLicence 'Under which licence can others reuse this data?',
      :help_text => 'Remember that whoever originally gathers, creates, verifies or presents a database automatically gets rights over it. So people need a waiver or a licence which proves that they can use the data and explains how they can do that legally. We list the most common licenses here; if there are no database rights, they\'ve expired, or you\'ve waived them, choose \'Not applicable\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_odc_by 'Open Data Commons Attribution License'
    a_odc_by_sa 'Open Data Commons Open Database License (ODbL)'
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons CCZero'
    a_ogl 'UK Open Government Licence'
    a_na 'Not applicable'
    a_other 'Other...'

    q_dataNotApplicable 'Why does a licence not apply to this data?',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'there are no database rights in this data',
      :help_text => 'Database rights apply if you spent substantial effort gathering, verifying or presenting it. There are no database rights if, for example, the data is created from scratch, presented in an obvious way, and not checked against anything.'
    a_expired 'database rights have expired',
      :help_text => 'Database rights last ten years. If data was last changed over ten years ago then database rights have expired.'
    a_waived 'database rights have been waived',
      :help_text => 'This means no one owns the rights and anyone can do whatever they want with this data.'

    q_dataWaiver 'Which waiver do you use to waive database rights?',
      :help_text => 'You need a statement to show people you\'ve done this so that they understand they can do whatever they like with this data. Standard waivers already exist like PDDL and CCZero but you can write your own with legal advice.',
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
      :help_text => 'Give a URL to your own publicly available waiver so people can check that it does waive your database rights.'
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
      :help_text => 'If you use a different licence, we need the name so people can see it on your Open Data Certificate.'
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Other Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Other Licence Name'

    q_otherDataLicenceURL 'Where is your licence?',
      :help_text => 'Give a URL to the licence, so people can see it on your Open Data Certificate and check that it\'s publicly available.'
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Other Licence URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Other Licence URL'

    q_otherDataLicenceOpen 'Is the licence an open licence?',
      :help_text => 'If you aren\'t sure what an open licence is then read the [Open Knowledge Definition](http://opendefinition.org/) definition. Next, choose your licence from the [Open Definition Advisory Board open licence list](http://licenses.opendefinition.org/). If a licence isn\'t in their list, it\'s either not open or hasn\'t been assessed yet.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes'

    label_basic_7 'You must **publish open data under an open licence** so that people can use it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentLicence 'Under which licence can others reuse content?',
      :help_text => 'Remember that whoever spends intellectual effort creating content automatically gets rights over it but creative content does not include facts. So people need a waiver or a licence which proves that they can use the content and explains how they can do that legally. We list the most common licenses here; if there is no copyright in the content, it\'s expired, or you\'ve waived them, choose \'Not applicable\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc_by 'Creative Commons Attribution'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike'
    a_cc0 'Creative Commons CCZero'
    a_ogl 'UK Open Government Licence'
    a_na 'Not applicable'
    a_other 'Other...'

    q_contentNotApplicable 'Why doesn\'t a licence apply to this data?',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_na
    a_norights 'there is no copyright in this data',
      :help_text => 'Copyright only applies to data if you spent intellectual effort creating what\'s in it, for example, by writing text that\'s within the data, or deciding whether particular data is included. There\'s no copyright if the data only contains facts where no judgements were made about whether to include them or not.'
    a_expired 'copyright has expired',
      :help_text => 'Copyright lasts for a fixed amount of time, based on either the number of years after the death of its creator or its publication. You should check when the content was created or published because if that was a long time ago, copyright might have expired.'
    a_waived 'copyright has been waived',
      :help_text => 'This means no one owns copyright and anyone can do whatever they want with this data.'

    q_contentWaiver 'Which waiver do you use to waive copyright?',
      :help_text => 'You need a statement to show people you\'ve done this, so they understand that they can do whatever they like with this data. Standard waivers already exist like PDDL and CCZero but you can write your own with legal advice.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_na
    condition_B :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero'
    a_other 'Other...'

    q_contentOtherWaiver 'Where is the waiver for the copyright?',
      :help_text => 'Give a URL to your own publicly available waiver so people can check that it does waive your copyright.'
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
      :help_text => 'If you use a different licence, we need its name so people can see it on your Open Data Certificate.'
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Licence Name'

    q_otherContentLicenceURL 'Where is the licence?',
      :help_text => 'Give a URL to the licence, so people can see it on your Open Data Certificate and check that it\'s publicly available.'
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_1 'Licence URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Licence URL'

    q_otherContentLicenceOpen 'Is the licence an open licence?',
      :help_text => 'If you aren\'t sure what an open licence is then read the [Open Knowledge Definition](http://opendefinition.org/) definition. Next, choose your licence from the [Open Definition Advisory Board open licence list](http://licenses.opendefinition.org/). If a licence isn\'t in their list, it\'s either not open or hasn\'t been assessed yet.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes'

    label_basic_8 'You must **publish open data under an open licence** so that people can use it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => 'A and B'
    condition_A :q_contentLicence, '==', :a_other
    condition_B :q_otherContentLicenceOpen, '==', :a_false

    label_group_3 'Privacy',
      :help_text => 'how you protect people\'s privacy',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Can individuals be identified from this data?',
      :pick => :one,
      :required => :pilot
    a_not_personal 'no, the data is not about people or their activities',
      :help_text => 'Remember that individuals can still be identified even if data isn\'t directly about them. For example, road traffic flow data combined with an individual\'s commuting patterns could reveal information about that person.'
    a_summarised 'no, the data has been aggregated so individuals can\'t be identified',
      :help_text => 'Statistical analysis can aggregate data so that individuals are no longer be identifiable.'
    a_individual 'yes, there is a risk that individuals be identified, for example by third parties with access to extra information',
      :help_text => 'Some data is legitimately about individuals like civil service pay or public expenses for example.'

    q_statisticalAnonAudited 'Has your anonymisation process been independently audited?',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_3'

    label_standard_3 'You should **have your anonymisation process audited independently** to ensure it reduces the risk of individuals being reidentified.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Have you attempted to reduce or remove the possibility of individuals being identified?',
      :help_text => 'You can use anonymisation techniques to reduce or remove the possibility of individuals being identified from the data you publish. The technique you use depends on the kind of data that you have.',
      :help_text_more_url => 'http://www.ico.org.uk/news/latest_news/2012/~/media/documents/library/Data_Protection/Practical_application/anonymisation_code.ashx',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no'
    a_true 'yes'

    q_lawfulDisclosure 'Are you required by law to publish this personal data?',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => 'pilot_4'

    label_pilot_4 'You should **only publish personal data without anonymisation if you are required to do so by law**.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Where do you document your right to publish data about individuals?'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'Disclosure Rationale URL',
      :string,
      :input_type => :url,
      :placeholder => 'Disclosure Rationale URL',
      :requirement => 'standard_4'

    label_standard_4 'You should **document your right to publish data about individuals** for people who use your data and for those affected by disclosure.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_privacyImpactAssessmentExists 'Have you carried out a Privacy Impact Assessment?',
      :help_text => 'A [Privacy Impact Assessment](http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx) is how you measure risks to the privacy of individuals in your data as well as the use and disclosure of that information.',
      :help_text_more_url => 'http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => 'pilot_5'

    label_pilot_5 'You should **do a Privacy Impact Assessment** if you publish data about individuals.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_false

    q_privacyImpactAssessmentUrl 'Where is your Privacy Impact Assessment published?',
      :help_text => 'Give a URL to where people can check how you measure privacy risks to individuals. The ICO has recommendations about how to publish your Privacy Impact Assessment.',
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
      :requirement => 'standard_5'

    label_standard_5 'You should **publish your Privacy Impact Assessment** so people can understand how you have assessed the risks of disclosing data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_privacyImpactAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_piaAudited 'Has your Privacy Impact Assessment been independently audited?',
      :help_text => 'It\'s good practice to check your assessment was done correctly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_privacyImpactAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_6'

    label_standard_6 'You should **have your Privacy Impact Assessment audited independently** to ensure it has been carried out correctly.',
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
      :requirement => 'pilot_6'

    label_pilot_6 'You should **tell people what purposes the individuals in your data consented to you using their data for**. So that they use your data for the same purposes and comply with the Data Protection Act.',
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
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => 'pilot_7'

    label_pilot_7 'You should **consult with the member of staff in your organisation who is responsible for data protection** before publishing this data.',
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
      :help_text => 'It is good practice to make sure your process to remove personal identifiable data works properly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_7'

    label_standard_7 'You should **engage an expert to audit your anonymisation approach** to ensure that it is appropriate for your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_privacyImpactAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Practical Information' do

    label_group_5 'Findability',
      :help_text => 'how you help people find your data',
      :customer_renderer => '/partials/fieldset'

    q_linkedTo 'Can people find more information about your data within three clicks of your home page?',
      :help_text => 'If documentation is reachable via links from your home page people can find it quickly without searching. You should make it more accessible on your website if they can\'t.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_8'

    label_standard_8 'You should **ensure that people can easily find your data** from your organisation\'s home page.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A'

    q_listed 'Is your data listed within a collection?',
      :help_text => 'Data is easier for people to find when it\'s in relevant data catalogs like academic, public or health for example, or when it turns up in relevant search results.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_9'

    label_standard_9 'You should **ensure that people can find your data when they search for it** in locations that list data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A'

    repeater 'Listing' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Where is it listed?',
        :help_text => 'Give a URL where this data is listed within a relevant collection. For example, data.gov.uk (if it\'s UK public sector data), hub.data.ac.uk (if it\'s UK academia data) or a URL for search engine results.'
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Listing URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Listing URL'

    end

    q_referenced 'Is the data referenced from your own publications?',
      :help_text => 'You can provide context for understanding your data, and provide routes to help it be located, by referencing it within your own publications.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_10'

    label_standard_10 'You should **reference data from your own publications** so that people are aware of its availability and context.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A'

    repeater 'Reference' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Where is the data referenced?',
        :help_text => 'Give a URL for a document that cites or references this data.'
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'Reference URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Reference URL'

    end

    label_group_6 'Accuracy',
      :help_text => 'how you keep your data up-to-date',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Does the data behind your API change?',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'no, the API gives access to unchanging data',
      :help_text => 'Some APIs just make accessing an unchanging dataset easier, particularly when there\'s lots of it.'
    a_changing 'yes, the API gives access to changing data',
      :help_text => 'Some APIs give instant access to more up-to-date and ever-changing data'

    q_timeSensitive 'Will your data go out of date?',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'yes, this data will go out of date',
      :help_text => 'For example, a dataset of bus stop locations will go out of date over time as some are moved or new ones created.'
    a_timestamped 'yes, this data will go out of date over time but it’s time stamped',
      :help_text => 'For example, population statistics usually include a fixed timestamp to indicate when the statistics were relevant.',
      :requirement => 'pilot_8'
    a_false 'no, this data does not contain any time-sensitive information',
      :help_text => 'For example, the results of an experiment will not go out of date because the data accurately reports observed outcomes.',
      :requirement => 'standard_11'

    label_pilot_8 'You should **put timestamps in your data when you release it** so people know the period it relates to and when it will expire.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_11 'You should **publish updates to time-sensitive data** so that it does not go stale.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Does this data change at least daily?',
      :help_text => 'Tell people if the underlying data changes on most days. When data changes frequently it also goes out of date quickly, so people need to know if you also update it frequently and quickly too.',
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
    a_dumps 'regular copies of a complete database',
      :help_text => 'Choose if you publish new and updated copies of your full database regularly. When you create database dumps, it\'s useful for people to have access to a feed of the changes so they can keep their copies up to date.'
    a_aggregate 'regular aggregates of changing data',
      :help_text => 'Choose if you create new datasets regularly. You might do this if the underlying data can\'t be released as open data or if you only publish data that\'s new since the last publication.'

    q_changeFeed 'Is a feed of changes available?',
      :help_text => 'Tell people if you provide a stream of changes that affect this data, like new entries or amendments to existing entries. Feeds might be in RSS, Atom or custom formats.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no'
    a_true 'yes',
      :requirement => 'exemplar_3'

    label_exemplar_3 'You should **provide a feed of changes to your data** so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'How often do you create a new release?',
      :help_text => 'This determines how out of date this data becomes before people can get an update.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'less than once a month'
    a_monthly 'at least every month',
      :requirement => 'pilot_9'
    a_weekly 'at least every week',
      :requirement => 'standard_12'
    a_daily 'at least every day',
      :requirement => 'exemplar_4'

    label_pilot_9 'You should **create a new dataset release every month** so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_12 'You should **create a new dataset release every week** so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_4 'You should **create a new dataset release every day** so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'How long is the delay between when you create a dataset and when you publish it it?',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'longer than the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes more than a day for it to be published.'
    a_reasonable 'about the same as the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes about a day for it to be published.',
      :requirement => 'pilot_10'
    a_good 'less than half the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes less than twelve hours for it to be published.',
      :requirement => 'standard_13'
    a_minimal 'there is minimal or no delay',
      :help_text => 'Choose this if you publish within a few seconds or a few minutes.',
      :requirement => 'exemplar_5'

    label_pilot_10 'You should **have a reasonable delay between when you create and publish a dataset** that is less than the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_13 'You should **have a short delay between when you create and publish a dataset** that is less than half the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_5 'You should **have minimal or no delay between when you create and publish a dataset** so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Do you also publish dumps of this dataset?',
      :help_text => 'A dump is an extract of the whole dataset into a file that people can download. This lets people do analysis that\'s different to analysis with API access.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_14'

    label_standard_14 'You should **let people download your entire dataset** so that they can do more complete and accurate analysis with all the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'How frequently do you create a new database dump?',
      :help_text => 'Faster access to more frequent extracts of the whole dataset means people can get started quicker with the most up-to-date data.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'less frequently than once a month'
    a_monthly 'at least every month',
      :requirement => 'pilot_11'
    a_weekly 'within a week of any change',
      :requirement => 'standard_15'
    a_daily 'within a day of any change',
      :requirement => 'exemplar_6'

    label_pilot_11 'You should **create a new database dump every month** so that people have the latest data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_15 'You should **create a new database dump within a week of any change** so that people have less time to wait for the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_6 'You should **create a new database dump within a day of any change** so that people find it easier to get the latest data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Will your data be corrected if it has errors?',
      :help_text => 'It\'s good practice to fix errors in your data especially if you use it yourself. When you make corrections, people need to be told about them.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_16'

    label_standard_16 'You should **correct data when people report errors** so everyone benefits from improvements in accuracy.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_7 'Quality',
      :help_text => 'how people can report problems and improve your data',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Where do you document data quality issues?',
      :help_text => 'Give a URL where people can report problems. People accept that errors are inevitable, from equipment malfunctions or mistakes that happen in system migrations. You should be open about quality so people can judge how much to rely on this data.'
    a_1 'Quality Issues URL',
      :string,
      :input_type => :url,
      :placeholder => 'Quality Issues URL',
      :requirement => 'standard_17'

    label_standard_17 'You should **document any known issues with your data quality** so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A'

    q_qualityControlUrl 'Where is your quality control process described?',
      :help_text => 'Give a URL for people to learn about ongoing checks on your data, either automatic or manual. This reassures them that you take quality seriously and encourages improvements that benefit everyone.'
    a_1 'Quality Control Process Description URL',
      :string,
      :input_type => :url,
      :placeholder => 'Quality Control Process Description URL',
      :requirement => 'exemplar_7'

    label_exemplar_7 'You should **document your quality control process** so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A'

    label_group_8 'Guarantees',
      :help_text => 'how much people can depend on your data’s availability',
      :customer_renderer => '/partials/fieldset'

    q_serviceAvailability 'What is the guaranteed availability of your data?',
      :help_text => 'Most server hosting providers have a service-level agreement (SLA) between you and them. This should guarantee uptime for the servers and determine the availability of your data.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_minimal 'minimal or no formal guarantees about availability'
    a_atleast99 'at least 99% availability',
      :requirement => 'pilot_12'
    a_atleast99_9 'at least 99.9% availability',
      :requirement => 'standard_18'
    a_atleast99_999 'at least 99.999% availability',
      :requirement => 'exemplar_8'

    label_pilot_12 'You should **guarantee at least 99% service availability** (less than 4 days downtime/year) so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_atleast99
    condition_C :q_serviceAvailability, '!=', :a_atleast99_9
    condition_D :q_serviceAvailability, '!=', :a_atleast99_999

    label_standard_18 'You should **guarantee at least 99.9% service availability** (less than 9 hours downtime/year) so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_atleast99_9
    condition_C :q_serviceAvailability, '!=', :a_atleast99_999

    label_exemplar_8 'You should **guarantee at least 99.999% availability** (less than 5 minutes downtime/year) so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceAvailability, '!=', :a_atleast99_999

    q_onGoingAvailability 'How long will this data be available for?',
      :pick => :one
    a_experimental 'it might disappear at any time'
    a_short 'it\'s available experimentally but should be around for another year or so',
      :requirement => 'pilot_13'
    a_medium 'it\'s in your medium-term plans so should be around for a couple of years',
      :requirement => 'standard_19'
    a_long 'it\'s part of your day-to-day operations so will stay published for a long time',
      :requirement => 'exemplar_9'

    label_pilot_13 'You should **guarantee that your data will be available in this form for at least a year** so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_19 'You should **guarantee that your data will be available in this form in the medium-term** so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_9 'You should **guarantee that your data will be available in this form in the long-term** so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Technical Information' do

    label_group_10 'Locations',
      :help_text => 'how people can access your data',
      :customer_renderer => '/partials/fieldset'
    dependency :rule => '(A or B or C or D)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true

    q_datasetUrl 'Where is your dataset?',
      :help_text => 'Give a URL to the dataset itself. Open data should be linked to directly on the web so people can easily find and reuse it.'
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
      :requirement => 'pilot_14'

    label_basic_9 'You must **provide either a URL to your data or a URL to documentation** about it so that people can find it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_oneoff
    condition_F :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_G :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'You should **have a URL that is a direct link to the data itself** so that people can access it easily.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_oneoff
    condition_F :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_G :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'How do you publish a series of the same dataset?',
      :pick => :any
    dependency :rule => '(A or B or C or D) and E'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current dataset.',
      :requirement => 'standard_20'
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your dataset URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => 'pilot_15'
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of datasets on a web page or a feed (like Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => 'standard_21'

    label_standard_20 'You should **have a single persistent URL to download the current version of your data** so that people can access it easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_current

    label_pilot_15 'You should **use a consistent pattern for different release URLs** so that people can download each one automatically.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_template

    label_standard_21 'You should **have a document or feed with a list of available releases** so people can create scripts to download them all.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_series
    condition_F :q_versionManagement, '!=', :a_list

    label_basic_10 'You must **provide access to releases of your data through a URL** that gives the current version, a discoverable series of URLs or through a documentation page so that people can find it.',
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

    q_currentDatasetUrl 'Where is your current dataset?',
      :help_text => 'Give a single URL to the most recent version of the dataset. The content at this URL should change each time a new version is released.'
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

    q_versionsTemplateUrl 'What format do dataset release URLs follow?',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`'
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

    q_versionsUrl 'Where is your list of dataset releases?',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of datasets. Use the URL of the first page which should link to the rest of the pages.'
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

    q_endpointUrl 'Where is the endpoint for your API?',
      :help_text => 'Give a URL that\'s a starting point for people\'s scripts to access your API. This should be a service description document that helps the script to work out which services exist.'
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
      :requirement => 'standard_22'

    label_basic_11 'You must **provide either an API endpoint URL or a URL to its documentation** so that people can find it.',
      :custom_renderer => '/partials/requirement_basic'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_G :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_22 'You should **have a service description document or single entry point for your API** so that people can access it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_G :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'How do you publish database dumps?',
      :pick => :any
    dependency :rule => '(A or B or C or D) and E and F'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current database dump.',
      :requirement => 'standard_23'
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your database dump URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => 'exemplar_10'
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of database dumps on a web page or a feed (such as Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => 'exemplar_11'

    label_standard_23 'You should **have a single persistent URL to download the current dump of your database** so that people can find it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => '(A or B or C or D) and E and F and G'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_series
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_changeFeed, '==', :a_true
    condition_E :q_releaseType, '==', :a_service
    condition_F :q_provideDumps, '==', :a_true
    condition_G :q_dumpManagement, '!=', :a_current

    label_exemplar_10 'You should **use a consistent pattern for database dump URLs** so that people can can download each one automatically.',
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

    label_exemplar_11 'You should **have a document or feed with a list of available database dumps** so people can create scripts to download them all',
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

    q_currentDumpUrl 'Where is the current database dump?',
      :help_text => 'Give a URL to the most recent dump of the database. The content at this URL should change each time a new database dump is created.'
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

    q_dumpsTemplateUrl 'What format do database dump URLs follow?',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`'
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

    q_dumpsUrl 'Where is your list of available database dumps?',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of database dumps. Use the URL of the first page which should link to the rest of the pages.'
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

    q_changeFeedUrl 'Where is your feed of changes?',
      :help_text => 'Give a URL to a page or feed that provides a machine-readable list of the previous versions of the database dumps. Use the URL of the first page which should link to the rest of the pages.'
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

    label_group_11 'Formats',
      :help_text => 'how people can work with your data',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Is this data machine-readable?',
      :help_text => 'People prefer data formats which are easily processed by a computer, for speed and accuracy. For example, a scanned photocopy of a spreadsheet would not be machine-readable but a CSV file would be.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'pilot_16'

    label_pilot_16 'You should **provide your data in a machine-readable format** so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'

    q_openStandard 'Is this data in a standard open format?',
      :help_text => 'Open standards are created through a fair, transparent and collaborative process. Anyone can implement them and there’s lots of support so it’s easier for you to share data with more people. For example, XML, CSV and JSON are open standards.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_24'

    label_standard_24 'You should **provide your data in an open standard format** so that people can use widely available tools to process it more easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A'

    q_dataType 'What kind of data will you publish?',
      :pick => :any
    a_documents 'human-readable documents',
      :help_text => 'Choose this if your data is meant for human consumption. For example; policy documents, white papers, reports and meeting minutes. These usually have some structure to them but are mostly text.'
    a_statistical 'statistical data like counts, averages and percentages',
      :help_text => 'Choose this if your data is statistical or numeric data like counts, averages or percentages. Like census results, traffic flow information or crime statistics for example.'
    a_geographic 'geographic information, such as points and boundaries',
      :help_text => 'Choose this if your data can be plotted on a map as points, boundaries or lines.'
    a_structured 'other kinds of structured data',
      :help_text => 'Choose this if your data is structured in other ways. Like event details, railway timetables, contact information or anything that can be interpreted as data, and analysed and presented in multiple ways.'

    q_documentFormat 'Do your human-readable documents include formats that',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'describe semantic structure like HTML, Docbook or Markdown',
      :help_text => 'These formats label structures like chapters, headings and tables that make it easy to automatically create summaries like tables of contents and glossaries. They also make it easy to apply different styles to the document so its appearance changes.',
      :requirement => 'standard_25'
    a_format 'describe information on formatting like OOXML or PDF',
      :help_text => 'These formats emphasise appearance like fonts, colours and positioning of different elements within the page. These are good for human consumption, but aren\'t as easy for people to process automatically and change style.',
      :requirement => 'pilot_17'
    a_unsuitable 'aren\'t meant for documents like Excel, JSON or CSV',
      :help_text => 'These formats better suit tabular or structured data.'

    label_standard_25 'You should **publish documents in a format that exposes semantic structure** so that people can display them in different styles.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'You should **publish documents in a format designed specifically for them** so that they\'re easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Does your statistical data include formats that',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'expose the structure of statistical hypercube data like SDMX or Data Cube',
      :help_text => 'Individual observations in hypercubes relate to a particular measure and a set of dimensions. Each observation may also be related to annotations that give extra context. Formats like [SDMX](http://sdmx.org/) and [Data Cube](http://www.w3.org/TR/vocab-data-cube/) are designed to express this underlying structure.',
      :requirement => 'exemplar_12'
    a_tabular 'treat statistical data as a table like CSV',
      :help_text => 'These formats arrange statistical data within a table of rows and columns. This lacks extra context about the underlying hypercube but is easy to process.',
      :requirement => 'standard_26'
    a_format 'focus on the format of tabular data like Excel',
      :help_text => 'Spreadsheets use formatting like italic or bold text, and indentation within fields to describe its appearance and underlying structure. This styling helps people to understand the meaning of your data but makes it less suitable for computers to process.',
      :requirement => 'pilot_18'
    a_unsuitable 'aren\'t meant for statistical or tabular data like Word or PDF',
      :help_text => 'These formats don\'t suit statistical data because they obscure the underlying structure of the data.'

    label_exemplar_12 'You should **publish statistical data in a format that exposes dimensions and measures** so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_26 'You should **publish tabular data in a format that exposes tables of data** so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'You should **publish tabular data in a format designed for that purpose** so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Does your geographic data include formats that',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'are designed for geographic data like KML or GeoJSON',
      :help_text => 'These formats describe points, lines and boundaries, and expose structures in the data which make it easier to process automatically.',
      :requirement => 'standard_27'
    a_generic 'keeps data structured like JSON, XML or CSV',
      :help_text => 'Any format that stores normal structured data can express geographic data too, particularly if it only holds data about points.',
      :requirement => 'pilot_19'
    a_unsuitable 'aren\'t designed for geographic data like Word or PDF',
      :help_text => 'These formats don\'t suit geographic data because they obscure the underlying structure of the data.'

    label_standard_27 'You should **publish geographic data in a format designed that purpose** so that people can use widely available tools to process it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'You should **publish geographic data as structured data** so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Does your structured data include formats that',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'are designed for structured data like JSON, XML, Turtle or CSV',
      :help_text => 'These formats organise data into a basic structure of things which have values for a known set of properties. These formats are easy for computers to process automatically.',
      :requirement => 'pilot_20'
    a_unsuitable 'aren\'t designed for structured data like Word or PDF',
      :help_text => 'These formats don\'t suit this kind of data because they obscure its underlying structure.'

    label_pilot_20 'You should **publish structured data in a format designed that purpose** so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Does your data use persistent identifiers for things?',
      :help_text => 'Data is usually about real things like schools or roads. If data from different sources use the same persistent and unique identifier to refer to the same things, people can combine sources easily to create more useful data. Identifiers might be GUIDs, DOIs or URLs.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_28'

    label_standard_28 'You should **use identifiers for things in your data** so that they can be easily related with other data about those things.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A'

    q_resolvingIds 'Can the identifiers in your data be used to find extra information?',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no, the identifiers can\'t be used to find extra information'
    a_service 'yes, there is a service that people can use to resolve the identifiers',
      :help_text => 'Online services can be used to give people information about identifiers such as GUIDs or DOIs which can\'t be directly accessed in the way that URLs are.',
      :requirement => 'standard_29'
    a_resolvable 'yes, the identifiers are URLs that resolve to give information',
      :help_text => 'URLs are useful for both people and computers. People can put a URL into their browser and read more information, like [companies](http://opencorporates.com/companies/gb/08030289) and [postcodes](http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE). Computers can also process this extra information using scripts to access the underlying data.',
      :requirement => 'exemplar_13'

    label_standard_29 'You should **provide a service to resolve the identifiers you use** so that people can find extra information about them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_13 'You should **link to a web page of information about each of the things in your data** so that people can easily find and share that information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Where is the service that is used to resolve the identifiers?',
      :help_text => 'The resolution service should take an identifier as a query parameter and give back some information about the thing it identifies.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'Identifier Resolution Service URL',
      :string,
      :input_type => :url,
      :placeholder => 'Identifier Resolution Service URL',
      :requirement => 'standard_30'

    label_standard_30 'You should **have a URL through which identifiers can be resolved** so that more information about them can be found by a computer.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Does your data contain URLs to third-party information?',
      :help_text => 'Sometimes other people outside your control provide URLs to the things your data is about. For example, your data might have postcodes in it that link to the Ordnance Survey website.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Do third-party URLs in your data link to reliable information?',
      :help_text => 'If a third-party provides public URLs about things in your data, they probably take steps to ensure data quality and reliability. This is a measure of how much you trust their processes to do that. Look for their open data certificate or similar hallmarks to help make your decision.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Does your data use those third-party URLs?',
      :help_text => 'You should use third-party URLs that resolve to information about the things your data describes. This reduces duplication and helps people combine data from different sources to make it more useful.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => 'exemplar_14'

    label_exemplar_14 'You should **use URLs to third-party information in your data** so that it\'s easy to combine with other data that uses those URLs.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_12 'Trust',
      :help_text => 'how much trust people can put in your data',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Do you provide machine-readable provenance for your data?',
      :help_text => 'This about the origins of how your data was created and processed before it was published. It builds trust in the data you publish because people can trace back how it has been handled.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'exemplar_15'

    label_exemplar_15 'You should **provide a machine-readable provenance trail** about your data so that people can trace how it was processed.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A'

    q_digitalCertificate 'Where do you describe how people can verify data they receive from you?',
      :help_text => 'If you deliver important data to people they should be able to check that what they receive is the same as what you published. For example, you can digitally sign the data you publish, so people can tell if it has been tampered with.'
    a_1 'Verification Process URL',
      :string,
      :input_type => :url,
      :placeholder => 'Verification Process URL',
      :requirement => 'exemplar_16'

    label_exemplar_16 'You should **describe how people can check that the data they receive is the same as what you published** so that they can trust it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A'

  end

  section_social 'Social Information' do

    label_group_14 'Documentation',
      :help_text => 'how you help people understand the context and content of your data',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'title',
      :requirement => 'pilot_21'
    a_description 'description',
      :requirement => 'pilot_22'
    a_issued 'release date',
      :requirement => 'pilot_23'
    a_modified 'modification date',
      :requirement => 'standard_31'
    a_accrualPeriodicity 'frequency of releases',
      :requirement => 'standard_32'
    a_identifier 'identifier',
      :requirement => 'standard_33'
    a_landingPage 'landing page',
      :requirement => 'standard_34'
    a_language 'language',
      :requirement => 'standard_35'
    a_publisher 'publisher',
      :requirement => 'standard_36'
    a_spatial 'spatial/geographical coverage',
      :requirement => 'standard_37'
    a_temporal 'temporal coverage',
      :requirement => 'standard_38'
    a_theme 'theme(s)',
      :requirement => 'standard_39'
    a_keyword 'keyword(s) or tag(s)',
      :requirement => 'standard_40'
    a_distribution 'distribution(s)'

    label_pilot_21 'You should **include a data title in your documentation** so that people know how to refer to it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_pilot_22 'You should **include a data description in your documentation** so that people know what it contains.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_pilot_23 'You should **include a data release date in your documentation** so that people know how timely it is.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_31 'You should **include a last modification date in your documentation** so that people know they have the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_32 'You should **document how frequently you release new versions of your data** so people know how often you update it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_33 'You should **include a canonical URL for the data in your documentation** so that people know how to access it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_34 'You should **include a canonical URL to the documentation itself** so that people know how to access to it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_35 'You should **include the data language in your documentation** so that people who search for it will know whether they can understand it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_36 'You should **indicate the data publisher in your documentation** so people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_37 'You should **include the geographic area in your documentation** so that people understand where your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_38 'You should **include the time period in your documentation** so that people understand when your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_39 'You should **include the subject in your documentation** so that people know roughly what your data is about.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_40 'You should **include keywords or tags in your documentation** to help people search within the data effectively.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Does your documentation include machine-readable metadata for each distribution on:',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'title',
      :requirement => 'pilot_24'
    a_description 'description',
      :requirement => 'pilot_25'
    a_issued 'release date',
      :requirement => 'pilot_26'
    a_modified 'modification date',
      :requirement => 'standard_41'
    a_license 'licence',
      :requirement => 'standard_42'
    a_accessURL 'URL to access the data',
      :help_text => 'This metadata should be used when your data isn\'t available as a download, like an API for example.'
    a_downloadURL 'URL to download the dataset'
    a_byteSize 'size in bytes'
    a_mediaType 'type of download media'

    label_pilot_24 'You should **include titles within your documentation** so people know how to refer to each data distribution.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_pilot_25 'You should **include descriptions within your documentation** so people know what each data distribution contains.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_25'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_pilot_26 'You should **include release dates within your documentation** so people know how current each distribution is.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_26'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_41 'You should **include last modification dates within your documentation** so people know whether their copy of a data distribution is up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_42 'You should **document applicable licences or waivers** so people know what they can do with a data distribution.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_license

    q_serviceDocumentation 'Where is the documentation for the API?'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Service Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Service Documentation URL',
      :requirement => 'pilot_27'

    label_pilot_27 'You should **document how your API works** so that people understand how to use it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Do the data formats use vocabularies?',
      :help_text => 'Formats like JSON, XML or Turtle need to come with a schema for people to understand it.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Where is documentation about your data vocabularies?'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'Schema Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Schema Documentation URL',
      :requirement => 'standard_43'

    label_standard_43 'You should **document any vocabulary you use within your data** so that people know how to interpret it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Are there any codes used in this data?',
      :help_text => 'If your data uses codes to refer to things like geographical areas, spending categories or diseases for example, these need to be explained to people.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Where are any codes in your data documented?'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'Codelist Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Codelist Documentation URL',
      :requirement => 'standard_44'

    label_standard_44 'You should **document the codes used within your data** so that people know how to interpret them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_15 'Support',
      :help_text => 'how you communicate with people who use your data',
      :customer_renderer => '/partials/fieldset'

    q_contactEmail 'Who should people email with questions about this data?',
      :help_text => 'Give an email address that people can send questions about the data to.'
    a_1 'Contact Email Address',
      :string,
      :input_type => :email,
      :placeholder => 'Contact Email Address',
      :requirement => 'pilot_28'

    label_pilot_28 'You should **provide an email address for people to send questions** about your data to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_28'
    dependency :rule => 'A'

    q_improvementsContact 'Where can people find out how to improve the way your data is published?'
    a_1 'Improvement Suggestions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Improvement Suggestions URL',
      :requirement => 'pilot_29'

    label_pilot_29 'You should **provide instructions about how suggest improvements** to the way you publish data so you can discover what people need.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_29'
    dependency :rule => 'A'

    q_dataProtectionEmail 'Who should people email with questions about privacy?'
    a_1 'Confidentiality Contact Email Address',
      :string,
      :input_type => :email,
      :placeholder => 'Confidentiality Contact Email Address',
      :requirement => 'pilot_30'

    label_pilot_30 'You should **provide an email address for people to send questions about privacy to** and disclosure of personal details.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_30'
    dependency :rule => 'A'

    q_socialMedia 'Do you use social media to connect with people who use your data?',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => 'standard_45'

    label_standard_45 'You should **use social media to reach people who use your data** and discover how your data is being used',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A'

    repeater 'Account' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Which social media accounts can people reach you on?',
        :help_text => 'Give URLs to your social media accounts, like your Twitter or Facebook profile page.'
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'Social Media URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Social Media URL'

    end

    q_forum 'Where should people discuss this dataset?',
      :help_text => 'Give a URL to your forum or mailing list where people can talk about your data.'
    a_1 'Forum or Mailing List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Forum or Mailing List URL',
      :requirement => 'standard_46'

    label_standard_46 'You should **tell people where they can discuss your data** and support one another.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A'

    q_correctionReporting 'Where can people find out how to request corrections to your data?',
      :help_text => 'Give a URL where people can report errors they spot in your data.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Instructions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Instructions URL',
      :requirement => 'standard_47'

    label_standard_47 'You should **provide instructions about how people can report errors** in your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Where can people find out how to get notifications of corrections to your data?',
      :help_text => 'Give a URL where you describe how notifications about corrections are shared with people.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Notification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Notification URL',
      :requirement => 'standard_48'

    label_standard_48 'You should **provide a mailing list or feed with updates** that people can use to keep their copies of your data up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Where is your community engagement team\'s home page?'
    a_1 'Community Engagement Team Home Page URL',
      :string,
      :input_type => :url,
      :placeholder => 'Community Engagement Team Home Page URL',
      :requirement => 'exemplar_17'

    label_exemplar_17 'You should **build a community of people around your data** to encourage wider use of your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A'

    label_group_16 'Services',
      :help_text => 'how you give people access to tools they need to work with your data',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Where do you list tools to work with your data?',
      :help_text => 'Give a URL that lists the tools you know or recommend people can use when they work with your data.'
    a_1 'Tool URL',
      :string,
      :input_type => :url,
      :placeholder => 'Tool URL',
      :requirement => 'exemplar_18'

    label_exemplar_18 'You should **provide a list of software libraries and other readily-available tools** so that people can quickly get to work with your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A'

  end

end

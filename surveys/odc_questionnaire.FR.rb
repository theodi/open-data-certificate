survey 'FR',
  :full_title => 'France',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>Ce questionnaire d’auto­évaluation permet de générer un certificat et un badge open data, que vous pouvez publier pour donner des informations à propos de vos données ouvertes. Nous utilisons aussi vos réponses pour comprendre comment les organisations publient leurs données ouvertes.</p><p>Répondre à ces questions vous permet de montrer vos efforts pour vous conformer à la législation française. Nous vous recommandons de vous renseigner aussi sur les autres règles et lois qui s’appliquent à votre secteur d’activité, particulièrement si vous résidez en dehors de la France.</p><p><strong>Il n’est pas nécessaire de répondre à toutes les questions pour obtenir un certificat.</strong> Répondez seulement à celles vous concernant.</p>' do

  translations :en => :default
  section_general 'General Information',
    :description => '',
    :display_header => false do

    q_dataTitle 'Comment sont nommées vos données?',
      :help_text => 'Le nom de vos données apparaîtra dans une liste de données similaires, Remplissez donc ce champ en étant aussi précis et descriptif que possible, afin qu’il soit facile et rapide d’identifier les particularités de vos données.',
      :required => :required
    a_1 'Titre',
      :string,
      :placeholder => 'Titre',
      :required => :required

    q_documentationUrl 'Où sont­elles décrites?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is described at',
      :help_text => 'Indiquez une adresse internet à laquelle on peut trouver le contenu détaillé de vos données. Il est possible d’indiquer un site avec un plus gros catalogue tel que data.gov.uk.'
    a_1 'URL des documents',
      :string,
      :input_type => :url,
      :placeholder => 'URL des documents',
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

    q_publisher 'Qui publie ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is published by',
      :help_text => 'Indiquez le nom de l’organisation qui publie ces données. Il s’agit probablement de votre employeur, à moins que vous effectuiez ces démarches au nom de quelqu’un d’autre.',
      :required => :required
    a_1 'Editeur des données',
      :string,
      :placeholder => 'Editeur des données',
      :required => :required

    q_publisherUrl 'Sur quel site internet sont publiées ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'The data is published on',
      :help_text => 'Indiquez l’adresse internet du site de l’éditeur. Cela nous permet de grouper les données provenant de la même organisation, même si les noms donnés sont différents.'
    a_1 'Site de l’éditeur',
      :string,
      :input_type => :url,
      :placeholder => 'Site de l’éditeur'

    q_releaseType 'De quel genre de parution s’agit­il?',
      :pick => :one,
      :required => :required
    a_oneoff 'une parution exceptionnelle d’un unique jeu de données',
      :help_text => 'Il s’agit d’un seul fichier, et vous ne prévoyez pas actuellement de publier d’autres fichiers de ce type dans le futur.'
    a_collection 'une parution exceptionnelle de plusieurs jeux de données connexes',
      :help_text => 'Il s’agit d’un ensemble de fichiers concernant les mêmes données, et vous ne prévoyez pas actuellement de publier d’autres fichiers de ce type dans le futur.'
    a_series 'une parution en cours d’une série de jeux de données',
      :help_text => 'Il s’agit d’une série de jeux de données dont la publication est en cours et qui est mise à jour de manière périodique.'
    a_service 'un service ou une API permettant d’accéder à des données ouvertes',
      :help_text => 'Il s’agit d’un service web qui présente vos données aux programmeurs à travers une interface interactive.'

  end

  section_legal 'Informations Legales',
    :description => 'Droits, autorisations et confidentialité' do

    label_group_2 'Droits',
      :help_text => 'vos droits de partager ces données',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Disposez­vous des droits nécessaires pour publier ces données en tant que données ouvertes?',
      :help_text => 'Si vous organisation n’est pas à l’origine de la création ou de la récupération de ces données, il est possible que vous n’ayez pas le droit de les publier. Si vous n’êtes pas sûr, renseignez vous auprès du détenteur des données, car vous allez avoir besoin de sa permission pour les publier.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'oui, vous avez les droits nécessaires pour publier ces données en tant que données ouvertes',
      :requirement => ['standard_1']
    a_no 'non, vous n’avez pas les droits nécessaires pour publier ces données en tant que données ouvertes'
    a_unsure 'vous n’êtes pas sûr d’avoir les droits nécessaires pour publier ces données en tant que données ouvertes'
    a_complicated 'the rights in this data are complicated or unclear'

    label_standard_1 'You should have a <strong>clear legal right to publish this data</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'You must have the <strong>right to publish this data</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Where do you detail the risks people might encounter if they use this data?',
      :display_on_certificate => true,
      :text_as_statement => 'Risks in using this data are described at',
      :help_text => 'It can be risky for people to use data without a clear legal right to do so. For example, the data might be taken down in response to a legal challenge. Give a URL for a page that describes the risk of using this data.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'Risk Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Risk Documentation URL',
      :requirement => ['pilot_2']

    label_pilot_2 'You should document <strong>risks associated with using this data</strong>, so people can work out how they want to use it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

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
      :help_text => 'You\'re allowed to republish someone else\'s data if it\'s already under an open data licence or if their rights have expired or been waived. If any part of this data is not like this then you\'ll need legal advice before you can publish it.',
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
      :help_text => 'If the data includes information contributed by people outside your organisation, you need their permission to publish their contributions as open data.',
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

    q_crowdsourcedContent 'Did contributors to this data use their judgement?',
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
      :help_text => 'Give a URL that documents where the data was sourced from (its provenance) and the rights under which you publish the data. This helps people understand where the data comes from.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Data Sources Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Data Sources Documentation URL',
      :requirement => ['pilot_3']

    label_pilot_3 'You should document <strong>where the data came from and the rights under which you publish it</strong>, so people are assured they can use parts which came from third parties.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
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
      :requirement => ['standard_2']

    label_standard_2 'You should <strong>include machine-readable data about the sources of this data</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Autorisations',
      :help_text => 'la manière dont vous accordez aux gens la permission d’utiliser vos données',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Where have you published the rights statement for this dataset?',
      :display_on_certificate => true,
      :text_as_statement => 'The rights statement is at',
      :help_text => 'Give the URL to a page that describes the right to re-use this dataset. This should include a reference to its license, attribution requirements, and a statement about relevant copyright and database rights. A rights statement helps people understand what they can and can\'t do with the data.'
    a_1 'Rights Statement URL',
      :string,
      :input_type => :url,
      :placeholder => 'Rights Statement URL',
      :requirement => ['pilot_4']

    label_pilot_4 'You should <strong>publish a rights statement</strong> that details copyright, database rights, licensing and how people should give attribution to the data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Under which licence can people reuse this data?',
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
    a_na 'Not applicable',
      :text_as_statement => ''
    a_other 'Other...',
      :text_as_statement => ''

    q_dataNotApplicable 'Why doesn\'t a licence apply to this data?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is not licensed because',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'there are no copyright or database rights in this data',
      :text_as_statement => 'there are no rights in it',
      :help_text => 'Database rights apply if you spent substantial effort gathering, verifying or presenting it. There are no database rights if, for example, the data is created from scratch, presented in an obvious way, and not checked against anything. You have copyright if you select the items in the data or organise them in a non-obvious way.'
    a_expired 'copyright and database rights have expired',
      :text_as_statement => 'the rights have expired',
      :help_text => 'Database rights last ten years. If data was last changed over ten years ago then database rights have expired. Copyright lasts for a fixed amount of time, based on either the number of years after the death of its creator or its publication. Copyright is unlikely to have expired.'
    a_waived 'copyright and database rights have been waived',
      :text_as_statement => '',
      :help_text => 'This means no one owns the rights and anyone can do whatever they want with this data.'

    q_dataWaiver 'Which waiver do you use to waive rights in the data?',
      :display_on_certificate => true,
      :text_as_statement => 'Rights in the data have been waived with',
      :help_text => 'You need a statement to show people the rights have been waived so that they understand they can do whatever they like with this data. Standard waivers already exist like PDDL and CCZero but you can write your own with legal advice.',
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

    q_dataOtherWaiver 'Where is the waiver for the rights in the data?',
      :display_on_certificate => true,
      :text_as_statement => 'Rights in the data have been waived with',
      :help_text => 'Give a URL to the publicly available waiver so people can check that it does waive the rights in the data.',
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

    q_otherDataLicenceName 'What is the name of the licence?',
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

    q_otherDataLicenceURL 'Where is the licence?',
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

    q_contentRights 'Is there any copyright in the content of this data?',
      :display_on_certificate => true,
      :text_as_statement => 'There are',
      :pick => :one,
      :required => :required
    a_norights 'no, the data only contains facts and numbers',
      :text_as_statement => 'no rights in the content of the data',
      :help_text => 'There is no copyright in factual information. If the data does not contain any content that was created through intellectual effort, there are no rights in the content.'
    a_samerights 'yes, and the rights are all held by the same person or organisation',
      :text_as_statement => '',
      :help_text => 'Choose this option if the content in the data was all created by or transferred to the same person or organisation.'
    a_mixedrights 'yes, and the rights are held by different people or organisations',
      :text_as_statement => '',
      :help_text => 'In some data, the rights in different records are held by different people or organisations. Information about rights needs to be kept in the data too.'

    q_explicitWaiver 'Is the content of the data marked as public domain?',
      :display_on_certificate => true,
      :text_as_statement => 'The content has been',
      :help_text => 'Content can be marked as public domain using the <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark</a>. This helps people know that it can be freely reused.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'marked as public domain',
      :requirement => ['standard_3']

    label_standard_3 'You should <strong>mark public domain content as public domain</strong> so that people know they can reuse it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Under which licence can others reuse content?',
      :display_on_certificate => true,
      :text_as_statement => 'The content is available under',
      :help_text => 'Remember that whoever spends intellectual effort creating content automatically gets rights over it but creative content does not include facts. So people need a waiver or a licence which proves that they can use the content and explains how they can do that legally. We list the most common licenses here; if there is no copyright in the content, it\'s expired, or you\'ve waived them, choose \'Not applicable\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Creative Commons Attribution',
      :text_as_statement => 'Creative Commons Attribution'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike',
      :text_as_statement => 'Creative Commons Attribution Share-Alike'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_na 'Not applicable',
      :text_as_statement => ''
    a_other 'Other...',
      :text_as_statement => ''

    q_contentNotApplicable 'Why doesn\'t a licence apply to the content of the data?',
      :display_on_certificate => true,
      :text_as_statement => 'The content in this data is not licensed because',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'there is no copyright in the content of this data',
      :text_as_statement => 'there is no copyright',
      :help_text => 'Copyright only applies to content if you spent intellectual effort creating it, for example, by writing text that\'s within the data. There\'s no copyright if the content only contains facts.'
    a_expired 'copyright has expired',
      :text_as_statement => 'copyright has expired',
      :help_text => 'Copyright lasts for a fixed amount of time, based on either the number of years after the death of its creator or its publication. You should check when the content was created or published because if that was a long time ago, copyright might have expired.'
    a_waived 'copyright has been waived',
      :text_as_statement => '',
      :help_text => 'This means no one owns copyright and anyone can do whatever they want with this data.'

    q_contentWaiver 'Which waiver do you use to waive copyright?',
      :display_on_certificate => true,
      :text_as_statement => 'Copyright has been waived with',
      :help_text => 'You need a statement to show people you\'ve done this, so they understand that they can do whatever they like with this data. Standard waivers already exist like CCZero but you can write your own with legal advice.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Other...',
      :text_as_statement => 'Other...'

    q_contentOtherWaiver 'Where is the waiver for the copyright?',
      :display_on_certificate => true,
      :text_as_statement => 'Copyright has been waived with',
      :help_text => 'Give a URL to your own publicly available waiver so people can check that it does waive your copyright.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
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
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Licence Name',
      :string,
      :required => :required,
      :placeholder => 'Licence Name'

    q_otherContentLicenceURL 'Where is the licence?',
      :display_on_certificate => true,
      :text_as_statement => 'The content licence is at',
      :help_text => 'Give a URL to the licence, so people can see it on your Open Data Certificate and check that it\'s publicly available.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
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
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 'You must <strong>publish open data under an open licence</strong> so that people can use it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Where are the rights and licensing of the content explained?',
      :display_on_certificate => true,
      :text_as_statement => 'The rights and licensing of the content are explained at',
      :help_text => 'Give the URL for a page where you describe how someone can find out the rights and licensing of a piece of content from the data.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'Content Rights Description URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Content Rights Description URL'

    q_copyrightStatementMetadata 'Does your rights statement include machine-readable versions of',
      :display_on_certificate => true,
      :text_as_statement => 'The rights statement includes data about',
      :help_text => 'It\'s good practice to embed information about rights in machine-readable formats so people can automatically attribute this data back to you when they use it.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'data licence',
      :text_as_statement => 'its data licence',
      :requirement => ['standard_4']
    a_contentLicense 'content licence',
      :text_as_statement => 'its content licence',
      :requirement => ['standard_5']
    a_attribution 'attribution text',
      :text_as_statement => 'what attribution text to use',
      :requirement => ['standard_6']
    a_attributionURL 'attribution URL',
      :text_as_statement => 'what attribution link to give',
      :requirement => ['standard_7']
    a_copyrightNotice 'copyright notice or statement',
      :text_as_statement => 'a copyright notice or statement',
      :requirement => ['exemplar_1']
    a_copyrightYear 'copyright year',
      :text_as_statement => 'the copyright year',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'copyright holder',
      :text_as_statement => 'the copyright holder',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'database right year',
      :text_as_statement => 'the database right year',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'database right holder',
      :text_as_statement => 'the database right holder',
      :requirement => ['exemplar_5']

    label_standard_4 'You should provide <strong>machine-readable data in your rights statement about the licence</strong> for this data, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'You should provide <strong>machine-readable data in your rights statement about the licence for the content</strong> of this data, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'You should provide <strong>machine-readable data in your rights statement about the text to use when citing the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'You should provide <strong>machine-readable data in your rights statement about the URL to link to when citing this data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'You should provide <strong>machine-readable data in your rights statement about the copyright statement or notice of this data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'You should provide <strong>machine-readable data in your rights statement about the copyright year for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'You should provide <strong>machine-readable data in your rights statement about the copyright holder for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'You should provide <strong>machine-readable data in your rights statement about the database right year for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'You should provide <strong>machine-readable data in your rights statement about the database right holder for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Confidentialite',
      :help_text => 'la manière dont vous protégez la vie privée des gens',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Ces données permettent­elles d’identifier des individus?',
      :display_on_certificate => true,
      :text_as_statement => 'This data contains',
      :pick => :one,
      :required => :pilot
    a_not_personal 'non, ces données ne concernent pas des individus ou leurs activités',
      :text_as_statement => 'no data about individuals',
      :help_text => 'Rappelez­vous que des individus peuvent être identifiés même si les données ne les concernent pas directement. Par exemple, des données concernant le trafic routier combinées avec des données concernant les trajets quotidiens d’une personne pourraient révéler des informations sur cette personne.'
    a_summarised 'no, the data has been anonymised by aggregating individuals into groups, so they can\'t be distinguished from other people in the group',
      :text_as_statement => 'aggregated data',
      :help_text => 'Statistical disclosure controls can help to make sure that individuals are not identifiable within aggregate data.'
    a_individual 'oui, il existe un risque que des individus soient identifiés, par exemple par un tiers disposant d’un accès à d’autres informations',
      :text_as_statement => 'information that could identify individuals',
      :help_text => 'Certaines données concernent les individus de manière légitime, comme par exemple les salaires dans la fonction publique ou les dépenses publiques.'

    q_statisticalAnonAudited 'Votre processus d’anonymisation a­t­il été contrôlé par un organisme indépendant?',
      :display_on_certificate => true,
      :text_as_statement => 'The anonymisation process has been',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_8']

    label_standard_8 'You should <strong>have your anonymisation process audited independently</strong> to ensure it reduces the risk of individuals being reidentified.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Avez­vous tenté de réduire ou de supprimer la possibilité que des individus soient identifiés?',
      :display_on_certificate => true,
      :text_as_statement => 'This data about individuals has been',
      :help_text => 'L’anonymisation permet de réduire le risque que des individus soient identifiés à partir des données que vous publiez. Le choix de la meilleure technique à utiliser dépend du type de vos données.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'anonymised'

    q_lawfulDisclosure 'Etes vous autorisés ou forcés par la loi à publier ces données concernant des individus?',
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
      :requirement => ['pilot_5']

    label_pilot_5 'You should <strong>only publish personal data without anonymisation if you are required or permitted to do so by law</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Où peut­on trouver des informations sur votre droit de publication d’informations personnelles?',
      :display_on_certificate => true,
      :text_as_statement => 'The right to publish this data about individuals is documented at'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL de la déclaration',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la déclaration',
      :requirement => ['standard_9']

    label_standard_9 'You should <strong>document your right to publish data about individuals</strong> for people who use your data and for those affected by disclosure.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Have you assessed the risks of disclosing personal data?',
      :display_on_certificate => true,
      :text_as_statement => 'The curator has',
      :help_text => 'A risk assessment measures risks to the privacy of individuals in your data as well as the use and disclosure of that information.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'not carried out a privacy risk assessment'
    a_true 'yes',
      :text_as_statement => 'carried out a privacy risk assessment',
      :requirement => ['pilot_6']

    label_pilot_6 'You should <strong>assess the risks of disclosing personal data</strong> if you publish data about individuals.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Where is your risk assessment published?',
      :display_on_certificate => true,
      :text_as_statement => 'The risk assessment is published at',
      :help_text => 'Give a URL to where people can check how you have assessed the privacy risks to individuals. This may be redacted or summarised if it contains sensitive information.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'Risk Assessment URL',
      :string,
      :input_type => :url,
      :placeholder => 'Risk Assessment URL',
      :requirement => ['standard_10']

    label_standard_10 'You should <strong>publish your privacy risk assessment</strong> so people can understand how you have assessed the risks of disclosing data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Has your risk assessment been independently audited?',
      :display_on_certificate => true,
      :text_as_statement => 'The risk assessment has been',
      :help_text => 'It\'s good practice to check your risk assessment was done correctly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_11']

    label_standard_11 'You should <strong>have your risk assessment audited independently</strong> to ensure it has been carried out correctly.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Where is the privacy notice for individuals affected by your data?',
      :display_on_certificate => true,
      :text_as_statement => 'Individuals affected by this data have this privacy notice',
      :help_text => 'When you collect data about individuals you must tell them how that data will be used. People who use your data need this to make sure they comply with data protection legislation.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'Privacy Notice URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Notice URL',
      :requirement => ['pilot_7']

    label_pilot_7 'You should <strong>tell people what purposes the individuals in your data consented to you using their data for</strong> so that they use your data for the same purposes and comply with data protection legislation.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Existe­t­il au sein de votre organisation une personne responsable de la protection des données?',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_dbStaffConsulted 'Avez­vous impliqué cette personne dans le processus de mise en place de la Déclaration d’Impact de Confidentialité?',
      :display_on_certificate => true,
      :text_as_statement => 'The individual responsible for data protection',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'has been consulted',
      :requirement => ['pilot_8']

    label_pilot_8 'You should <strong>involve the person responsible for data protection</strong> in your organisation before you publish this data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
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
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_12']

    label_standard_12 'You should <strong>have your anonymisation process audited independently</strong> by an expert to ensure it is appropriate for your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Informations Pratiques',
    :description => 'Accessibilité, précision, qualité et garanties' do

    label_group_6 'Accessibilité',
      :help_text => 'la manière dont les gens peuvent trouver vos données',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Is there a link to your data from your main website?',
      :help_text => 'Data can be found more easily if it is linked to from your main website.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 'You should <strong>ensure that people can find the data from your main website</strong> so that people can find it more easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Web Page' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Which page on your website links to the data?',
        :display_on_certificate => true,
        :text_as_statement => 'The website links to the data from',
        :help_text => 'Give a URL on your main website that includes a link to this data.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'Web page URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Web page URL'

    end

    q_listed 'Est­ce que vos données sont listées dans une catégorie?',
      :help_text => 'Il est plus simple de trouver vos données lorsqu’elles sont listées dans des catégories pertinentes (par exemple académique, public ou santé), ou lorsqu’elles apparaissent dans des résultats de recherches pertinents.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 'You should <strong>ensure that people can find your data when they search for it</strong> in locations that list data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listing' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Where is it listed?',
        :display_on_certificate => true,
        :text_as_statement => 'The data appears in this collection',
        :help_text => 'Give a URL where this data is listed within a relevant collection. For example, data.gov.uk (if it\'s UK public sector data), hub.data.ac.uk (if it\'s UK academia data) or a URL for search engine results.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Listing URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Listing URL'

    end

    q_referenced 'Est­ce que ces données sont référencées dans vos propres publications?',
      :help_text => 'Lorsque vous référencez vos données dans vos propres publications, telles que des rapports, des présentations ou des billets de blog, vous les inscrivez dans un contexte et aidez les gens à les trouver et à les comprendre plus facilement.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_15']

    label_standard_15 'You should <strong>reference data from your own publications</strong> so that people are aware of its availability and context.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Reference' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Where is your data referenced?',
        :display_on_certificate => true,
        :text_as_statement => 'This data is referenced from',
        :help_text => 'Give a URL to a document that cites or references this data.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'Reference URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Reference URL'

    end

    label_group_7 'Précision',
      :help_text => 'la manière dont vous gardez vos données à jour',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Does the data behind your API change?',
      :display_on_certificate => true,
      :text_as_statement => 'The data behind the API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'no, the API gives access to unchanging data',
      :text_as_statement => 'will not change',
      :help_text => 'Some APIs just make accessing an unchanging dataset easier, particularly when there\'s lots of it.'
    a_changing 'yes, the API gives access to changing data',
      :text_as_statement => 'will change',
      :help_text => 'Some APIs give instant access to more up-to-date and ever-changing data'

    q_timeSensitive 'Will your data go out of date?',
      :display_on_certificate => true,
      :text_as_statement => 'The accuracy or relevance of this data will',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'yes, this data will go out of date',
      :text_as_statement => 'go out of date',
      :help_text => 'For example, a dataset of bus stop locations will go out of date over time as some are moved or new ones created.'
    a_timestamped 'yes, this data will go out of date over time but it’s time stamped',
      :text_as_statement => 'go out of date but it is timestamped',
      :help_text => 'For example, population statistics usually include a fixed timestamp to indicate when the statistics were relevant.',
      :requirement => ['pilot_9']
    a_false 'no, this data does not contain any time-sensitive information',
      :text_as_statement => 'not go out of date',
      :help_text => 'For example, the results of an experiment will not go out of date because the data accurately reports observed outcomes.',
      :requirement => ['standard_16']

    label_pilot_9 'You should <strong>put timestamps in your data when you release it</strong> so people know the period it relates to and when it will expire.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'You should <strong>publish updates to time-sensitive data</strong> so that it does not go stale.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Does this data change at least daily?',
      :display_on_certificate => true,
      :text_as_statement => 'This data changes',
      :help_text => 'Tell people if the underlying data changes on most days. When data changes frequently it also goes out of date quickly, so people need to know if you also update it frequently and quickly too.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'at least daily'

    q_seriesType 'What type of dataset series is this?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is a series of',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'regular copies of a complete database',
      :text_as_statement => 'copies of a database',
      :help_text => 'Choose if you publish new and updated copies of your full database regularly. When you create database dumps, it\'s useful for people to have access to a feed of the changes so they can keep their copies up to date.'
    a_aggregate 'regular aggregates of changing data',
      :text_as_statement => 'aggregates of changing data',
      :help_text => 'Choose if you create new datasets regularly. You might do this if the underlying data can\'t be released as open data or if you only publish data that\'s new since the last publication.'

    q_changeFeed 'Is a feed of changes available?',
      :display_on_certificate => true,
      :text_as_statement => 'A feed of changes to this data',
      :help_text => 'Tell people if you provide a stream of changes that affect this data, like new entries or amendments to existing entries. Feeds might be in RSS, Atom or custom formats.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'is available',
      :requirement => ['exemplar_6']

    label_exemplar_6 'You should <strong>provide a feed of changes to your data</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'How often do you create a new release?',
      :display_on_certificate => true,
      :text_as_statement => 'New releases of this data are made',
      :help_text => 'This determines how out of date this data becomes before people can get an update.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'less than once a month',
      :text_as_statement => 'less than once a month'
    a_monthly 'at least every month',
      :text_as_statement => 'at least every month',
      :requirement => ['pilot_10']
    a_weekly 'at least every week',
      :text_as_statement => 'at least every week',
      :requirement => ['standard_17']
    a_daily 'at least every day',
      :text_as_statement => 'at least every day',
      :requirement => ['exemplar_7']

    label_pilot_10 'You should <strong>create a new dataset release every month</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'You should <strong>create a new dataset release every week</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'You should <strong>create a new dataset release every day</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'How long is the delay between when you create a dataset and when you publish it it?',
      :display_on_certificate => true,
      :text_as_statement => 'The lag between creation and publication of this data is',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'longer than the gap between releases',
      :text_as_statement => 'longer than the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes more than a day for it to be published.'
    a_reasonable 'about the same as the gap between releases',
      :text_as_statement => 'about the same as the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes about a day for it to be published.',
      :requirement => ['pilot_11']
    a_good 'less than half the gap between releases',
      :text_as_statement => 'less than half the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes less than twelve hours for it to be published.',
      :requirement => ['standard_18']
    a_minimal 'there is minimal or no delay',
      :text_as_statement => 'minimal',
      :help_text => 'Choose this if you publish within a few seconds or a few minutes.',
      :requirement => ['exemplar_8']

    label_pilot_11 'You should <strong>have a reasonable delay between when you create and publish a dataset</strong> that is less than the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'You should <strong>have a short delay between when you create and publish a dataset</strong> that is less than half the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'You should <strong>have minimal or no delay between when you create and publish a dataset</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Do you also publish dumps of this dataset?',
      :display_on_certificate => true,
      :text_as_statement => 'The curator publishes',
      :help_text => 'A dump is an extract of the whole dataset into a file that people can download. This lets people do analysis that\'s different to analysis with API access.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'dumps of the data',
      :requirement => ['standard_19']

    label_standard_19 'You should <strong>let people download your entire dataset</strong> so that they can do more complete and accurate analysis with all the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'How frequently do you create a new database dump?',
      :display_on_certificate => true,
      :text_as_statement => 'Database dumps are created',
      :help_text => 'Faster access to more frequent extracts of the whole dataset means people can get started quicker with the most up-to-date data.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'less frequently than once a month',
      :text_as_statement => 'less frequently than once a month'
    a_monthly 'at least every month',
      :text_as_statement => 'at least every month',
      :requirement => ['pilot_12']
    a_weekly 'within a week of any change',
      :text_as_statement => 'within a week of any change',
      :requirement => ['standard_20']
    a_daily 'within a day of any change',
      :text_as_statement => 'within a day of any change',
      :requirement => ['exemplar_9']

    label_pilot_12 'You should <strong>create a new database dump every month</strong> so that people have the latest data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'You should <strong>create a new database dump within a week of any change</strong> so that people have less time to wait for the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'You should <strong>create a new database dump within a day of any change</strong> so that people find it easier to get the latest data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Will your data be corrected if it has errors?',
      :display_on_certificate => true,
      :text_as_statement => 'Any errors in this data are',
      :help_text => 'It\'s good practice to fix errors in your data especially if you use it yourself. When you make corrections, people need to be told about them.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'corrected',
      :requirement => ['standard_21']

    label_standard_21 'You should <strong>correct data when people report errors</strong> so everyone benefits from improvements in accuracy.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Qualité',
      :help_text => 'a quel point les gens peuvent se fier à vos données',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'A quel endroit vos documents traitent de la qualité de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Data quality is documented at',
      :help_text => 'Donnez une URL à laquelle il est possible de se renseigner sur la qualité de vos données. Les erreurs sont inévitables, et elles peuvent provenir par exemple de problèmes techniques ou d’erreurs apparaissant durant les changements de système. Nous vous recommandons d’être transparents sur la qualité de vos données, afin que les gens puissent savoir à quel point ils peuvent s’y fier.'
    a_1 'URL des documents traitant de la qualité des données',
      :string,
      :input_type => :url,
      :placeholder => 'URL des documents traitant de la qualité des données',
      :requirement => ['standard_22']

    label_standard_22 'You should <strong>document any known issues with your data quality</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Où est décrit votre processus de contrôle qualité?',
      :display_on_certificate => true,
      :text_as_statement => 'Quality control processes are described at',
      :help_text => 'Donnez une URL à laquelle les gens peuvent se rendre pour se renseigner sur les contrôles en cours sur vos données, qu’ils soient automatiques ou manuels. Cela permet de les rassurer sur votre sérieux et sur la qualité de vos données, et peut amener à des améliorations bénéfiques pour tous.'
    a_1 'URL de description du processus de contrôle qualité',
      :string,
      :input_type => :url,
      :placeholder => 'URL de description du processus de contrôle qualité',
      :requirement => ['exemplar_10']

    label_exemplar_10 'You should <strong>document your quality control process</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garanties',
      :help_text => 'a quel point les gens peuvent s’appuyer sur la disponibilité de vos données',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Do you take offsite backups?',
      :display_on_certificate => true,
      :text_as_statement => 'The data is',
      :help_text => 'Taking a regular offsite backup helps ensure that the data won\'t be lost in the case of accident.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'backed up offsite',
      :requirement => ['standard_23']

    label_standard_23 'You should <strong>take a result offsite backup</strong> so that the data won\'t be lost if an accident happens.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Where do you describe any guarantees about service availability?',
      :display_on_certificate => true,
      :text_as_statement => 'Service availability is described at',
      :help_text => 'Give a URL for a page that describes what guarantees you have about your service being available for people to use. For example you might have a guaranteed uptime of 99.5%, or you might provide no guarantees.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Service Availability Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Service Availability Documentation URL',
      :requirement => ['standard_24']

    label_standard_24 'You should <strong>describe what guarantees you have around service availability</strong> so that people know how much they can rely on it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Where do you give information about the current status of the service?',
      :display_on_certificate => true,
      :text_as_statement => 'Service status is given at',
      :help_text => 'Give a URL for a page that tells people about the current status of your service, including any faults you are aware of.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Service Status URL',
      :string,
      :input_type => :url,
      :placeholder => 'Service Status URL',
      :requirement => ['expert_1']

    label_expert_1 'You should <strong>have a service status page</strong> that tells people about the current status of your service.',
      :custom_renderer => '/partials/requirement_expert',
      :requirement => 'expert_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Pour combien de temps ces données seront­elles disponibles?',
      :display_on_certificate => true,
      :text_as_statement => 'The data is available',
      :pick => :one
    a_experimental 'elles pourraient disparaître à n’importe quel moment',
      :text_as_statement => 'experimentally and might disappear at any time'
    a_short 'elles sont disponibles à titre expérimental, mais devraient être disponibles pour encore environ un an',
      :text_as_statement => 'experimentally for another year or so',
      :requirement => ['pilot_13']
    a_medium 'elles font partie de vos plans à moyen terme et devraient être encore disponibles pour environ deux ans',
      :text_as_statement => 'for at least a couple of years',
      :requirement => ['standard_25']
    a_long 'elles font partie de vos opérations quotidiennes et resteront donc publiées pendant longtemps',
      :text_as_statement => 'for a long time',
      :requirement => ['exemplar_11']

    label_pilot_13 'You should <strong>guarantee that your data will be available in this form for at least a year</strong> so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'You should <strong>guarantee that your data will be available in this form in the medium-term</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_11 'You should <strong>guarantee that your data will be available in this form in the long-term</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Informations Techniques',
    :description => 'Emplacement, formats et confiance' do

    label_group_11 'Emplacements',
      :help_text => 'la manière dont les gens peuvent accéder à vos données',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Where is your dataset?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is published at',
      :help_text => 'Give a URL to the dataset itself. Open data should be linked to directly on the web so people can easily find and reuse it.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dataset URL',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'You must <strong>provide either a URL to your data or a URL to documentation</strong> about it so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'You should <strong>have a URL that is a direct link to the data itself</strong> so that people can access it easily.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'How do you publish a series of the same dataset?',
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current dataset.',
      :requirement => ['standard_26']
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your dataset URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['pilot_15']
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of datasets on a web page or a feed (like Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['standard_27']

    label_standard_26 'You should <strong>have a single persistent URL to download the current version of your data</strong> so that people can access it easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'You should <strong>use a consistent pattern for different release URLs</strong> so that people can download each one automatically.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'You should <strong>have a document or feed with a list of available releases</strong> so people can create scripts to download them all.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'You must <strong>provide access to releases of your data through a URL</strong> that gives the current version, a discoverable series of URLs or through a documentation page so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Where is your current dataset?',
      :display_on_certificate => true,
      :text_as_statement => 'The current dataset is available at',
      :help_text => 'Give a single URL to the most recent version of the dataset. The content at this URL should change each time a new version is released.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'Current Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dataset URL',
      :required => :required

    q_versionsTemplateUrl 'What format do dataset release URLs follow?',
      :display_on_certificate => true,
      :text_as_statement => 'Releases follow this consistent URL pattern',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'Version Template URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version Template URL',
      :required => :required

    q_versionsUrl 'Where is your list of dataset releases?',
      :display_on_certificate => true,
      :text_as_statement => 'Releases of this data are listed at',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of datasets. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'Version List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version List URL',
      :required => :required

    q_endpointUrl 'Where is the endpoint for your API?',
      :display_on_certificate => true,
      :text_as_statement => 'The API service endpoint is',
      :help_text => 'Give a URL that\'s a starting point for people\'s scripts to access your API. This should be a service description document that helps the script to work out which services exist.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Endpoint URL',
      :string,
      :input_type => :url,
      :placeholder => 'Endpoint URL',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'You must <strong>provide either an API endpoint URL or a URL to its documentation</strong> so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'You should <strong>have a service description document or single entry point for your API</strong> so that people can access it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'How do you publish database dumps?',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current database dump.',
      :requirement => ['standard_29']
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your database dump URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['exemplar_12']
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of database dumps on a web page or a feed (such as Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['exemplar_13']

    label_standard_29 'You should <strong>have a single persistent URL to download the current dump of your database</strong> so that people can find it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_12 'You should <strong>use a consistent pattern for database dump URLs</strong> so that people can can download each one automatically.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_13 'You should <strong>have a document or feed with a list of available database dumps</strong> so people can create scripts to download them all',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Where is the current database dump?',
      :display_on_certificate => true,
      :text_as_statement => 'The most recent database dump is always available at',
      :help_text => 'Give a URL to the most recent dump of the database. The content at this URL should change each time a new database dump is created.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'Current Dump URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dump URL',
      :required => :required

    q_dumpsTemplateUrl 'What format do database dump URLs follow?',
      :display_on_certificate => true,
      :text_as_statement => 'Database dumps follow the consistent URL pattern',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'Dump Template URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump Template URL',
      :required => :required

    q_dumpsUrl 'Where is your list of available database dumps?',
      :display_on_certificate => true,
      :text_as_statement => 'A list of database dumps is at',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of database dumps. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'Dump List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump List URL',
      :required => :required

    q_changeFeedUrl 'Where is your feed of changes?',
      :display_on_certificate => true,
      :text_as_statement => 'A feed of changes to this data is at',
      :help_text => 'Give a URL to a page or feed that provides a machine-readable list of the previous versions of the database dumps. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'Change Feed URL',
      :string,
      :input_type => :url,
      :placeholder => 'Change Feed URL',
      :required => :required

    label_group_12 'Formats',
      :help_text => 'la manière dont les gens peuvent travailler avec vos données',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Vos données sont­elles lisibles par machine?',
      :display_on_certificate => true,
      :text_as_statement => 'This data is',
      :help_text => 'Les gens préfèrent les formats qui sont facilement traitables par ordinateur, pour des raisons de rapidité et de précision. Par exemple, une photocopie scannée d’une feuille de calcul ne serait pas lisible par machine, contrairement à un fichier CSV.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :requirement => ['pilot_16']

    label_pilot_16 'You should <strong>provide your data in a machine-readable format</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Vos données sont­elles dans un format open data standard?',
      :display_on_certificate => true,
      :text_as_statement => 'The format of this data is',
      :help_text => 'Les standards open data sont créés au travers d’un processus équitable, transparent et collaboratif. N’importe qui peut les mettre en place, et bénéficier de beaucoup d’assistance. Ils vous permettent donc de partager vos données plus facilement. Les formats XML, CSV et JSON sont par exemple des standards open data.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'a standard open format',
      :requirement => ['standard_30']

    label_standard_30 'You should <strong>provide your data in an open standard format</strong> so that people can use widely available tools to process it more easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Quel genre de données publiez­vous?',
      :pick => :any
    a_documents 'documents lisibles par des humains',
      :help_text => 'Cochez cette case si vos données sont destinées à une consommation humaine. Par exemple: documents protocolaires, livres blancs, rapports et compte rendus de réunions. Ces documents sont généralement structurés, mais contiennent surtout du texte.'
    a_statistical 'données statistiques, telles que des comptes, des moyennes ou des pourcentages',
      :help_text => 'Cochez cette case si vos données sont des données statistiques ou numériques, telles que des comptes, des moyennes ou des pourcentages. Par exemple: résultats de recensement, informations sur le trafic routier, statistiques sur la criminalité...'
    a_geographic 'informations géographiques, telles que des points et des frontières',
      :help_text => 'Cochez cette case si vos données peuvent être indiquées sur une carte sous forme de points, de frontières ou de lignes.'
    a_structured 'autre genre de données structurées',
      :help_text => 'Cochez cette case si vos données sont structurées d’une autre manière. Par exemple des détails d’évènements, des horaires de train, des listes de contacts ou tout autre type de données qui peuvent être interprétées, analysées et présentées de différentes manières.'

    q_documentFormat 'Do your human-readable documents include formats that',
      :display_on_certificate => true,
      :text_as_statement => 'Documents are published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'describe semantic structure like HTML, Docbook or Markdown',
      :text_as_statement => 'in a semantic format',
      :help_text => 'These formats label structures like chapters, headings and tables that make it easy to automatically create summaries like tables of contents and glossaries. They also make it easy to apply different styles to the document so its appearance changes.',
      :requirement => ['standard_31']
    a_format 'describe information on formatting like OOXML or PDF',
      :text_as_statement => 'in a display format',
      :help_text => 'These formats emphasise appearance like fonts, colours and positioning of different elements within the page. These are good for human consumption, but aren\'t as easy for people to process automatically and change style.',
      :requirement => ['pilot_17']
    a_unsuitable 'aren\'t meant for documents like Excel, JSON or CSV',
      :text_as_statement => 'in a format unsuitable for documents',
      :help_text => 'These formats better suit tabular or structured data.'

    label_standard_31 'You should <strong>publish documents in a format that exposes semantic structure</strong> so that people can display them in different styles.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'You should <strong>publish documents in a format designed specifically for them</strong> so that they\'re easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Does your statistical data include formats that',
      :display_on_certificate => true,
      :text_as_statement => 'Statistical data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'expose the structure of statistical hypercube data like <a href="http://sdmx.org/">SDMX</a> or <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a>',
      :text_as_statement => 'in a statistical data format',
      :help_text => 'Individual observations in hypercubes relate to a particular measure and a set of dimensions. Each observation may also be related to annotations that give extra context. Formats like <a href="http://sdmx.org/">SDMX</a> and <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> are designed to express this underlying structure.',
      :requirement => ['exemplar_14']
    a_tabular 'treat statistical data as a table like CSV',
      :text_as_statement => 'in a tabular data format',
      :help_text => 'These formats arrange statistical data within a table of rows and columns. This lacks extra context about the underlying hypercube but is easy to process.',
      :requirement => ['standard_32']
    a_format 'focus on the format of tabular data like Excel',
      :text_as_statement => 'in a presentation format',
      :help_text => 'Spreadsheets use formatting like italic or bold text, and indentation within fields to describe its appearance and underlying structure. This styling helps people to understand the meaning of your data but makes it less suitable for computers to process.',
      :requirement => ['pilot_18']
    a_unsuitable 'aren\'t meant for statistical or tabular data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for statistical data',
      :help_text => 'These formats don\'t suit statistical data because they obscure the underlying structure of the data.'

    label_exemplar_14 'You should <strong>publish statistical data in a format that exposes dimensions and measures</strong> so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'You should <strong>publish tabular data in a format that exposes tables of data</strong> so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'You should <strong>publish tabular data in a format designed for that purpose</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Does your geographic data include formats that',
      :display_on_certificate => true,
      :text_as_statement => 'Geographic data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'are designed for geographic data like <a href="http://www.opengeospatial.org/standards/kml/">KML</a> or <a href="http://www.geojson.org/">GeoJSON</a>',
      :text_as_statement => 'in a geographic data format',
      :help_text => 'These formats describe points, lines and boundaries, and expose structures in the data which make it easier to process automatically.',
      :requirement => ['exemplar_15']
    a_generic 'keeps data structured like JSON, XML or CSV',
      :text_as_statement => 'in a generic data format',
      :help_text => 'Any format that stores normal structured data can express geographic data too, particularly if it only holds data about points.',
      :requirement => ['pilot_19']
    a_unsuitable 'aren\'t designed for geographic data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for geographic data',
      :help_text => 'These formats don\'t suit geographic data because they obscure the underlying structure of the data.'

    label_exemplar_15 'You should <strong>publish geographic data in a format designed that purpose</strong> so that people can use widely available tools to process it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'You should <strong>publish geographic data as structured data</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Does your structured data include formats that',
      :display_on_certificate => true,
      :text_as_statement => 'Structured data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'are designed for structured data like JSON, XML, Turtle or CSV',
      :text_as_statement => 'in a structured data format',
      :help_text => 'These formats organise data into a basic structure of things which have values for a known set of properties. These formats are easy for computers to process automatically.',
      :requirement => ['pilot_20']
    a_unsuitable 'aren\'t designed for structured data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for structured data',
      :help_text => 'These formats don\'t suit this kind of data because they obscure its underlying structure.'

    label_pilot_20 'You should <strong>publish structured data in a format designed that purpose</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Vos données utilisent­elles des identifiants homogènes?',
      :display_on_certificate => true,
      :text_as_statement => 'The data includes',
      :help_text => 'Les données traitent généralement de choses concrètes, comme des écoles ou des routes, ou bien utilisent un système de codage. Si des données provenant de différentes sources utilisent le même unique identifiant pour se référer aux mêmes choses de manière durable, il est facile de combiner les sources afin de créer des données plus utiles. Les identifiants peuvent être des GUIDs, des DOIs ou des URLs.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'persistent identifiers',
      :requirement => ['standard_33']

    label_standard_33 'You should <strong>use identifiers for things in your data</strong> so that they can be easily related with other data about those things.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Can the identifiers in your data be used to find extra information?',
      :display_on_certificate => true,
      :text_as_statement => 'The persistent identifiers',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no, the identifiers can\'t be used to find extra information',
      :text_as_statement => ''
    a_service 'yes, there is a service that people can use to resolve the identifiers',
      :text_as_statement => 'resolve using a service',
      :help_text => 'Online services can be used to give people information about identifiers such as GUIDs or DOIs which can\'t be directly accessed in the way that URLs are.',
      :requirement => ['standard_34']
    a_resolvable 'yes, the identifiers are URLs that resolve to give information',
      :text_as_statement => 'resolve because they are URLs',
      :help_text => 'URLs are useful for both people and computers. People can put a URL into their browser and read more information, like <a href="http://opencorporates.com/companies/gb/08030289">companies</a> and <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">postcodes</a>. Computers can also process this extra information using scripts to access the underlying data.',
      :requirement => ['exemplar_16']

    label_standard_34 'You should <strong>provide a service to resolve the identifiers you use</strong> so that people can find extra information about them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_16 'You should <strong>link to a web page of information about each of the things in your data</strong> so that people can easily find and share that information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Where is the service that is used to resolve the identifiers?',
      :display_on_certificate => true,
      :text_as_statement => 'The identifier resolution service is at',
      :help_text => 'The resolution service should take an identifier as a query parameter and give back some information about the thing it identifies.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'Identifier Resolution Service URL',
      :string,
      :input_type => :url,
      :placeholder => 'Identifier Resolution Service URL',
      :requirement => ['standard_35']

    label_standard_35 'You should <strong>have a URL through which identifiers can be resolved</strong> so that more information about them can be found by a computer.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Is there third-party information about things in your data on the web?',
      :help_text => 'Sometimes other people outside your control provide URLs to the things your data is about. For example, your data might have postcodes in it that link to the Ordnance Survey website.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Is that third-party information reliable?',
      :help_text => 'If a third-party provides public URLs about things in your data, they probably take steps to ensure data quality and reliability. This is a measure of how much you trust their processes to do that. Look for their open data certificate or similar hallmarks to help make your decision.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Does your data use those third-party URLs?',
      :display_on_certificate => true,
      :text_as_statement => 'Third-party URLs are',
      :help_text => 'You should use third-party URLs that resolve to information about the things your data describes. This reduces duplication and helps people combine data from different sources to make it more useful.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'referenced in this data',
      :requirement => ['exemplar_17']

    label_exemplar_17 'You should <strong>use URLs to third-party information in your data</strong> so that it\'s easy to combine with other data that uses those URLs.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Confiance',
      :help_text => 'a quel point les gens peuvent faire confiance à vos données',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Fournissez­vous des informations lisibles par machine sur la provenance de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'The provenance of this data is',
      :help_text => 'Cela concerne les origines de vos données et la manière dont elles ont été créées et traitées avant d’être publiées. Cela permet de renforcer la confiance dans les données que vous publiez, puisqu’il est facile de remonter à la source et de savoir comment elles ont été gérées.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :requirement => ['exemplar_18']

    label_exemplar_18 'You should <strong>provide a machine-readable provenance trail</strong> about your data so that people can trace how it was processed.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'À quel endroit expliquez­vous le processus de vérification de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'This data can be verified using',
      :help_text => 'Si vous fournissez des données importantes à quelqu’un, cette personne devrait pouvoir être en mesure de vérifier que les données qu’elle a reçues sont les mêmes que celles que vous publiez. Vous pouvez par exemple signer digitalement les données que vous publiez, afin qu’il soit possible de vérifier qu’elles n’ont pas été altérées.'
    a_1 'URL du processus de vérification',
      :string,
      :input_type => :url,
      :placeholder => 'URL du processus de vérification',
      :requirement => ['exemplar_19']

    label_exemplar_19 'You should <strong>describe how people can check that the data they receive is the same as what you published</strong> so that they can trust it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Informations Sociales',
    :description => 'Documentation, assistance et services' do

    label_group_15 'Documentation',
      :help_text => 'comment vous aidez les gens à comprendre le contenu et le contexte de vos données',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :display_on_certificate => true,
      :text_as_statement => 'The documentation includes machine-readable data for',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'title',
      :text_as_statement => 'title',
      :requirement => ['standard_36']
    a_description 'description',
      :text_as_statement => 'description',
      :requirement => ['standard_37']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :requirement => ['standard_38']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'frequency of releases',
      :text_as_statement => 'release frequency',
      :requirement => ['standard_40']
    a_identifier 'identifier',
      :text_as_statement => 'identifier',
      :requirement => ['standard_41']
    a_landingPage 'landing page',
      :text_as_statement => 'landing page',
      :requirement => ['standard_42']
    a_language 'language',
      :text_as_statement => 'language',
      :requirement => ['standard_43']
    a_publisher 'publisher',
      :text_as_statement => 'publisher',
      :requirement => ['standard_44']
    a_spatial 'spatial/geographical coverage',
      :text_as_statement => 'spatial/geographical coverage',
      :requirement => ['standard_45']
    a_temporal 'temporal coverage',
      :text_as_statement => 'temporal coverage',
      :requirement => ['standard_46']
    a_theme 'theme(s)',
      :text_as_statement => 'theme(s)',
      :requirement => ['standard_47']
    a_keyword 'keyword(s) or tag(s)',
      :text_as_statement => 'keyword(s) or tag(s)',
      :requirement => ['standard_48']
    a_distribution 'distribution(s)',
      :text_as_statement => 'distribution(s)'

    label_standard_36 'You should <strong>include a machine-readable data title in your documentation</strong> so that people know how to refer to it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'You should <strong>include a machine-readable data description in your documentation</strong> so that people know what it contains.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'You should <strong>include a machine-readable data release date in your documentation</strong> so that people know how timely it is.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'You should <strong>include a machine-readable last modification date in your documentation</strong> so that people know they have the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'You should <strong>provide machine-readable metadata about how frequently you release new versions of your data</strong> so people know how often you update it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'You should <strong>include a canonical URL for the data in your machine-readable documentation</strong> so that people know how to access it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'You should <strong>include a canonical URL to the machine-readable documentation itself</strong> so that people know how to access to it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'You should <strong>include the data language in your machine-readable documentation</strong> so that people who search for it will know whether they can understand it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'You should <strong>indicate the data publisher in your machine-readable documentation</strong> so people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'You should <strong>include the geographic coverage in your machine-readable documentation</strong> so that people understand where your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'You should <strong>include the time period in your machine-readable documentation</strong> so that people understand when your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'You should <strong>include the subject in your machine-readable documentation</strong> so that people know roughly what your data is about.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'You should <strong>include machine-readable keywords or tags in your documentation</strong> to help people search within the data effectively.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Does your documentation include machine-readable metadata for each distribution on:',
      :display_on_certificate => true,
      :text_as_statement => 'The documentation about each distribution includes machine-readable data for',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'title',
      :text_as_statement => 'title',
      :requirement => ['standard_49']
    a_description 'description',
      :text_as_statement => 'description',
      :requirement => ['standard_50']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :requirement => ['standard_51']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :requirement => ['standard_52']
    a_rights 'rights statement',
      :text_as_statement => 'rights statement',
      :requirement => ['standard_53']
    a_accessURL 'URL to access the data',
      :text_as_statement => 'a URL to access the data',
      :help_text => 'This metadata should be used when your data isn\'t available as a download, like an API for example.'
    a_downloadURL 'URL to download the dataset',
      :text_as_statement => 'a URL to download the dataset'
    a_byteSize 'size in bytes',
      :text_as_statement => 'size in bytes'
    a_mediaType 'type of download media',
      :text_as_statement => 'type of download media'

    label_standard_49 'You should <strong>include machine-readable titles within your documentation</strong> so people know how to refer to each data distribution.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'You should <strong>include machine-readable descriptions within your documentation</strong> so people know what each data distribution contains.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'You should <strong>include machine-readable release dates within your documentation</strong> so people know how current each distribution is.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'You should <strong>include machine-readable last modification dates within your documentation</strong> so people know whether their copy of a data distribution is up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'You should <strong>include a machine-readable link to the applicable rights statement</strong> so people can find out what they can do with a data distribution.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Where is the technical documentation for the data?',
      :display_on_certificate => true,
      :text_as_statement => 'The technical documentation for the data is at'
    a_1 'Technical Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Technical Documentation URL',
      :requirement => ['pilot_21']

    label_pilot_21 'You should <strong>provide technical documentation for the data</strong> so that people understand how to use it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Est­ce que les formats de vos données utilisent des «vocabularies» ou des «schemas»?',
      :help_text => 'Les formats tels que CSV, JSON, XML ou Turtle utilisent un «vocabulary» ou des «schemas» qui indiquent quelles rubriques ou quelles propriétés les données contiennent.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Where is documentation about your data vocabularies?',
      :display_on_certificate => true,
      :text_as_statement => 'The vocabularies used by this data are documented at'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'Schema Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Schema Documentation URL',
      :requirement => ['standard_54']

    label_standard_54 'You should <strong>document any vocabulary you use within your data</strong> so that people know how to interpret it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Vos données utilisent­elles des codes?',
      :help_text => 'Si vos données utilisent des codes pour se référer à certains éléments, comme par exemple des zones géographiques, des catégories de dépenses ou des maladies, il est nécessaire que ce soit expliqué.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Where are any codes in your data documented?',
      :display_on_certificate => true,
      :text_as_statement => 'The codes in this data are documented at'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'Codelist Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Codelist Documentation URL',
      :requirement => ['standard_55']

    label_standard_55 'You should <strong>document the codes used within your data</strong> so that people know how to interpret them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Assistance',
      :help_text => 'comment vous communiquez avec les utilisateurs de vos données',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Where can people find out how to contact someone with questions about this data?',
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to contact someone about this data at',
      :help_text => 'Give a URL for a page that describes how people can contact someone if they have questions about the data.'
    a_1 'Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Contact Documentation',
      :requirement => ['pilot_22']

    label_pilot_22 'You should <strong>provide contact information for people to send questions</strong> about your data to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'A qui peuvent s’adresser les personnes ayant des suggestions sur la manière dont vous publiez vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to suggest improvements to publication at'
    a_1 'URL de suggestion',
      :string,
      :input_type => :url,
      :placeholder => 'URL de suggestion',
      :requirement => ['pilot_23']

    label_pilot_23 'You should <strong>provide instructions about how suggest improvements</strong> to the way you publish data so you can discover what people need.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Where can people find out how to contact someone with questions about privacy?',
      :display_on_certificate => true,
      :text_as_statement => 'Find out where to send questions about privacy at'
    a_1 'Confidentiality Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Confidentiality Contact Documentation',
      :requirement => ['pilot_24']

    label_pilot_24 'You should <strong>provide contact information for people to send questions about privacy</strong> and disclosure of personal details to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Utilisez­vous les réseaux et médias sociaux pour entrer en contact avec les personnes qui utilisent vos données?',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 'You should <strong>use social media to reach people who use your data</strong> and discover how your data is being used',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Account' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Which social media accounts can people reach you on?',
        :display_on_certificate => true,
        :text_as_statement => 'Contact the curator through these social media accounts',
        :help_text => 'Give URLs to your social media accounts, like your Twitter or Facebook profile page.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'Social Media URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Social Media URL'

    end

    q_forum 'A quel endroit est­il possible de discuter à propos de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Discuss this data at',
      :help_text => 'Donnez l’adresse de votre forum ou d’une mailing list permettant de parler de vos données'
    a_1 'URL de forum ou mailing list',
      :string,
      :input_type => :url,
      :placeholder => 'URL de forum ou mailing list',
      :requirement => ['standard_57']

    label_standard_57 'You should <strong>tell people where they can discuss your data</strong> and support one another.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Where can people find out how to request corrections to your data?',
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to request data corrections at',
      :help_text => 'Give a URL where people can report errors they spot in your data.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Instructions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Instructions URL',
      :requirement => ['standard_58']

    label_standard_58 'You should <strong>provide instructions about how people can report errors</strong> in your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Where can people find out how to get notifications of corrections to your data?',
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to get notifications about data corrections at',
      :help_text => 'Give a URL where you describe how notifications about corrections are shared with people.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Notification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Notification URL',
      :requirement => ['standard_59']

    label_standard_59 'You should <strong>provide a mailing list or feed with updates</strong> that people can use to keep their copies of your data up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Quelqu’un est­il chargé de créer activement une communauté autour de ces données?',
      :help_text => 'A community engagement team will engage through social media, blogging, and arrange hackdays or competitions to encourage people to use the data.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_20']

    label_exemplar_20 'You should <strong>build a community of people around your data</strong> to encourage wider use of your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Where is their home page?',
      :display_on_certificate => true,
      :text_as_statement => 'Community engagement is done by',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'Community Engagement Team Home Page URL',
      :string,
      :input_type => :url,
      :placeholder => 'Community Engagement Team Home Page URL',
      :required => :required

    label_group_17 'Services',
      :help_text => 'comment vous donnez accès aux outils nécessaires pour travailler avec vos données',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'A quel endroit listez­vous les outils permettant de travailler avec vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Tools to help use this data are listed at',
      :help_text => 'Indiquez une URL listant les outils permettant de travailler avec vos données que vous connaissez ou que vous recommandez.'
    a_1 'URL des outils',
      :string,
      :input_type => :url,
      :placeholder => 'URL des outils',
      :requirement => ['exemplar_21']

    label_exemplar_21 'You should <strong>provide a list of software libraries and other readily-available tools</strong> so that people can quickly get to work with your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end

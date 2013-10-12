survey 'FR',
  :full_title => 'France',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>Ce questionnaire d’auto­évaluation permet de générer un certificat et un badge open data, que vous pouvez publier pour donner des informations à propos de vos données ouvertes. Nous utilisons aussi vos réponses pour comprendre comment les organisations publient leurs données ouvertes.</p><p>Répondre à ces questions vous permet de montrer vos efforts pour vous conformer à la législation française. Nous vous recommandons de vous renseigner aussi sur les autres règles et lois qui s’appliquent à votre secteur d’activité, particulièrement si vous résidez en dehors de la France.</p><p><strong>Il n’est pas nécessaire de répondre à toutes les questions pour obtenir un certificat.</strong> Répondez seulement à celles vous concernant.</p>' do

  translations :en => :default
  section_general 'Informations générales',
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
      :text_as_statement => 'Ces données sont décrites au',
      :help_text => 'Indiquez une adresse internet à laquelle on peut trouver le contenu détaillé de vos données. Il est possible d’indiquer un site avec un plus gros catalogue tel que data.gov.uk.'
    a_1 'URL des documents',
      :string,
      :input_type => :url,
      :placeholder => 'URL des documents',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Vous devez avoir une page web qui offre <strong>documentation</strong> sur les données ouvertes que vous publiez afin que les gens puissent comprendre le contexte, le contenu et l\'utilité.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Vous devez avoir une page web <strong>qui donne documentation</strong> et l\'accès aux données ouvertes que vous publiez afin que les gens puissent l\'utiliser.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Qui publie ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont publiées par',
      :help_text => 'Indiquez le nom de l’organisation qui publie ces données. Il s’agit probablement de votre employeur, à moins que vous effectuiez ces démarches au nom de quelqu’un d’autre.',
      :required => :required
    a_1 'Editeur des données',
      :string,
      :placeholder => 'Editeur des données',
      :required => :required

    q_publisherUrl 'Sur quel site internet sont publiées ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Les données sont publiées sur',
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
    a_complicated 'les droits de ces données sont compliquées ou imprécises'

    label_standard_1 'Vous devez avoir un <strong>droit légal clair de publier ces données</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'Vous devez avoir le <strong>droit de publier ces données</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Où avez-vous détailler les risques gens pourraient rencontrer s\'ils utilisent ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Risque en utilisant ces données sont décrites au',
      :help_text => 'Il peut être risqué pour les gens à utiliser les données sans droit légal clair de le faire. Par exemple, les données pourraient être prises vers le bas en réponse à une contestation judiciaire. Donnez une URL d\'une page qui décrit le risque d\'utiliser ces données.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'Documentation des risques d\'URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation des risques d\'URL',
      :requirement => ['pilot_2']

    label_pilot_2 'Vous devez documenter les risques <strong>associés à l\'utilisation de ces données</strong>, afin que les gens puissent travailler sur la façon dont ils veulent l\'utiliser.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Est <em>tous</em> de ces données créés à l\'origine ou collectées par vous?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données ont été',
      :help_text => 'Si une partie de ces données a été adjugé à l\'extérieur de votre organisation par d\'autres personnes ou organisations, alors vous devez donner des informations supplémentaires au sujet de votre droit de le publier.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'à l\'origine créée ou générée par son conservateur'

    q_thirdPartyOrigin 'été certaines de ces données extraites ou calculées à partir d\'autres données?',
      :help_text => 'Un extrait ou moins partie des données de quelqu\'un d\'autre veut encore vos droits d\'utilisation qu\'il pourrait en être affectée. Il pourrait aussi y avoir des problèmes juridiques si vous avez analysé les données pour produire de nouveaux résultats de celle-ci.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_3']

    label_basic_3 'Vous avez dit que ces données n\'ont pas été créés à l\'origine ou rassemblés par vous, et n\'a pas été crowdsourcing, donc il doit avoir été extraite ou calculée à partir d\'autres sources de données.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Y <em>tous</em> sources de ces données déjà publiées comme les données ouvertes?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont créées à partir de',
      :help_text => 'Vous êtes autorisé à publier à quelqu\'un d\'autre données si elle est déjà sous une licence ouverte de données ou si leurs droits ont expiré ou ont été abandonnés. Si une partie de ces données n\'est pas comme cela, alors vous aurez besoin de conseils juridiques avant de pouvoir le publier.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'sources de données ouvertes',
      :requirement => ['basic_4']

    label_basic_4 'Vous devriez obtenir des conseils juridiques <strong>vous assurer que vous avez le droit de publier ces données</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Était certaines de ces données crowdsourcing?',
      :display_on_certificate => true,
      :text_as_statement => 'Certaines de ces données est',
      :help_text => 'Si les données comprennent des informations apportées par des personnes extérieures à votre organisation, vous avez besoin de leur permission de publier leurs contributions sous forme de données ouvertes.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'crowdsourcing',
      :requirement => ['basic_5']

    label_basic_5 'Vous avez dit que les données n\'ont pas été créés à l\'origine ou rassemblés par vous et n\'a pas été extrait ou calculée à partir d\'autres données, donc il doit avoir été externalisées.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Ont contribué à ces données utilisent leur jugement?',
      :help_text => 'Si les gens ont utilisé leur créativité ou d\'un jugement de fournir des données, puis ils ont droit d\'auteur sur leur travail. Par exemple, une description ou de décider d\'inclure ou non certaines données dans un ensemble de données exigerait jugement. Alors contributeurs doivent transférer ou renoncer à leurs droits ou une licence les données avant que vous pouvez publier.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl 'Où est le contrat de licence de contributeur (CLA)?',
      :display_on_certificate => true,
      :text_as_statement => 'Le contrat de licence de contributeur est à',
      :help_text => 'Donne un lien vers un accord qui montre contributeurs vous permettent de réutiliser leurs données. A CLA sera soit transférer les droits du cotisant pour vous, renoncer à leurs droits ou une licence les données pour vous afin que vous puissiez le publier.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'Contributeur contrat de licence d\' URL',
      :string,
      :input_type => :url,
      :placeholder => 'Contributeur contrat de licence d\' URL',
      :required => :required

    q_cldsRecorded 'Ont tous les contributeurs accepté le contrat de licence de contributeur (CLA)?',
      :help_text => 'Consultez toutes les apporteurs y consentent à une CLA avant de les réutiliser ou de publier leurs contributions. Vous devez tenir un registre des contributions qui ont donné et si oui ou non ils acceptent de le CLA.',
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

    label_basic_6 'Vous devez obtenir contributeurs <strong>de convenir d\'un accord de licence de contributeur</strong> (CLA) qui vous donne le droit de publier leur travail l\'ouverture des données.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Où avez-vous décrire les sources de ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Les sources de ces données sont décrites au',
      :help_text => 'Donnez une URL que les documents où les données a été adjugé à partir de ( sa provenance ) et les droits en vertu de laquelle vous publier les données. Cela aide les gens à comprendre où proviennent les données.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Sources de données Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Sources de données Documentation URL',
      :requirement => ['pilot_3']

    label_pilot_3 'Vous devez documenter <strong>où proviennent les données et les droits en vertu de laquelle le publier</strong>, afin que les gens êtes assuré qu\'ils peuvent utiliser des pièces qui sont venus auprès de tiers.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Est documentation sur les sources de ces données aussi en format lisible par machine?',
      :display_on_certificate => true,
      :text_as_statement => 'Le commissaire a publié',
      :help_text => 'Information sur les sources de données doit être lisible par l\'homme afin que les gens puissent le comprendre, ainsi que dans un format de métadonnées que les ordinateurs peuvent traiter. Quand tout le monde fait ce qu\'il aide d\'autres personnes découvrent comment les mêmes données ouvertes est utilisé et justifier sa publication en cours.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'les données lisibles par machine sur les sources de ces données',
      :requirement => ['standard_2']

    label_standard_2 'Vous devez <strong>inclure des données lisibles par machine sur les sources de ces données</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Autorisations',
      :help_text => 'la manière dont vous accordez aux gens la permission d’utiliser vos données',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Où avez-vous publié la déclaration des droits pour cet ensemble de données?',
      :display_on_certificate => true,
      :text_as_statement => 'La déclaration des droits est au',
      :help_text => 'Donner l\'URL vers une page qui décrit le droit de réutiliser cet ensemble de données. Cela devrait inclure une référence à sa licence, les conditions d\' attribution et une déclaration sur le droit d\'auteur pertinent et droits de base de données. Une déclaration des droits aide les gens à comprendre ce qu\'ils peuvent et ne peuvent pas faire avec les données.'
    a_1 'URL Déclaration des droits',
      :string,
      :input_type => :url,
      :placeholder => 'URL Déclaration des droits',
      :requirement => ['pilot_4']

    label_pilot_4 'Vous devez <strong>publier une déclaration des droits</strong> que les détails d\'auteur, droits de base de données, les licences et comment les gens devraient donner l\'attribution aux données.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Sous quelle licence les gens peuvent réutiliser ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont disponibles sous',
      :help_text => 'Rappelez-vous que celui qui rassemble l\'origine, crée, vérifie ou présente une base de données automatiquement obtient les droits sur elle. Il peut aussi y avoir droit d\'auteur dans l\'organisation et la sélection des données. Alors, les gens ont besoin d\'une renonciation ou d\'une licence qui prouve qu\'ils peuvent utiliser les données et explique comment ils peuvent le faire légalement. Nous listons les licences les plus communs ici, s\'il n\'y a pas de droits de base de données ou droits d\'auteur, ils ont expiré, ou si vous avez n\'exigeons plus leur paiement, choisissez « Non applicable ».',
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
    a_na 'Non applicable',
      :text_as_statement => ''
    a_other 'Autre...',
      :text_as_statement => ''

    q_dataNotApplicable 'Pourquoi pas une licence s\'applique à ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données n\'est pas autorisé parce que',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'il n\'y a pas de droits d\'auteur ou de la base de l\'homme dans ces données',
      :text_as_statement => 'il n\'y a pas de droits dans ce',
      :help_text => 'droits de base de données s\'appliquent si vous avez passé la collecte d\' efforts considérables, la vérification ou la présentation il. Il n\'y a pas de droits de base de données si, par exemple, les données sont créées à partir de zéro, présenté d\'une façon évidente, et non vérifiée par rapport à quoi que ce soit. Vous avez le droit d\'auteur si vous sélectionnez les éléments dans les données ou de les organiser d\'une manière non évidente.'
    a_expired 'droit d\'auteur et les droits ont expiré base de données',
      :text_as_statement => 'les droits ont expiré',
      :help_text => 'droits de base de données dix derniers années. Si les données Dernière modification il ya plus de dix ans puis les droits de base de données ont expiré. Droit d\'auteur dure pendant une période de temps déterminée, basée soit sur le nombre d\'années après la mort de son créateur ou de sa publication. Droit d\'auteur est peu probable d\'avoir expiré.'
    a_waived 'droits d\'auteur et droits base de données ont été renoncé',
      :text_as_statement => '',
      :help_text => 'Cela signifie que personne ne possède les droits et tout le monde peut faire ce qu\'ils veulent avec ces données.'

    q_dataWaiver 'Quelle renonciation utilisez-vous pour renoncer à ses droits dans les données?',
      :display_on_certificate => true,
      :text_as_statement => 'Homme dans les données ont été abandonnés avec',
      :help_text => 'Vous avez besoin d\'une déclaration de montrer aux gens les droits ont été levées afin qu\'ils comprennent qu\'ils peuvent faire ce qu\'ils veulent avec ces données. Renonciations standards existent déjà comme PDDL et CCZero mais vous pouvez écrire votre propre avec des conseils juridiques.',
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
    a_other 'Autre...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Où est la renonciation à des droits dans les données?',
      :display_on_certificate => true,
      :text_as_statement => 'Homme dans les données ont été abandonnés avec',
      :help_text => 'Donnez une URL à la renonciation à la disposition du public afin que les gens puissent vérifier qu\'il ne renonce pas aux droits dans les données.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'Renonciation URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Renonciation URL'

    q_otherDataLicenceName 'Quel est le nom de la licence?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont disponibles sous',
      :help_text => 'Si vous utilisez une licence différente, nous avons besoin du nom que les gens puissent le voir sur votre certificat d\' Open Data.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Autre Licence Nom',
      :string,
      :required => :required,
      :placeholder => 'Autre Licence Nom'

    q_otherDataLicenceURL 'Où est la licence?',
      :display_on_certificate => true,
      :text_as_statement => 'Cette licence est à',
      :help_text => 'Donnez une URL à la licence, afin que les gens puissent le voir sur votre certificat d\' Open Data et vérifier qu\'il est accessible au public.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Other URL de licence',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Other URL de licence'

    q_otherDataLicenceOpen 'Est ce que la licence une licence libre?',
      :help_text => 'Si vous n\'êtes pas sûr de ce que une licence ouverte est ensuite lu le <a href="http://opendefinition.org/">Ouvert Définition de connaissances</a> définition. Ensuite, choisissez votre licence de la href="http://licenses.opendefinition.org/"> Ouvert Définition du conseil consultatif de liste des licences open <a </ a>. Si une licence n\'est pas dans leur liste, c\'est soit pas ouvert ou n\'a pas encore été évalué.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_7']

    label_basic_7 'Vous devez <strong>publier des données ouvertes sous une licence open</strong> afin que les gens puissent l\'utiliser.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'Yat-il un droit d\'auteur sur le contenu de ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Il ya',
      :pick => :one,
      :required => :required
    a_norights 'non, les données ne contient que des faits et des chiffres',
      :text_as_statement => 'aucun droit sur le contenu des données',
      :help_text => 'Il n\'ya pas de droit d\'auteur sur des informations factuelles. Si les données ne contiennent pas de contenu qui a été créé par un effort intellectuel, il n\'y a pas de droits sur le contenu.'
    a_samerights 'Oui, et les droits sont détenus par la même personne ou organisation',
      :text_as_statement => '',
      :help_text => 'Choisissez cette option si le contenu dans les données ont été tous créés par ou transféré à la même personne ou organisation.'
    a_mixedrights 'Oui, et les droits sont détenus par différentes personnes ou organisations',
      :text_as_statement => '',
      :help_text => 'Dans certaines données, les droits sur les différents dossiers sont détenus par différentes personnes ou organisations. Information sur les droits doit être maintenu dans les données aussi.'

    q_explicitWaiver 'Est ce que le contenu des données marquées comme domaine public?',
      :display_on_certificate => true,
      :text_as_statement => 'Le contenu a été',
      :help_text => 'Le contenu peut être marqué comme domaine public en utilisant le <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark</a>. Cela aide les gens savent qu\'il peut être réutilisé librement.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'marqués comme domaine public',
      :requirement => ['standard_3']

    label_standard_3 'Vous devez <strong>marquer contenus du domaine public que du domaine public</strong> afin que les gens savent qu\'ils peuvent réutiliser.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Sous quelle licence d\'autres peuvent réutiliser le contenu?',
      :display_on_certificate => true,
      :text_as_statement => 'Le contenu est disponible sous',
      :help_text => 'Rappelez-vous que celui qui consacre l\'effort intellectuel création de contenu obtient automatiquement les droits sur le contenu créatif, mais ne comprend pas les faits. Alors, les gens ont besoin d\'une renonciation ou d\'une licence qui prouve qu\'ils peuvent utiliser le contenu et explique comment ils peuvent le faire légalement. Nous listons les licences les plus communs ici, s\'il n\'ya pas de droit d\'auteur dans le contenu, il est arrivé à expiration, ou si vous avez n\'exigeons plus leur paiement, choisissez « Non applicable ».',
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
    a_na 'Non applicable',
      :text_as_statement => ''
    a_other 'Autre...',
      :text_as_statement => ''

    q_contentNotApplicable 'Pourquoi pas une licence s\'applique pas au contenu des données?',
      :display_on_certificate => true,
      :text_as_statement => 'Le contenu de ces données n\'est pas autorisé parce que',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'il n\'ya pas de droit d\'auteur sur le contenu de ces données',
      :text_as_statement => 'il n\'ya pas de droit d\'auteur',
      :help_text => 'droit d\'auteur s\'applique uniquement au contenu si vous avez passé effort intellectuel créant, par exemple, par l\'écriture du texte qui est dans les données. Il n\'ya pas de droit d\'auteur si le contenu ne contient que des faits.'
    a_expired 'copyright a expiré',
      :text_as_statement => 'copyright a expiré',
      :help_text => 'Copyright dure pendant une période de temps déterminée, basée soit sur le nombre d\'années après la mort de son créateur ou de sa publication. Vous devriez vérifier si le contenu a été créé ou publié parce que si c\'était il ya longtemps, auteur aurait expiré.'
    a_waived 'droit d\'auteur a été levée',
      :text_as_statement => '',
      :help_text => 'Cela signifie que personne ne détient le droit d\'auteur et tout le monde peut faire ce qu\'ils veulent avec ces données.'

    q_contentWaiver 'Quelle renonciation utilisez-vous pour renoncer droit d\'auteur?',
      :display_on_certificate => true,
      :text_as_statement => 'droit d\'auteur a été levée avec',
      :help_text => 'Vous avez besoin d\'une déclaration de montrer aux gens que vous avez fait cela, alors ils comprennent qu\'ils peuvent faire ce qu\'ils veulent avec ces données. Renonciations standards existent déjà comme CCZero mais vous pouvez écrire votre propre avec des conseils juridiques.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Autre...',
      :text_as_statement => 'Autre...'

    q_contentOtherWaiver 'Où est la dérogation pour le droit d\'auteur?',
      :display_on_certificate => true,
      :text_as_statement => 'droit d\'auteur a été levée avec',
      :help_text => 'Donnez une URL à votre propre renonciation disposition du public afin que les gens puissent vérifier qu\'il ne renonce vos droits d\'auteur.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'Renonciation URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Renonciation URL'

    q_otherContentLicenceName 'Quel est le nom de la licence?',
      :display_on_certificate => true,
      :text_as_statement => 'Le contenu est disponible sous',
      :help_text => 'Si vous utilisez une licence différente, nous avons besoin de son nom pour que les gens puissent le voir sur votre certificat d\' Open Data.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Nom de licence',
      :string,
      :required => :required,
      :placeholder => 'Nom de licence'

    q_otherContentLicenceURL 'Où est la licence?',
      :display_on_certificate => true,
      :text_as_statement => 'La licence de contenu est à',
      :help_text => 'Donnez une URL à la licence, afin que les gens puissent le voir sur votre certificat d\' Open Data et vérifier qu\'il est accessible au public.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL licence',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL licence'

    q_otherContentLicenceOpen 'Est ce que la licence une licence libre?',
      :help_text => 'Si vous n\'êtes pas sûr de ce que une licence ouverte est ensuite lu le <a href="http://opendefinition.org/">Ouvert Définition de connaissances</a> définition. Ensuite, choisissez votre licence de la href="http://licenses.opendefinition.org/"> Ouvert Définition du conseil consultatif de liste des licences open <a </ a>. Si une licence n\'est pas dans leur liste, c\'est soit pas ouvert ou n\'a pas encore été évalué.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 'Vous devez <strong>publier des données ouvertes sous une licence open</strong> afin que les gens puissent l\'utiliser.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Où sont les droits et licences pour le contenu expliqués?',
      :display_on_certificate => true,
      :text_as_statement => 'Les droits et la licence du contenu sont expliquées',
      :help_text => 'Donner l\'URL d\'une page où vous décrivez comment quelqu\'un peut-il savoir les droits et licences d\'un morceau de contenu à partir des données.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'Contenu droits Description URL',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Contenu droits Description URL'

    q_copyrightStatementMetadata 'Est-ce que votre déclaration des droits de l\' inclure versions lisibles à la machine de',
      :display_on_certificate => true,
      :text_as_statement => 'La déclaration des droits de l\' renferme des données sur',
      :help_text => 'C\'est une bonne pratique à intégrer des informations sur les droits dans des formats lisibles par machine afin que les gens peuvent attribuer automatiquement ces données vers vous quand ils l\'utilisent.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'Licence données',
      :text_as_statement => 'sa licence de données',
      :requirement => ['standard_4']
    a_contentLicense 'licence de contenu',
      :text_as_statement => 'sa licence de contenu',
      :requirement => ['standard_5']
    a_attribution 'texte attribution',
      :text_as_statement => 'ce texte d\'attribution d\'utiliser',
      :requirement => ['standard_6']
    a_attributionURL 'attribution URL',
      :text_as_statement => 'quel lien d\'attribution de donner',
      :requirement => ['standard_7']
    a_copyrightNotice 'avis de copyright ou de la déclaration',
      :text_as_statement => 'un avis de droit d\'auteur ou de la déclaration',
      :requirement => ['exemplar_1']
    a_copyrightYear 'année de copyright',
      :text_as_statement => 'l\' année de copyright',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'titulaire du droit d\'auteur',
      :text_as_statement => 'le titulaire du droit d\'auteur',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'base de l\'année de droit',
      :text_as_statement => 'la base de données l\'année droit',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'titulaire du droit de base de données',
      :text_as_statement => 'le titulaire du droit de base de données',
      :requirement => ['exemplar_5']

    label_standard_4 'Vous devez fournir les données lisibles par machine <strong>dans votre déclaration des droits sur la licence</strong> pour ces données, les outils de manière automatique peuvent utiliser.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Vous devez fournir <strong>données lisibles par machine dans votre déclaration des droits sur la licence du contenu</strong> de ces données, les outils de manière automatique peuvent utiliser elle.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Vous devez fournir <strong>données lisibles par machine dans votre déclaration des droits sur le texte à utiliser lorsque l\'on cite les données</strong>, outils afin automatiques peuvent utiliser elle.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Vous devez fournir les données lisibles par machine <strong>dans votre déclaration des droits de l\' URL à utiliser lorsque l\'on cite ces données</strong>, des outils automatiques peuvent donc l\'utiliser.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Vous devez fournir <strong>données lisibles par machine dans votre déclaration des droits sur la déclaration des droits d\'auteur ou de l\'avis de ces données</strong>, outils afin automatiques peuvent utiliser elle.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Vous devez fournir les données lisibles par machine <strong>dans votre déclaration des droits sur l\'année des droits d\'auteur pour les données</strong>, des outils automatiques pour pouvoir l\'utiliser.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Vous devez fournir <strong>données lisibles par machine dans votre déclaration des droits concernant le titulaire du droit d\'auteur pour les données</strong>, des outils automatiques pour pouvoir l\'utiliser.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'Vous devez fournir les données lisibles par machine <strong>dans votre déclaration des droits sur la base de l\'année droite pour les données</strong>, outils afin automatiques peuvent utiliser.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'Vous devez fournir <strong>données lisibles par machine dans votre déclaration des droits sur le titulaire du droit de base de données pour les données</strong>, outils afin automatiques peuvent utiliser.',
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
      :text_as_statement => 'Ces données contiennent',
      :pick => :one,
      :required => :pilot
    a_not_personal 'non, ces données ne concernent pas des individus ou leurs activités',
      :text_as_statement => 'pas de données sur les personnes',
      :help_text => 'Rappelez­vous que des individus peuvent être identifiés même si les données ne les concernent pas directement. Par exemple, des données concernant le trafic routier combinées avec des données concernant les trajets quotidiens d’une personne pourraient révéler des informations sur cette personne.'
    a_summarised 'non, les données ont été rendues anonymes en agrégeant les individus dans des groupes, de sorte qu\'ils ne peuvent pas être distinguées des autres personnes dans le groupe',
      :text_as_statement => 'données agrégées',
      :help_text => 'Contrôles de divulgation statistique peuvent aider à faire en sorte que les individus ne sont pas identifiables dans les données agrégées.'
    a_individual 'oui, il existe un risque que des individus soient identifiés, par exemple par un tiers disposant d’un accès à d’autres informations',
      :text_as_statement => 'l\'information qui permettrait d\'identifier les individus',
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
      :text_as_statement => 'un audit indépendant',
      :requirement => ['standard_8']

    label_standard_8 'Vous devez <strong>avoir votre processus d\' anonymisation audit indépendant</strong> afin de s\'assurer qu\'elle réduit le risque des individus étant réidentifié.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Avez­vous tenté de réduire ou de supprimer la possibilité que des individus soient identifiés?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sur les individus a été',
      :help_text => 'L’anonymisation permet de réduire le risque que des individus soient identifiés à partir des données que vous publiez. Le choix de la meilleure technique à utiliser dépend du type de vos données.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'anonymisées'

    q_lawfulDisclosure 'Etes vous autorisés ou forcés par la loi à publier ces données concernant des individus?',
      :display_on_certificate => true,
      :text_as_statement => 'Selon la loi, ces données sur les individus',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'doit être publié',
      :requirement => ['pilot_5']

    label_pilot_5 'Vous devez <strong>seulement publier des données personnelles sans anonymisation si vous êtes tenu ou autorisé à le faire par la loi</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Où peut­on trouver des informations sur votre droit de publication d’informations personnelles?',
      :display_on_certificate => true,
      :text_as_statement => 'Le droit de publier ces données sur les individus est documentée à'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL de la déclaration',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la déclaration',
      :requirement => ['standard_9']

    label_standard_9 'Vous devez <strong>documenter votre droit de publier des données sur les personnes</strong> pour les personnes qui utilisent vos données et pour ceux qui sont touchés par la divulgation.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Avez-vous évalué les risques de divulgation de données personnelles?',
      :display_on_certificate => true,
      :text_as_statement => 'Le commissaire a',
      :help_text => 'mesure une évaluation des risques des risques pour la vie privée des personnes dans vos données, ainsi que l\' utilisation et la divulgation de cette information.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'pas effectué une évaluation des risques de la vie privée'
    a_true 'yes',
      :text_as_statement => 'a réalisé une évaluation des risques de la vie privée',
      :requirement => ['pilot_6']

    label_pilot_6 'Vous devez <strong>évaluer les risques de divulgation de données personnelles</strong> si vous publiez des données sur les personnes.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Où est publié votre évaluation des risques?',
      :display_on_certificate => true,
      :text_as_statement => 'L\'évaluation des risques est publié à',
      :help_text => 'Donnez une URL à l\'endroit où les gens peuvent vérifier comment vous avez évalué les risques de la vie privée des individus. Cela peut être expurgée ou résumée si elle contient des informations sensibles.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'Risque URL d\'évaluation',
      :string,
      :input_type => :url,
      :placeholder => 'Risque URL d\'évaluation',
      :requirement => ['standard_10']

    label_standard_10 'Vous devez <strong>publier votre évaluation des risques de la vie privée</strong> les gens puissent comprendre comment vous avez évalué les risques de données révélant.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Est-ce que votre évaluation des risques été vérifiés de manière indépendante?',
      :display_on_certificate => true,
      :text_as_statement => 'L\'évaluation des risques a été',
      :help_text => 'C\'est une bonne habitude de vérifier votre évaluation des risques a été effectuée correctement. Des audits indépendants par des spécialistes ou par des tiers ont tendance à être plus rigoureux et impartial.',
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
      :text_as_statement => 'un audit indépendant',
      :requirement => ['standard_11']

    label_standard_11 'Vous devriez avoir <strong>votre évaluation des risques audité indépendamment</strong> pour s\'assurer qu\'il a été correctement effectuée.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Où est l\'avis de confidentialité pour les personnes touchées par vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Les personnes touchées par ces données ont cet avis de confidentialité',
      :help_text => 'Lorsque vous collectez des données sur les personnes que vous devez leur dire comment ces données seront utilisées. Les personnes qui utilisent vos données en aurez besoin pour s\'assurer qu\'ils sont conformes à la législation de protection des données.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL Confidentialité',
      :string,
      :input_type => :url,
      :placeholder => 'URL Confidentialité',
      :requirement => ['pilot_7']

    label_pilot_7 'Vous devez <strong>dire aux gens quelles fins les individus de vos données consenti à vous en utilisant leurs données d\'</strong> afin qu\'ils utilisent vos données pour l\' mêmes objectifs et conformes à la législation sur la protection des données.',
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
      :text_as_statement => 'La personne responsable de la protection des données',
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
      :text_as_statement => 'a été consulté',
      :requirement => ['pilot_8']

    label_pilot_8 'Vous devez <strong>impliquer la personne responsable de la protection des données</strong> dans votre organisation avant de publier ces données.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Est-ce que votre approche de anonymisation été vérifiés de manière indépendante?',
      :display_on_certificate => true,
      :text_as_statement => 'Le anonymisation des données a été',
      :help_text => 'Il est recommandé de s\'assurer que votre processus de suppression des données personnelles identifiables fonctionne correctement. Des audits indépendants par des spécialistes ou par des tiers ont tendance à être plus rigoureux et impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'un audit indépendant',
      :requirement => ['standard_12']

    label_standard_12 'Vous devriez avoir <strong>votre processus d\' anonymisation audit indépendant</strong> par un expert pour s\'assurer qu\'il est approprié pour vos données.',
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

    q_onWebsite 'Y at-il un lien à vos données à partir de votre site principal?',
      :help_text => 'Les données peuvent être trouvés plus facilement si elle est liée à partir de votre site principal.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 'Vous devez <strong>veiller à ce que les gens peuvent trouver les données de votre site principal</strong> afin que les gens puissent trouver plus facilement.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'page Web' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'quelle page sur votre site des liens vers les données?',
        :display_on_certificate => true,
        :text_as_statement => 'Les liens de site Web pour les données de',
        :help_text => 'Donnez une URL sur votre site principal qui comprend un lien vers ces données.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'Web URL de la page',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Web URL de la page'

    end

    q_listed 'Est­ce que vos données sont listées dans une catégorie?',
      :help_text => 'Il est plus simple de trouver vos données lorsqu’elles sont listées dans des catégories pertinentes (par exemple académique, public ou santé), ou lorsqu’elles apparaissent dans des résultats de recherches pertinents.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 'Vous devez <strong>veiller à ce que les gens peuvent trouver vos données quand ils cherchent pour cela</strong> dans des endroits que les données de la liste.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listing' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Où est-il dans la liste?',
        :display_on_certificate => true,
        :text_as_statement => 'Les données apparaissent dans cette collection',
        :help_text => 'Donnez une URL où ces données est répertorié dans une collection pertinente. Par exemple, data.gov.uk (si ce n\'est UK données du secteur public ), hub.data.ac.uk (s\'il s\'agit de données du Royaume-Uni universitaires ) ou une URL pour les résultats des moteurs de recherche.',
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

    label_standard_15 'Vous devez <strong>référencer les données de vos propres publications</strong> afin que les gens sont au courant de sa disponibilité et de son contexte.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Référence' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Où est référencé vos données?',
        :display_on_certificate => true,
        :text_as_statement => 'Ces données sont référencées à partir de',
        :help_text => 'Donnez une URL à un document qui cite ou des références de ces données.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL de référence',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL de référence'

    end

    label_group_7 'Précision',
      :help_text => 'la manière dont vous gardez vos données à jour',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Est-ce que les données derrière votre changement d\' API?',
      :display_on_certificate => true,
      :text_as_statement => 'Les données sous-jacentes de l\'API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'non, l\'API donne accès à des données immuables',
      :text_as_statement => 'ne changera pas',
      :help_text => 'Certaines API juste faire accéder à un ensemble de données immuable facile, surtout quand il ya beaucoup d\'elle.'
    a_changing 'oui, l\'API donne accès à l\'évolution des données',
      :text_as_statement => 'va changer',
      :help_text => 'Certaines API donne un accès instantané à plus à jour et en constante évolution des données'

    q_timeSensitive 'Est-ce que vos données sortir de ce jour?',
      :display_on_certificate => true,
      :text_as_statement => 'la précision ou la pertinence de ces données',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'oui, ces données vont être mis à jour',
      :text_as_statement => 'sortir de la date',
      :help_text => 'Par exemple, un ensemble de données sur l\'emplacement des arrêts de bus sera mis à jour au fil du temps comme certains sont déplacés ou en créer de nouvelles.'
    a_timestamped 'oui, ces données vont être mis à jour au fil du temps mais il est temps estampillé',
      :text_as_statement => 'sortir de date, mais il est horodaté',
      :help_text => 'Par exemple, les statistiques de la population comprennent généralement un timestamp fixe pour indiquer que les statistiques étaient pertinentes.',
      :requirement => ['pilot_9']
    a_false 'non, ces données ne contient pas d\'informations sensibles au facteur temps',
      :text_as_statement => 'ne pas sortir de la date',
      :help_text => 'Par exemple, les résultats d\'une expérience n\'ira pas à jour parce que les données indique avec précision les résultats observés.',
      :requirement => ['standard_16']

    label_pilot_9 'Vous devez <strong>mettre horodateurs dans vos données lorsque vous la relâchez</strong> afin que les gens sachent la période où il concerne et quand il expire.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'Vous devez <strong>publier des mises à jour de données sensibles</strong> de sorte que cela ne va pas vicié.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Est-ce que ce changement de données au moins tous les jours?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données changements',
      :help_text => 'Dites aux gens si les modifications apportées aux données sous-jacentes sur la plupart des jours. Lorsque les données changent fréquemment, il va également être mis à jour rapidement, afin que les gens ont besoin de savoir si vous mettez à jour aussi fréquemment et rapidement aussi.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'au moins quotidiennement'

    q_seriesType 'Quel type de série de données est-ce?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont une série de',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'copies régulières d\'une base de données complète',
      :text_as_statement => 'copies d\'une base de données',
      :help_text => 'Choisissez si vous publiez des nouvelles et mises à jour des copies de votre base de données complète régulièrement. Lorsque vous créez des décharges de base de données, il est utile que les gens aient accès à une alimentation de ces changements afin qu\'ils puissent garder leurs copies à jour.'
    a_aggregate 'agrégats réguliers de l\'évolution des données',
      :text_as_statement => 'agrégats de l\'évolution des données',
      :help_text => 'Choisissez si vous créez de nouveaux ensembles de données régulièrement. Vous pouvez le faire si les données sous-jacentes ne peuvent être libérés que les données ouvertes ou si vous ne publiez que les données de neuf depuis la dernière publication.'

    q_changeFeed 'est un aliment de changements possibles?',
      :display_on_certificate => true,
      :text_as_statement => 'Une alimentation de modifications à ces données',
      :help_text => 'Dites aux gens si vous fournissez un flux de changements qui affectent ces données, comme de nouvelles entrées ou des modifications des entrées existantes. Feeds pourrait être en RSS, Atom ou formats personnalisés.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'est disponible',
      :requirement => ['exemplar_6']

    label_exemplar_6 'Vous devez <strong>fournir une alimentation de modifications à vos données</strong> afin que les gens gardent leurs copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Combien de fois avez-vous créer une nouvelle version?',
      :display_on_certificate => true,
      :text_as_statement => 'Les nouvelles versions de ces données sont',
      :help_text => 'Ceci détermine à jour ces données devient avant que les gens peuvent obtenir une mise à jour.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'moins d\'une fois par mois',
      :text_as_statement => 'moins d\'une fois par mois'
    a_monthly 'au moins tous les mois',
      :text_as_statement => 'au moins tous les mois',
      :requirement => ['pilot_10']
    a_weekly 'au moins chaque semaine',
      :text_as_statement => 'au moins chaque semaine',
      :requirement => ['standard_17']
    a_daily 'au moins chaque jour',
      :text_as_statement => 'au moins chaque jour',
      :requirement => ['exemplar_7']

    label_pilot_10 'Vous devez <strong>créer une nouvelle version du jeu de données chaque mois</strong> afin que les gens gardent leurs copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Vous devez <strong>créer une nouvelle version du jeu de données toutes les semaines</strong> afin que les gens gardent leurs copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'Vous devez <strong>créer une nouvelle version du jeu de données chaque jour</strong> afin que les gens gardent leurs copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Combien de temps est le délai entre le moment où vous créez un dataset et quand vous le publiez -il?',
      :display_on_certificate => true,
      :text_as_statement => 'Le décalage entre la création et la publication de ces données est',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'plus que l\'écart entre les versions',
      :text_as_statement => 'plus que l\'écart entre les versions',
      :help_text => 'Par exemple, si vous créez une nouvelle version du jeu de données chaque jour, choisissez cette option si elle prend plus d\'une journée pour qu\'il soit publié.'
    a_reasonable 'environ le même que l\'écart entre les versions',
      :text_as_statement => 'environ le même que l\'écart entre les versions',
      :help_text => 'Par exemple, si vous créez une nouvelle version du jeu de données chaque jour, choisissez cette option si il faut environ une journée pour qu\'il soit publié.',
      :requirement => ['pilot_11']
    a_good 'moins de la moitié de l\'écart entre les versions',
      :text_as_statement => 'moins de la moitié de l\'écart entre les versions',
      :help_text => 'Par exemple, si vous créez une nouvelle version du jeu de données chaque jour, choisissez cette option si elle prend moins de douze heures pour qu\'il soit publié.',
      :requirement => ['standard_18']
    a_minimal 'il ya peu ou pas de retard',
      :text_as_statement => 'minimes',
      :help_text => 'Choisissez cette option si vous publiez en quelques secondes ou quelques minutes.',
      :requirement => ['exemplar_8']

    label_pilot_11 'Vous devez <strong>avoir un délai raisonnable entre le moment où vous créez et publiez un ensemble de données</strong> qui est inférieur à l\'écart entre les différentes versions afin que les gens gardent leur copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Vous devez <strong>avoir un court délai entre le moment où vous créez et publiez un ensemble de données</strong> qui est moins de la moitié de l\'écart entre les différentes versions afin que les gens gardent leurs copies mises à jour et exacts.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'Vous devez <strong>avoir peu ou pas de délai entre le moment où vous créez et publiez un ensemble de données</strong> afin que les gens gardent leurs copies up-to- date et précise.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Vous publiez également des décharges de cet ensemble de données?',
      :display_on_certificate => true,
      :text_as_statement => 'Le commissaire publie',
      :help_text => 'Une sauvegarde est un extrait de l\'ensemble des données dans un fichier que l\'on peut télécharger. Cela permet aux gens de faire une analyse qui est différent de l\'analyse avec un accès API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'décharges des données',
      :requirement => ['standard_19']

    label_standard_19 'Vous devez <strong>laisser les gens télécharger l\'intégralité de votre ensemble de données</strong> afin qu\'ils puissent faire une analyse plus complète et précise à toutes les données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'À quelle fréquence voulez-vous créer une nouvelle décharge de base de données?',
      :display_on_certificate => true,
      :text_as_statement => 'dumps de base de données sont créés',
      :help_text => 'accès plus rapide aux extraits plus fréquentes de l\'ensemble des données signifie que les gens peuvent commencer plus rapide avec les données les plus à jour.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'moins d\'une fois par mois',
      :text_as_statement => 'moins d\'une fois par mois'
    a_monthly 'au moins tous les mois',
      :text_as_statement => 'au moins tous les mois',
      :requirement => ['pilot_12']
    a_weekly 'moins d\'une semaine de tout changement',
      :text_as_statement => 'moins d\'une semaine de tout changement',
      :requirement => ['standard_20']
    a_daily 'dans un jour de tout changement',
      :text_as_statement => 'dans un jour de tout changement',
      :requirement => ['exemplar_9']

    label_pilot_12 'Vous devez <strong>créer une nouvelle base de vider tous les mois</strong> afin que les gens ont les données les plus récentes.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Vous devez <strong>créer une nouvelle sauvegarde de base de données au sein d\'une semaine de tout changement</strong> afin que les gens ont moins de temps à attendre les données les plus récentes.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'Vous devez <strong>créer une nouvelle sauvegarde de base de données dans un jour de tout changement</strong> afin que les gens trouvent qu\'il est plus facile d\'obtenir l\' données les plus récentes.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'sera corrigé vos données si elle contient des erreurs?',
      :display_on_certificate => true,
      :text_as_statement => 'Toute erreur dans ces données sont',
      :help_text => 'C\'est une bonne pratique pour corriger les erreurs dans vos données, surtout si vous utilisez vous-même. Lorsque vous effectuez des corrections, les gens doivent être informés à leur sujet.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'corrigé',
      :requirement => ['standard_21']

    label_standard_21 'Vous devez <strong>corriger les données lorsque les gens signalent des erreurs</strong> Donc tout le monde bénéficie de l\'amélioration de la précision.',
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
      :text_as_statement => 'la qualité des données est documentée à',
      :help_text => 'Donnez une URL à laquelle il est possible de se renseigner sur la qualité de vos données. Les erreurs sont inévitables, et elles peuvent provenir par exemple de problèmes techniques ou d’erreurs apparaissant durant les changements de système. Nous vous recommandons d’être transparents sur la qualité de vos données, afin que les gens puissent savoir à quel point ils peuvent s’y fier.'
    a_1 'URL des documents traitant de la qualité des données',
      :string,
      :input_type => :url,
      :placeholder => 'URL des documents traitant de la qualité des données',
      :requirement => ['standard_22']

    label_standard_22 'Vous devez <strong>documenter les problèmes connus avec la qualité de vos données</strong> afin que les gens puissent décider combien de faire confiance à vos données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Où est décrit votre processus de contrôle qualité?',
      :display_on_certificate => true,
      :text_as_statement => 'les processus de contrôle de qualité sont décrits à',
      :help_text => 'Donnez une URL à laquelle les gens peuvent se rendre pour se renseigner sur les contrôles en cours sur vos données, qu’ils soient automatiques ou manuels. Cela permet de les rassurer sur votre sérieux et sur la qualité de vos données, et peut amener à des améliorations bénéfiques pour tous.'
    a_1 'URL de description du processus de contrôle qualité',
      :string,
      :input_type => :url,
      :placeholder => 'URL de description du processus de contrôle qualité',
      :requirement => ['exemplar_10']

    label_exemplar_10 'Vous devez <strong>documenter votre processus de contrôle de qualité</strong> afin que les gens puissent décider combien de faire confiance à vos données.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garanties',
      :help_text => 'a quel point les gens peuvent s’appuyer sur la disponibilité de vos données',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Prenez-vous des sauvegardes hors site?',
      :display_on_certificate => true,
      :text_as_statement => 'Les données sont',
      :help_text => 'Faire une sauvegarde hors site régulier permet de s\'assurer que les données ne seront pas perdues en cas d\' accident.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'sauvegarder hors site',
      :requirement => ['standard_23']

    label_standard_23 'Vous devez <strong>jeter un résultat sauvegarde hors site</strong> afin que les données ne seront pas perdues en cas d\'accident.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Où voulez- vous décrivez aucune garantie sur la disponibilité du service?',
      :display_on_certificate => true,
      :text_as_statement => 'La disponibilité du service est décrit au',
      :help_text => 'Donnez une URL d\'une page qui décrit ce que vous garantit avoir au sujet de votre service étant disponible pour les personnes à utiliser. Par exemple, vous pourriez avoir une garantie de disponibilité de 99,5%, ou vous pourriez fournir aucune garantie.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Disponibilité du Service Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Disponibilité du Service Documentation URL',
      :requirement => ['standard_24']

    label_standard_24 'Vous devez <strong>décrire quelles garanties vous avez autour de la disponibilité du service</strong> afin que les gens sachent combien ils peuvent compter sur elle.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Où voulez- vous donner des informations sur l\'état actuel du service?',
      :display_on_certificate => true,
      :text_as_statement => 'statut de la fonction est donnée à',
      :help_text => 'Donnez une URL d\'une page qui dit aux gens au sujet de l\'état actuel de votre service, y compris les défauts que vous êtes au courant.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'l\'état du service URL',
      :string,
      :input_type => :url,
      :placeholder => 'l\'état du service URL',
      :requirement => ['expert_1']

    label_expert_1 'Vous devez <strong>avoir une page d\'état du service</strong> qui dit aux gens au sujet de l\'état actuel de votre service.',
      :custom_renderer => '/partials/requirement_expert',
      :requirement => 'expert_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Pour combien de temps ces données seront­elles disponibles?',
      :display_on_certificate => true,
      :text_as_statement => 'Les données sont disponibles',
      :pick => :one
    a_experimental 'elles pourraient disparaître à n’importe quel moment',
      :text_as_statement => 'expérimentalement et pourraient disparaître à tout moment'
    a_short 'elles sont disponibles à titre expérimental, mais devraient être disponibles pour encore environ un an',
      :text_as_statement => 'expérimentalement pour un an ou deux',
      :requirement => ['pilot_13']
    a_medium 'elles font partie de vos plans à moyen terme et devraient être encore disponibles pour environ deux ans',
      :text_as_statement => 'pendant au moins deux ans',
      :requirement => ['standard_25']
    a_long 'elles font partie de vos opérations quotidiennes et resteront donc publiées pendant longtemps',
      :text_as_statement => 'pendant une longue période',
      :requirement => ['exemplar_11']

    label_pilot_13 'Vous devez <strong>garantir que vos données seront disponibles sous cette forme pendant au moins un an</strong> afin que les gens puissent décider combien de compter sur votre données.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Vous devez <strong>garantir que vos données seront disponibles sous cette forme dans le moyen terme</strong> afin que les gens puissent décider combien de faire confiance à vos données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_11 'Vous devez <strong>garantir que vos données seront disponibles sous cette forme dans le long terme</strong> afin que les gens puissent décider combien de faire confiance à vos données.',
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

    q_datasetUrl 'Où est votre ensemble de données?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont publiées au',
      :help_text => 'Donnez une URL pour l\'ensemble de données elle-même. Ouvrir les données devraient être liés à directement sur ​​le web afin que les gens peuvent facilement trouver et réutiliser.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dataset URL',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'Vous devez <strong>fournir une URL à vos données ou une URL à la documentation</strong> à ce sujet afin que les gens puissent le trouver.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'Vous devez <strong>avoir une URL qui est un lien direct vers les données elle-même</strong> afin que les gens puissent y accéder facilement.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Comment vous publiez faire une série du même ensemble de données?',
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'comme une URL unique qui est régulièrement mis à jour',
      :help_text => 'Choisissez cette option si il ya une URL pour les gens de télécharger la version la plus récente du jeu de données actuel.',
      :requirement => ['standard_26']
    a_template 'que les URL cohérente pour chaque version',
      :help_text => 'Choisissez cette option si votre URL de données suivent un schéma régulier qui comprend la date de publication, par exemple, une URL qui commence \'2013 - 04 \'. Cela aide les gens à comprendre comment souvent vous relâchez données et d\'écrire des scripts qui récupèrent de nouveaux à chaque fois qu\'ils sont libérés.',
      :requirement => ['pilot_15']
    a_list 'une liste des communiqués',
      :help_text => 'Choisissez cette option si vous avez une liste de bases de données sur une page Web ou d\'un aliment (comme Atom ou RSS ) avec des liens vers chaque version individuelle et ses détails. Cela aide les gens à comprendre comment souvent vous relâchez données et d\'écrire des scripts qui récupèrent de nouveaux à chaque fois qu\'ils sont libérés.',
      :requirement => ['standard_27']

    label_standard_26 'Vous devez <strong>avoir une URL unique persistant pour télécharger la version actuelle de vos données</strong> afin que les gens puissent y accéder facilement.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Vous devez <strong>utiliser un modèle cohérent pour différentes URL de presse</strong> de sorte que les gens peuvent télécharger chacun automatiquement.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'Vous devez <strong>avoir un document ou animale avec une liste des versions disponibles</strong> les gens puissent créer des scripts pour télécharger tous.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Vous devez <strong>donner accès aux versions de vos données via une URL</strong> qui donne la version actuelle, une série découverte d\'URL ou par l\'intermédiaire d\'une page de documentation afin que les gens puissent le trouver.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Où est votre ensemble de données actuel?',
      :display_on_certificate => true,
      :text_as_statement => 'Le jeu de données est disponible à l\'',
      :help_text => 'Donnez une URL unique pour la version la plus récente de l\'ensemble de données. Le contenu à cette adresse URL doit changer à chaque fois une nouvelle version est disponible.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'Dataset actuelle URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dataset actuelle URL',
      :required => :required

    q_versionsTemplateUrl 'Quel format ne suivent URL de libération de données?',
      :display_on_certificate => true,
      :text_as_statement => 'presse suivent ce modèle d\'URL cohérente',
      :help_text => 'C\'est la structure des URL lorsque vous publiez différentes versions. Utiliser ` {variable }` pour indiquer des parties de l\'URL du modèle que le changement, par exemple, ` http://example.com/data/monthly/mydata- { YY } { MM}. Csv `',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'Version Template URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version Template URL',
      :required => :required

    q_versionsUrl 'Où est votre liste de communiqués de dataset?',
      :display_on_certificate => true,
      :text_as_statement => 'Les rejets de ces données sont inscrites à',
      :help_text => 'Donnez une URL vers une page ou animale avec une liste lisible par machine de jeux de données. Utilisez l\'URL de la première page qui devrait relier au reste des pages.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'Version Liste URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version Liste URL',
      :required => :required

    q_endpointUrl 'Où se trouve le point de terminaison pour votre API?',
      :display_on_certificate => true,
      :text_as_statement => 'La terminaison de service API est',
      :help_text => 'Donnez une URL qui est un point de départ pour les scripts de personnes d\'accéder à votre API. Ce devrait être un document de description de service qui aide le script fonctionne sur lesquels il existe des services.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Endpoint URL',
      :string,
      :input_type => :url,
      :placeholder => 'Endpoint URL',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Vous devez <strong>fournir soit un URL d\'extrémité API ou une URL à sa documentation</strong> afin que les gens puissent le trouver.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Vous devez <strong>avoir un document de description de service ou de point d\'entrée unique pour votre API</strong> afin que les gens puissent y accéder.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Comment vous publiez ne dumps de base de données?',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'comme une URL unique qui est régulièrement mis à jour',
      :help_text => 'Choisissez cette option si il ya une URL pour les gens de télécharger la version la plus récente de la décharge de la base de données actuelle.',
      :requirement => ['standard_29']
    a_template 'que les URL cohérente pour chaque version',
      :help_text => 'Choisissez cette option si votre base de données dépotoir URL suivent un schéma régulier qui comprend la date de publication, par exemple, une URL qui commence \'2013 - 04 \'. Cela aide les gens à comprendre comment souvent vous relâchez données et d\'écrire des scripts qui récupèrent de nouveaux à chaque fois qu\'ils sont libérés.',
      :requirement => ['exemplar_12']
    a_list 'une liste des communiqués',
      :help_text => 'Choisissez cette option si vous avez une liste de décharges de bases de données sur une page Web ou d\'un aliment (comme Atom ou RSS ) avec des liens vers chaque version individuelle et ses détails. Cela aide les gens à comprendre comment souvent vous relâchez données et d\'écrire des scripts qui récupèrent de nouveaux à chaque fois qu\'ils sont libérés.',
      :requirement => ['exemplar_13']

    label_standard_29 'Vous devez <strong>avoir une URL unique persistant pour télécharger la décharge actuelle de votre base de données</strong> afin que les gens puissent le trouver.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_12 'Vous devez <strong>utiliser un modèle cohérent de base décharge URL</strong> afin que les gens peuvent télécharger chacun automatiquement.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_13 'Vous devez <strong>avoir un document ou animale avec une liste des dumps des bases de données disponibles</strong> les gens puissent créer des scripts pour télécharger les tous',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Où se trouve le dump de base de données actuelle?',
      :display_on_certificate => true,
      :text_as_statement => 'La dernière sauvegarde de base de données est toujours disponible au',
      :help_text => 'Donnez une URL à la déchetterie la plus récente de la base de données. Le contenu à cette adresse URL doit changer à chaque fois une nouvelle décharge de base de données est créée.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'Dump actuelle URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump actuelle URL',
      :required => :required

    q_dumpsTemplateUrl 'Quel format ne suivent base décharge URL?',
      :display_on_certificate => true,
      :text_as_statement => 'dumps de base de données suivent le modèle d\'URL cohérente',
      :help_text => 'C\'est la structure des URL lorsque vous publiez différentes versions. Utiliser ` {variable }` pour indiquer des parties de l\'URL du modèle que le changement, par exemple, ` http://example.com/data/monthly/mydata- { YY } { MM}. Csv `',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'Dump modèle URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump modèle URL',
      :required => :required

    q_dumpsUrl 'Où est votre liste de dépôts de base de données disponibles?',
      :display_on_certificate => true,
      :text_as_statement => 'Une liste des dumps de base de données est à',
      :help_text => 'Donnez une URL vers une page ou animale avec une liste lisible par machine des décharges de base de données. Utilisez l\'URL de la première page qui devrait relier au reste des pages.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'Dump liste URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump liste URL',
      :required => :required

    q_changeFeedUrl 'Où est votre flux de changements?',
      :display_on_certificate => true,
      :text_as_statement => 'Une alimentation de modifications à ces données est à',
      :help_text => 'Donnez une URL vers une page ou animale qui fournit une liste lisible par machine des versions précédentes des dumps de base de données. Utilisez l\'URL de la première page qui devrait relier au reste des pages.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'Changement URL du flux',
      :string,
      :input_type => :url,
      :placeholder => 'Changement URL du flux',
      :required => :required

    label_group_12 'Formats',
      :help_text => 'la manière dont les gens peuvent travailler avec vos données',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Vos données sont­elles lisibles par machine?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données sont',
      :help_text => 'Les gens préfèrent les formats qui sont facilement traitables par ordinateur, pour des raisons de rapidité et de précision. Par exemple, une photocopie scannée d’une feuille de calcul ne serait pas lisible par machine, contrairement à un fichier CSV.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'lisible par machine',
      :requirement => ['pilot_16']

    label_pilot_16 'Vous devez <strong>fournir vos données dans un format lisible par machine</strong> de sorte qu\'il est facile à traiter.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Vos données sont­elles dans un format open data standard?',
      :display_on_certificate => true,
      :text_as_statement => 'Le format des données est',
      :help_text => 'Les standards open data sont créés au travers d’un processus équitable, transparent et collaboratif. N’importe qui peut les mettre en place, et bénéficier de beaucoup d’assistance. Ils vous permettent donc de partager vos données plus facilement. Les formats XML, CSV et JSON sont par exemple des standards open data.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'un format standard ouvert',
      :requirement => ['standard_30']

    label_standard_30 'Vous devez <strong>fournir vos données dans un format standard ouvert</strong> afin que les gens peuvent utiliser des outils largement disponibles pour traiter plus facilement.',
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

    q_documentFormat 'Vos documents lisibles par l\'homme incluent formats',
      :display_on_certificate => true,
      :text_as_statement => 'Les documents sont publiés',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'décrire la structure sémantique comme le HTML, DocBook ou Markdown',
      :text_as_statement => 'dans un format sémantique',
      :help_text => 'Ces structures d\'étiquettes de formats comme des chapitres, des titres et des tableaux qui font qu\'il est facile de créer automatiquement des résumés comme des tables des matières et les glossaires. Ils permettent également facile à appliquer différents styles au document afin de ses changements d\'apparence.',
      :requirement => ['standard_31']
    a_format 'décrire des informations sur le formatage comme OOXML ou PDF',
      :text_as_statement => 'dans un format d\'affichage',
      :help_text => 'Ces formats apparence soulignent comme les polices, les couleurs et le positionnement des différents éléments dans la page. Ils sont bons pour la consommation humaine, mais ne sont pas aussi facile pour les gens de traiter automatiquement et changer de style.',
      :requirement => ['pilot_17']
    a_unsuitable 'ne sont pas faits pour des documents tels que Excel, CSV ou JSON',
      :text_as_statement => 'dans un format inadapté aux documents',
      :help_text => 'Ces formats de mieux répondre à des données tabulaires ou structurée.'

    label_standard_31 'Vous devez <strong>publier des documents dans un format qui expose structure sémantique</strong> afin que les gens peuvent les afficher dans des styles différents.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'Vous devez <strong>publier des documents dans un format spécialement conçu pour eux</strong> de sorte qu\'ils sont faciles à traiter.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Est-ce que vos données statistiques comprennent les formats',
      :display_on_certificate => true,
      :text_as_statement => 'Les données statistiques sont publiées',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'exposer la structure de données statistiques comme hypercube <a href="http://sdmx.org/">SDMX</a> ou <a href="http://www.w3.org/TR/vocab-data-cube/">Cube données</a>
							',
      :text_as_statement => 'dans un format de données statistiques',
      :help_text => 'observations individuelles dans hypercubes se rapportent à une mesure particulière et un ensemble de dimensions. Chaque observation peut également être liée à des annotations qui donnent contexte supplémentaire. Formats comme <a href="http://sdmx.org/">SDMX</a> et <a href="http://www.w3.org/TR/vocab-data-cube/">Cube de données</a> sont conçus pour exprimer cette structure sous-jacente.',
      :requirement => ['exemplar_14']
    a_tabular 'traiter des données statistiques sous forme de tableau comme CSV',
      :text_as_statement => 'dans un format de données tabulaires',
      :help_text => 'Ces formats organiser les données statistiques dans un tableau de lignes et de colonnes. Ce manque de contexte supplémentaires sur l\' hypercube sous-jacente mais est facile à traiter.',
      :requirement => ['standard_32']
    a_format 'se concentrer sur le format des données tabulaires comme Excel',
      :text_as_statement => 'dans un format de présentation',
      :help_text => 'Spreadsheets utilisation formatage comme du texte en italique ou en gras, et le retrait dans les champs pour décrire son apparence et la structure sous-jacente. Ce style permet aux gens de comprendre la signification de vos données, mais il est moins adapté pour les ordinateurs de processus.',
      :requirement => ['pilot_18']
    a_unsuitable 'ne sont pas destinées données statistiques ou de tableaux tels que Word ou PDF',
      :text_as_statement => 'dans un format inadapté aux données statistiques',
      :help_text => 'Ces formats ne conviennent pas à des données statistiques, car ils masquent la structure sous-jacente des données.'

    label_exemplar_14 'Vous devez <strong>publier des données statistiques dans un format qui expose dimensions et mesures</strong> de sorte qu\'il est facile à analyser.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Vous devez <strong>publier des tableaux de données dans un format qui expose des tableaux de données</strong> de sorte qu\'il est facile à analyser.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'Vous devez <strong>publier des tableaux de données dans un format conçu à cette fin</strong> de sorte qu\'il est facile à traiter.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Est-ce que vos données géographiques comprennent formats',
      :display_on_certificate => true,
      :text_as_statement => 'Les données géographiques sont publiés',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'sont conçus pour des données géographiques comme <a href="http://www.opengeospatial.org/standards/kml/">KML</a> ou <a href="http://www.geojson.org/">GeoJSON</a>
							',
      :text_as_statement => 'dans un format de données géographiques',
      :help_text => 'Ces formats décrivent des points, des lignes et des frontières, et exposent les structures dans les données qui le rendent plus facile à traiter automatiquement.',
      :requirement => ['exemplar_15']
    a_generic 'conserve les données structurées comme JSON, XML ou CSV',
      :text_as_statement => 'dans un format de données générique',
      :help_text => 'Tous les formats qui stocke des données structurées normales peut exprimer données géographiques trop, surtout si elle ne détient que des données sur les points.',
      :requirement => ['pilot_19']
    a_unsuitable 'ne sont pas conçus pour les données géographiques telles que Word ou PDF',
      :text_as_statement => 'dans un format inadapté pour les données géographiques',
      :help_text => 'Ces formats ne conviennent pas à des données géographiques, car ils masquent la structure sous-jacente des données.'

    label_exemplar_15 'Vous devez <strong>publier des données géographiques dans un format conçu à cette fin</strong> afin que les gens peuvent utiliser des outils largement disponibles pour la traiter.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'Vous devez <strong>publier des données géographiques sous forme de données structurées</strong> de sorte qu\'il est facile à traiter.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Est-ce que vos données structurées comprennent formats',
      :display_on_certificate => true,
      :text_as_statement => 'données structurées sont publiés',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'sont conçus pour les données structurées comme JSON, XML, CSV ou tortue',
      :text_as_statement => 'dans un format de données structurées',
      :help_text => 'Ces formats d\'organiser les données dans une structure de base des choses qui ont une valeur pour un ensemble connu de propriétés. Ces formats sont faciles pour les ordinateurs pour les traiter automatiquement.',
      :requirement => ['pilot_20']
    a_unsuitable 'ne sont pas conçus pour les données structurées telles que Word ou PDF',
      :text_as_statement => 'dans un format inadapté pour les données structurées',
      :help_text => 'Ces formats ne conviennent pas à ce type de données car elles masquent la structure sous-jacente.'

    label_pilot_20 'Vous devez <strong>publier des données structurées dans un format conçu à cette fin</strong> de sorte qu\'il est facile à traiter.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Vos données utilisent­elles des identifiants homogènes?',
      :display_on_certificate => true,
      :text_as_statement => 'Les données comprennent',
      :help_text => 'Les données traitent généralement de choses concrètes, comme des écoles ou des routes, ou bien utilisent un système de codage. Si des données provenant de différentes sources utilisent le même unique identifiant pour se référer aux mêmes choses de manière durable, il est facile de combiner les sources afin de créer des données plus utiles. Les identifiants peuvent être des GUIDs, des DOIs ou des URLs.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'identificateurs persistants',
      :requirement => ['standard_33']

    label_standard_33 'Vous devez <strong>utiliser des identificateurs de choses dans vos données</strong> de sorte qu\'ils peuvent être facilement reliés à d\'autres données au sujet de ces choses.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Peut les identificateurs de vos données soient utilisées pour trouver des informations supplémentaires?',
      :display_on_certificate => true,
      :text_as_statement => 'Les identificateurs persistants',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'non, les identifiants ne peut pas être utilisé pour trouver des informations supplémentaires',
      :text_as_statement => ''
    a_service 'oui, il ya un service que les gens peuvent utiliser pour résoudre les identificateurs',
      :text_as_statement => 'résoudre en utilisant un service',
      :help_text => 'services en ligne peuvent être utilisés pour donner aux gens des informations sur les identificateurs tels que GUID ou identificateurs d\'objets numériques qui ne sont pas accessibles directement dans la façon dont les URL sont.',
      :requirement => ['standard_34']
    a_resolvable 'oui, les identificateurs sont des URL qui décident de donner des informations',
      :text_as_statement => 'résoudre parce qu\'ils sont des URL',
      :help_text => 'URLs sont utiles pour les personnes et les ordinateurs. Les gens peuvent mettre un URL dans leur navigateur et de lire plus d\'informations, comme <a href="http://opencorporates.com/companies/gb/08030289">entreprises</a> et <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">codes postaux</a>. Les ordinateurs peuvent aussi traiter cette information supplémentaire en utilisant des scripts pour accéder aux données sous-jacentes.',
      :requirement => ['exemplar_16']

    label_standard_34 'Vous devez fournir <strong>un service pour résoudre les identifiants que vous utilisez</strong> de sorte que les gens peuvent trouver des informations supplémentaires à leur sujet.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_16 'Vous devez <strong>un lien vers une page web d\'information sur chacune des choses dans vos données</strong> de sorte que les gens peuvent facilement trouver et partager informations.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Où est le service qui est utilisé pour résoudre les identifiants?',
      :display_on_certificate => true,
      :text_as_statement => 'Le service de résolution de l\'identifiant est à',
      :help_text => 'Le service de résolution devrait prendre un identifiant comme un paramètre de requête et de redonner un peu d\'informations sur la chose qu\'il identifie.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'Identifier Résolution URL du service',
      :string,
      :input_type => :url,
      :placeholder => 'Identifier Résolution URL du service',
      :requirement => ['standard_35']

    label_standard_35 'Vous devez <strong>avoir une URL par lequel les identificateurs peuvent être résolus</strong> de sorte que plus d\'informations à leur sujet peut être trouvé par un ordinateur.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Y at-il des renseignements de tiers sur les choses à vos données sur le web?',
      :help_text => 'Parfois, d\'autres personnes en dehors de votre contrôle fournissent des URL pour les choses de vos données est environ. Par exemple, vos données pourraient avoir des codes postaux en elle qui pointent vers le site de l\'Ordnance Survey.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Est-ce que les renseignements de tiers fiables?',
      :help_text => 'Si une tierce partie fournit les URL publique de choses dans vos données, ils prennent probablement des mesures pour assurer la qualité et la fiabilité des données. Il s\'agit d\'une mesure de combien vous avez confiance de leurs processus pour le faire. Chercher leur certificat de données ouvert ou signes distinctifs similaires pour les aider à prendre votre décision.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Est-ce que vos données utilisent ces URL tiers?',
      :display_on_certificate => true,
      :text_as_statement => 'URL de sites tiers sont',
      :help_text => 'Vous devez utiliser des URL tierces qui résolvent des informations sur les choses que vos données décrit. Cela permet de réduire les doubles emplois et aide les gens à combiner les données provenant de différentes sources pour la rendre plus utile.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'les données citées dans le présent',
      :requirement => ['exemplar_17']

    label_exemplar_17 'Vous devez <strong>utiliser des URL à l\'information des tiers à vos données</strong> de sorte qu\'il est facile à combiner avec d\'autres données qui utilise ces URL.',
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
      :text_as_statement => 'La provenance de ces données est',
      :help_text => 'Cela concerne les origines de vos données et la manière dont elles ont été créées et traitées avant d’être publiées. Cela permet de renforcer la confiance dans les données que vous publiez, puisqu’il est facile de remonter à la source et de savoir comment elles ont été gérées.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Vous devez <strong>fournir une piste de provenance lisible par machine</strong> à propos de vos données afin que les gens puissent suivre la façon dont elle a été traitée.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'À quel endroit expliquez­vous le processus de vérification de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Ces données peuvent être vérifiées à l\'aide',
      :help_text => 'Si vous fournissez des données importantes à quelqu’un, cette personne devrait pouvoir être en mesure de vérifier que les données qu’elle a reçues sont les mêmes que celles que vous publiez. Vous pouvez par exemple signer digitalement les données que vous publiez, afin qu’il soit possible de vérifier qu’elles n’ont pas été altérées.'
    a_1 'Processus de vérification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Processus de vérification URL',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Vous devez <strong>décrire comment les gens peuvent vérifier que les données qu\'ils reçoivent est le même que ce que vous avez publié</strong> afin qu\'ils puissent lui faire confiance.',
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

    q_documentationMetadata 'Est-ce que votre documentation de données comprennent des données lisibles par machine pour:',
      :display_on_certificate => true,
      :text_as_statement => 'La documentation contient des données lisibles par machine pour',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'titre',
      :text_as_statement => 'titre',
      :requirement => ['standard_36']
    a_description 'Description',
      :text_as_statement => 'Description',
      :requirement => ['standard_37']
    a_issued 'date de sortie',
      :text_as_statement => 'date de sortie',
      :requirement => ['standard_38']
    a_modified 'Date de modification',
      :text_as_statement => 'Date de modification',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'fréquence des rejets',
      :text_as_statement => 'fréquence de sortie',
      :requirement => ['standard_40']
    a_identifier 'identificateur',
      :text_as_statement => 'identificateur',
      :requirement => ['standard_41']
    a_landingPage 'page d\'atterrissage',
      :text_as_statement => 'page d\'atterrissage',
      :requirement => ['standard_42']
    a_language 'langue',
      :text_as_statement => 'langue',
      :requirement => ['standard_43']
    a_publisher 'éditeur',
      :text_as_statement => 'éditeur',
      :requirement => ['standard_44']
    a_spatial 'couverture spatiale / géographique',
      :text_as_statement => 'couverture spatiale / géographique',
      :requirement => ['standard_45']
    a_temporal 'couverture temporelle',
      :text_as_statement => 'couverture temporelle',
      :requirement => ['standard_46']
    a_theme 'Thème (s)',
      :text_as_statement => 'Thème (s)',
      :requirement => ['standard_47']
    a_keyword 'Mot-clé (s) ou tag (s)',
      :text_as_statement => 'Mot-clé (s) ou tag (s)',
      :requirement => ['standard_48']
    a_distribution 'distribution ( s)',
      :text_as_statement => 'distribution ( s)'

    label_standard_36 'Vous devez <strong>inclure un titre de données lisibles par machine dans votre documentation</strong> afin que les gens savent comment s\'y référer.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Vous devez <strong>inclure une description des données lisibles par machine dans votre documentation</strong> afin que les gens sachent ce qu\'il contient.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Vous devez <strong>inclure une date lisible par machine des données libération dans la documentation</strong> afin que les gens sachent comment il est opportun.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Vous devez <strong>inclure une date limite lisible à la machine de modification dans la documentation</strong> afin que les gens savent qu\'ils ont données les plus récentes.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Vous devez <strong>fournir des métadonnées lisibles par machine sur la fréquence que vous relâchiez nouvelles versions de vos données</strong> afin que les gens sachent à quelle fréquence vous mettez à jour.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Vous devez <strong>inclure une URL canonique pour les données de votre documentation lisible par machine</strong> afin que les gens sachent comment y avoir accès de manière cohérente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Vous devez <strong>inclure une URL canonique de la documentation lisible par la machine elle-même</strong> afin que les gens sachent comment accéder à systématiquement.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Vous devez <strong>comprendre la langue des données dans votre documentation lisible par machine</strong> afin que les gens qui cherchent pour elle sauront s\'ils peuvent comprendre.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Vous devez <strong>indiquer l\'éditeur de données dans votre documentation lisible par machine</strong> les gens puissent décider combien de faire confiance à vos données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Vous devez <strong>inclure la couverture géographique dans la documentation lisible par machine</strong> pour que les gens comprennent où vos données s\'applique.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Vous devez <strong>inclure la période de temps dans votre documentation lisible par machine</strong> pour que les gens comprennent quand vos données s\'applique.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Vous devez <strong>inclure le sujet dans la documentation lisible par machine</strong> afin que les gens savent à peu près ce que vos données sont sur ​​.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Vous devez <strong>inclure des mots clés lisibles à la machine ou des étiquettes dans votre documentation</strong> pour aider les gens à chercher dans les données de manière efficace.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Est-ce que votre documentation comprend des métadonnées lisibles par machine pour chaque distribution sur :',
      :display_on_certificate => true,
      :text_as_statement => 'La documentation sur chaque distribution comprend des données lisibles par machine pour',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'titre',
      :text_as_statement => 'titre',
      :requirement => ['standard_49']
    a_description 'Description',
      :text_as_statement => 'Description',
      :requirement => ['standard_50']
    a_issued 'date de sortie',
      :text_as_statement => 'date de sortie',
      :requirement => ['standard_51']
    a_modified 'Date de modification',
      :text_as_statement => 'Date de modification',
      :requirement => ['standard_52']
    a_rights 'déclaration des droits',
      :text_as_statement => 'déclaration des droits',
      :requirement => ['standard_53']
    a_accessURL 'URL d\'accès aux données',
      :text_as_statement => 'une URL d\'accès aux données',
      :help_text => 'Cette méta-données doit être utilisée lorsque vos données ne sont pas disponibles en téléchargement, comme une API par exemple.'
    a_downloadURL 'URL pour télécharger l\'ensemble des données',
      :text_as_statement => 'une URL pour télécharger l\'ensemble des données'
    a_byteSize 'taille en octets',
      :text_as_statement => 'taille en octets'
    a_mediaType 'type de support de téléchargement',
      :text_as_statement => 'type de support de téléchargement'

    label_standard_49 'Vous devez <strong>inclure les titres lisibles par machine dans votre documentation</strong> afin que les gens savent comment faire référence à chaque distribution de données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Vous devez <strong>inclure des descriptions lisibles par machine dans votre documentation</strong> afin que les gens savent ce que chaque distribution de données contient.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Vous devez <strong>inclure les dates de sortie lisibles par machine dans votre documentation</strong> afin que les gens sachent comment chaque distribution actuel est.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'Vous devriez inclure <strong>lisibles par machine dernières dates de modification au sein de votre documentation</strong> afin que les gens sachent si leur copie d\'une distribution des données est en place à jour.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Vous devez <strong>inclure un lien lisible à la machine à la déclaration des droits de l\' objet</strong> les gens puissent savoir ce qu\'ils peuvent faire avec un la distribution de données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Où se trouve la documentation technique pour les données?',
      :display_on_certificate => true,
      :text_as_statement => 'La documentation technique des données est à'
    a_1 'URL de documentation technique',
      :string,
      :input_type => :url,
      :placeholder => 'URL de documentation technique',
      :requirement => ['pilot_21']

    label_pilot_21 'Vous devez <strong>fournir une documentation technique pour les données</strong> afin que les gens comprennent comment l\'utiliser.',
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

    q_schemaDocumentationUrl 'Où se trouve la documentation sur vos vocabulaires de données?',
      :display_on_certificate => true,
      :text_as_statement => 'Les vocabulaires utilisés par ces données sont documentés au'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'Schema Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Schema Documentation URL',
      :requirement => ['standard_54']

    label_standard_54 'Vous devez <strong>documenter toute vocabulaire que vous utilisez à l\'intérieur de vos données</strong> afin que les gens sachent comment l\'interpréter.',
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

    q_codelistDocumentationUrl 'Où sont tous les codes de vos données documentées?',
      :display_on_certificate => true,
      :text_as_statement => 'Les codes de ces données sont documentés au'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'Documentation de liste de codes d\'URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation de liste de codes d\'URL',
      :requirement => ['standard_55']

    label_standard_55 'Vous devez <strong>documenter les codes utilisés à l\'intérieur de vos données</strong> afin que les gens savent comment les interpréter.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Assistance',
      :help_text => 'comment vous communiquez avec les utilisateurs de vos données',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Où peut-on savoir comment contacter quelqu\'un avec des questions sur ces données?',
      :display_on_certificate => true,
      :text_as_statement => 'Découvrez comment communiquer avec quelqu\'un à propos de ces données à',
      :help_text => 'Donnez une URL d\'une page qui décrit comment les gens peuvent communiquer avec quelqu\'un si elles ont des questions sur les données.'
    a_1 'Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Contact Documentation',
      :requirement => ['pilot_22']

    label_pilot_22 'Vous devez <strong>fournir des informations de contact pour les gens à envoyer des questions</strong> de vos données vers.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'A qui peuvent s’adresser les personnes ayant des suggestions sur la manière dont vous publiez vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Découvrez comment proposer des améliorations à la publication à'
    a_1 'URL de suggestion',
      :string,
      :input_type => :url,
      :placeholder => 'URL de suggestion',
      :requirement => ['pilot_23']

    label_pilot_23 'Vous devez <strong>fournir des instructions sur la façon de suggérer des améliorations</strong> à la façon dont vous publiez des données afin que vous puissiez découvrir ce que les gens ont besoin.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Où peut-on savoir comment contacter quelqu\'un avec des questions sur la vie privée?',
      :display_on_certificate => true,
      :text_as_statement => 'savoir où envoyer des questions sur la vie privée à'
    a_1 'Confidentialité Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Confidentialité Contact Documentation',
      :requirement => ['pilot_24']

    label_pilot_24 'Vous devez <strong>fournir des informations de contact pour les gens d\'envoyer des questions sur la confidentialité</strong> et la divulgation de données personnelles à.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Utilisez­vous les réseaux et médias sociaux pour entrer en contact avec les personnes qui utilisent vos données?',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 'Vous devez <strong>utiliser les médias sociaux pour atteindre les gens qui utilisent vos données</strong> et découvrez comment vos données sont utilisées',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'compte' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Quels sont les comptes de médias sociaux peuvent vous joindre sur?',
        :display_on_certificate => true,
        :text_as_statement => 'Contactez le conservateur grâce à ces comptes de médias sociaux',
        :help_text => 'Donnez URL à vos comptes de médias sociaux, comme Twitter ou Facebook votre page de profil.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'Social URL des médias',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Social URL des médias'

    end

    q_forum 'A quel endroit est­il possible de discuter à propos de vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Discuter de ces données à',
      :help_text => 'Donnez l’adresse de votre forum ou d’une mailing list permettant de parler de vos données'
    a_1 'URL de forum ou mailing list',
      :string,
      :input_type => :url,
      :placeholder => 'URL de forum ou mailing list',
      :requirement => ['standard_57']

    label_standard_57 'Vous devez <strong>dire aux gens où ils peuvent discuter de vos données</strong> et se soutenir mutuellement.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Où peut-on savoir comment demander des rectifications à vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Découvrez comment demander des corrections de données à',
      :help_text => 'Donnez une URL où les gens peuvent rapporter des erreurs qu\'ils repèrent dans vos données.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Instructions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Instructions URL',
      :requirement => ['standard_58']

    label_standard_58 'Vous devez <strong>fournir des instructions sur la façon dont les gens peuvent rapporter des erreurs</strong> dans vos données.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Où peut-on trouver comment obtenir des notifications de corrections à vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'Découvrez comment obtenir des notifications concernant des corrections de données à',
      :help_text => 'Donnez une URL où vous décrivez comment notifications concernant les corrections sont partagées avec les gens.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction notification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction notification URL',
      :requirement => ['standard_59']

    label_standard_59 'Vous devez <strong>fournir une liste de diffusion ou animale avec les mises à jour</strong> que les gens peuvent utiliser pour conserver leurs copies de vos données à jour.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Quelqu’un est­il chargé de créer activement une communauté autour de ces données?',
      :help_text => 'Une équipe d\'engagement communautaire va s\'engager dans les médias sociaux, les blogs et organiser hackdays ou des concours pour encourager les gens à utiliser les données.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Vous devez <strong>construire une communauté de gens autour de vos données</strong> pour encourager une plus large utilisation de vos données.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Où est leur page d\'accueil?',
      :display_on_certificate => true,
      :text_as_statement => 'L\'engagement communautaire est effectué par',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'Engagement communautaire équipe URL',
      :string,
      :input_type => :url,
      :placeholder => 'Engagement communautaire équipe URL',
      :required => :required

    label_group_17 'Services',
      :help_text => 'comment vous donnez accès aux outils nécessaires pour travailler avec vos données',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'A quel endroit listez­vous les outils permettant de travailler avec vos données?',
      :display_on_certificate => true,
      :text_as_statement => 'des outils pour aider utilisent ces données sont inscrites à',
      :help_text => 'Indiquez une URL listant les outils permettant de travailler avec vos données que vous connaissez ou que vous recommandez.'
    a_1 'URL des outils',
      :string,
      :input_type => :url,
      :placeholder => 'URL des outils',
      :requirement => ['exemplar_21']

    label_exemplar_21 'Vous devez <strong>fournir une liste de bibliothèques de logiciels et d\'autres outils facilement disponibles</strong> de sorte que les gens peuvent rapidement se mettre au travail avec vos données.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end

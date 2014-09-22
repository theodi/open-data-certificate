survey 'MX',
  :full_title => 'Mexico',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>El presente cuestionario de autoevaluación genera un certificado e insignia de datos abiertos que usted puede publicar para informar al público sobre estos datos abiertos. Nosotros utilizaremos sus respuestas para determinar la manera en que las organizaciones publican los datos abiertos.</p><p>El responder estas preguntas, demuestra el esfuerzo hecho para cumplir con la legislación relativa a datos abiertos. Adicionalmente, sugerimos revise la legislación aplicable específicamente a su sector.</p><p>No es necesario reponder todas las preguntas para obtener el certificado. Responda solamente las que pueda.</p>' do

  translations :en => :default
  section_general 'Información General',
    :description => '',
    :display_header => false do

    q_dataTitle 'Coloque el título de la base de datos',
      :discussion_topic => :dataTitle,
      :help_text => 'Las personas ven el nombre de la base de datos abiertos en una lista con otros similares, por lo que debe ser lo menos ambiguo y más descriptivo posible. De manera que ellos identifiquen rápidamente lo que la hace única.',
      :required => :required
    a_1 'Título de base de datos',
      :string,
      :placeholder => 'Título de base de datos',
      :required => :required

    q_documentationUrl '¿Dónde se describe?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos se describen como',
      :help_text => 'Ofrezca un URL para que las personas lean sobre el contenido de sus datos abiertos y encuentren más detalles. Puede ser una página dentro de un catálogo más grande como data.gov.uk'
    a_1 'Documentación URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentación URL',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Usted debe tener una página web <sólida> que ofrezca documentación sobre los datos abiertos que usted publica, de manera que la gente entienda su contexto, contenido y utilidad.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Usted debe tener una página web que ofrezca documentación <sólida> y acceso a los datos abiertos que usted publica, para que las personas puedan usarlos.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Coloque el nombre de quién publica los datos',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos son publicados por',
      :help_text => 'Escriba el nombre de la organización que publica estos datos. Es probable que sea para quien usted trabaja, a menos que lo este haciendo en nombre de alguien más.',
      :required => :required
    a_1 'Publicador de datos',
      :string,
      :placeholder => 'Publicador de datos',
      :required => :required

    q_publisherUrl '¿En qué página web se publicaron los datos?',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos son publicados en',
      :help_text => 'Ofrezca un URL a un sitio web, esto nos ayuda a agrupar los datos de la misma organización; incluso si las personas registran diferentes nombres.'
    a_1 'URL de quien publica',
      :string,
      :input_type => :url,
      :placeholder => 'URL de quien publica'

    q_releaseType '¿De qué tipo de publicación se trata?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'Un lanzamiento único de un solo conjunto de datos',
      :help_text => 'Este es un archivo único y usted, actualmente, no planea publicar archivos similares en el futuro.'
    a_collection 'Un lanzamiento único de varios conjuntos de datos relacionados.',
      :help_text => 'Esta es una colección de archivos relacionados sobre los mismos datos y usted, actualmente, no planea publicar colecciones similares en el futuro.'
    a_series 'Una publicación periódica de series de conjuntos de datos relacionadas.',
      :help_text => 'Esta es una secuencia de conjuntos de datos con actualizaciones periódicas planeadas para el futuro.'
    a_service 'Un servicio o API para acceder a los datos abiertos.',
      :help_text => 'Este es un servicio web en vivo que expone los datos a los programadores, mediante una interfaz que ellos puedan consultar.'

  end

  section_legal 'Información legal',
    :description => 'Derechos, licenciamiento y privacidad' do

    label_group_2 'Derechos',
      :help_text => 'Su derecho a compartir los datos con el público.',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights '¿Sus derechos le permiten publicar estos datos como datos abiertos?',
      :discussion_topic => :mx_publisherRights,
      :help_text => 'Si su organización no es la creadora original o no estuvo a cargo de la recolección de estos datos, entonces es probable que no tenga derecho a publicarlos. Si no está seguro, verifique con el dueño de los datos debido a que necesitará su autorización para publicarlos.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'Sí. Sus derechos le permiten publicar estos datos como datos abiertos.',
      :requirement => ['standard_1']
    a_no 'No. No tiene los derechos necesarios para publicar estos datos como datos abiertos.'
    a_unsure 'No está seguro de contar con los derechos necesarios para publicar estos datos como datos abiertos.'
    a_complicated 'Los derechos relacionados con estos datos no están claros o su situación es difícil de determinar.'

    label_standard_1 'Debería tener un derecho que le permita publicar estos datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'Debe tener los derechos para publicar estos datos',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment '¿En donde detalla los riesgos que el público puede correr al utilizar estos datos?',
      :discussion_topic => :mx_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'Los riesgos que implica el uso de estos datos se encuentran descritos en',
      :help_text => 'Puede ser riesgoso que la gente utilice datos sin la debida autorización expresa. Por ejemplo, los datos pueden haber sido retirados como consecuencia de un procedimiento legal. Proporcione una URL hacia un sitio donde se describan los riesgos de utilizar estos datos.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'URL de la documentación de riesgos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la documentación de riesgos',
      :requirement => ['pilot_2']

    label_pilot_2 'Debe documentar los riesgos asociados con el uso de estos datos para que la gente pueda decidir la manera en que prefiere utilizarlos.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin '¿Los datos fueron originalmente recolectados por usted en su totalidad?',
      :discussion_topic => :mx_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos fueron',
      :help_text => 'Si cualquiera de los datos fue originado por un tercero ajeno a su organización, necesitará proporcionar información adicional sobre sus derechos de publicación.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Creado originalmente o generado por su curador'

    q_thirdPartyOrigin '¿Algunos de los datos fueron extraídos o calculados tomando como fuente otros datos?',
      :discussion_topic => :mx_thirdPartyOrigin,
      :help_text => 'Un extracto o porción, aunque mínima, de datos de terceros, sigue significando que sus derechos de uso pueden estar limitados. Si analizó los datos de terceros para producir un nuevo resultado, también pueden existir cuestiones legales a considerar.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_3']

    label_basic_3 'Ha indicado que los datos no fueron creados o recolectados originalmente por usted por lo que deben de haber sido extraídos o calculados a partir de otras fuentes.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'La totalidad de las fuentes de estos datos ¿se encuentran publicadas como datos abiertos?',
      :discussion_topic => :mx_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos han sido creados a partir de',
      :help_text => 'Puede volver a publicar los datos de alguien más si dichos datos ya se encuentran bajo una licencia de datos abiertos o si los derechos de dicha persona han caducado o exentos. Si alguna parte de estos datos no cumple con lo anterior, deberá buscar asesoría legal antes de poder publicarlos.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'fuentes de datos abiertos',
      :requirement => ['basic_4']

    label_basic_4 'Se recomienda buscar asesoría legal para cerciorarse de que tiene el derecho de publicar estos datos.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced '¿Alguna parte de estos datos fue obtenida a través de un esfuezo colectivo?',
      :discussion_topic => :mx_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'Algunos de estos datos son',
      :help_text => 'Si los datos incluyen información aportada por personas ajenas a su organización, necesitará su autorización para publicar dichas contibuciones como datos abiertos.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'obtenidos mediante colaboración colectiva',
      :requirement => ['basic_5']

    label_basic_5 'Ha indicado que los datos no fueron creados o recopilados orignalmente por usted por lo que en consecuencia deben de haber sido obtenidos mediante colaboración colectiva.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Las personas que contribuyeron ¿usaron su juicio?',
      :discussion_topic => :mx_crowdsourcedContent,
      :help_text => 'Si los datos son producto de la creatividad o juicio de quien los aportó, entonces dichas personas tienen la titularidad sobre ellos. Por ejemplo, realizar una descripción o decidir sobre la pertinencia de incluir o no incluir undato en particular, implica hacer un juicio. En consecuencia, los colaboradores deben transferirle o licenciarle sus derechos para que usted pueda publicar sus aportaciones.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl '¿Donde encuentro el acuerdo de licencia para colaboradore (ALC)s?',
      :discussion_topic => :mx_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El acuerdo de licencia para colaboradores está en',
      :help_text => 'Proporcione un enlace hacia un acuerdo que demuestre que los colaboradores le autorizan a utilizar sus datos. Un ALC le transmitirá los derechos del colaborador o se los licenciará para que usted pueda publicarlos.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'URL del acuerdo de licencia para colaboradores',
      :string,
      :input_type => :url,
      :placeholder => 'URL del acuerdo de licencia para colaboradores',
      :required => :required

    q_cldsRecorded '¿Todos los colaboradores están de acuerdo con el acuerdo de licencia para colaboradores ALC?',
      :discussion_topic => :mx_cldsRecorded,
      :help_text => 'Verifique que todos los colaboradores estén de acuerdo con el ALC antes de reutilizar o publicar sus contribuciones. Le sugerimos mantener un registro de quienes hayan colaborado y si están de acuerdo o no con el ALC.',
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

    label_basic_6 'Debe obtener el acuerdo de los colaboradores con el ALC que le otorgue el derecho de publicar su obra como datos abiertos.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl '¿Donde describe el origen de los datos?',
      :discussion_topic => :mx_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El origen de los datos se decribe en',
      :help_text => 'Proporcione una URL que documente el origen de los datos y los derechos que sustentan su publicación. Esto ayudará a la gente a entender de donde vienen los datos.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'URL de la documentación de origen de los datos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la documentación de origen de los datos',
      :requirement => ['pilot_3']

    label_pilot_3 'Debería documentar el origen de los datos y los derechos que amparan su publicación para que la gente tenga la certeza de que puede utilizar las aportaciones hechas por terceros.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata '¿Está disponible en formato legible por máquina la documentación sobre el origen de los datos?',
      :discussion_topic => :mx_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'El curador ha publicado',
      :help_text => 'La información sobre el origen de los datos debe estar disponible tanto en un formato legible por seres humanos para que la gente pueda entenderlo, así como a través de metadatos que puedan procesar las computadoras. Cuando se hace esto, ayuda a otras personas a entender como un mismo dato se utiliza y justifica su reutilización.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'datos legibles por máquina sobre el origen de los datos',
      :requirement => ['standard_2']

    label_standard_2 'Debería incluir información sobre el origen de los datos en formato legible por máquinas.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Licenciamiento',
      :help_text => '¿Cómo autoriza al público a usar estos datos?',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL '¿En dónde publicó la declaración sobre derechos para este conjunto de datos?',
      :discussion_topic => :mx_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'La declaración sobre derechos está en',
      :help_text => 'Proporcione la URL hacia la página donde describe los derechos para reutilizar este conjunto de datos. Dicha página debería incluir una referencia a su licencia, los requisitos de atribución y cita, así como una declaración sobre los derechos de autor que resulten relevantes. Una declaración de derechos ayuda a que la gente entienda qué es lo que puede y qué es lo que no puede hacer con los datos.'
    a_1 'URL de la declaración sobre derechos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la declaración sobre derechos',
      :requirement => ['pilot_4']

    label_pilot_4 'Debería publicar una declaración de derechos que detalle los derechos de autor, licenciamiento y la manera en que el público debe reconocer y citar la autoría de los datos.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence '¿Bajo qué licencia puede el público reutilizar los datos?',
      :discussion_topic => :mx_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos están disponibles bajo',
      :help_text => 'Recuerde que todo aquél que realiza un esfuerzo intelectual para crear contenidos, automáticamente obtiene derechos sobre dichos contenidos. La selección y organización de datos (no así de hechos) es una forma de creación. En consecuencia, la gente necesita una licencia o autorización en donde conste y se sustente legalmente que pueden utilizar los datos. A continuación enlistamos las licencias más comunes. Si los datos no están sujetos a derechos, los derechos han caducado o el titular ha renunciado a sus derechos, seleccione "No aplicable"',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_odc_by 'Licencia de reconocimento Open Data Commons',
      :text_as_statement => 'Licencia de reconocimento Open Data Commons'
    a_odc_odbl 'Licencia de base de datos abierta Open Data Commons',
      :text_as_statement => 'Licencia de base de datos abierta Open Data Commons'
    a_odc_pddl 'Licencia de dedicatoria al dominio público Open Data Commons',
      :text_as_statement => 'Licencia de dedicatoria al dominio público Open Data Commons'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_na 'No aplicable',
      :text_as_statement => 'No aplicable'
    a_other 'Otros…',
      :text_as_statement => 'Otros…'

    q_dataNotApplicable '¿Por qué no aplica ninguna licencia a estos datos?',
      :discussion_topic => :mx_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos no se encuentran licenciados por',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'Estos datos no están sujetos a derechos de autor',
      :text_as_statement => 'No están sujetos a derechos de autor',
      :help_text => 'Los derechos de autor aplican solamente si se realizó un esfuerzo creativo relacionado con los datos como por ejemplo escribir algún texto dentro de los datos o decidir si un dato en particular debe ser o no incluido. Si los datos se refieren únicamente a hechos o cifras sin que sean producto de un proceso creativo, entonces no les aplica la protección del derecho de autor.'
    a_expired 'Los derehos de autor han caducado',
      :text_as_statement => 'Los derechos de autor han caducado',
      :help_text => 'Los derechos patrimoniales tienen una vigencia determinada que corre a partir de la muerte del autor o, en algunos casos, a partir de la publicación de la obra. Debe verificar la fecha en que el contenido fue publicado porque si eso sucedió hace mucho tiempo, es posible que los derechos sobre el mismo hayan caducado.'
    a_waived 'El derecho de autor ha sido exentado',
      :text_as_statement => '',
      :help_text => 'Esto significa que nadie tiene derechos sobre los datos y cualquier persona puede hacer lo que quiera con los mismos.'

    q_dataWaiver '¿Qué método utiliza para exentar los derechos sobre los datos?',
      :discussion_topic => :mx_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Los derechos sobre los datos han sido exentos mediante',
      :help_text => 'Necesita una declaración para hacer saber a la gente que hacer saber a la gente que ha renunciado a sus derechos para que a su vez ellos puedan hacer lo que deseen con los datos. Existen formatos estándar como la PDDL o la CCZero pero también puede usted redactar el suyo con la debida asesoría legal.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_odc_pddl 'Licencia de dedicatoria al dominio público Open Data Commons',
      :text_as_statement => 'Licencia de dedicatoria al dominio público Open Data Commons'
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Otros…',
      :text_as_statement => ''

    q_dataOtherWaiver '¿dónde se ubica la exención sobre los derechos de los datos?',
      :discussion_topic => :mx_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Los derechos sobre los datos han sido exentos mediante',
      :help_text => 'Proporcione una URL para su formato de renuncia a fin de que la gente pueda verificar que efectivamente exenta los derechos relativos a los datos.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'URL de la exención',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL de la exención'

    q_otherDataLicenceName '¿cuál es el nombe de la licencia?',
      :discussion_topic => :mx_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos están disponibles bajo',
      :help_text => 'Si utiliza una licencia diferente, nos debe proporcionar el nombre de la licencia para que la gente pueda verlo en su certificado de Datos Abiertos',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Otro nombre de licencia',
      :string,
      :required => :required,
      :placeholder => 'Otro nombre de licencia'

    q_otherDataLicenceURL '¿dónde está esta licencia?',
      :discussion_topic => :mx_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Esta licencia se encuentra en',
      :help_text => 'Proporcione una URL a la licencia para que la gente pueda verla en su certificado de Datos Abiertos y verificar que está disponible al público.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'URL de otras licencias',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL de otras licencias'

    q_otherDataLicenceOpen 'La licencia ¿es una licencia abierta?',
      :discussion_topic => :mx_otherDataLicenceOpen,
      :help_text => 'Si no está seguro sobre lo que significa una licencia abierta, lea la lista de licencias abiertas de la Open Definition Advisory Board. Si no encuentra su licencia en esa lista puede ser que la misma no sea una licencia abierta o que no haya sido evaluada aún.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_7']

    label_basic_7 'Debe publicar los datos abiertos bajo una licencia abierta a fin de que la demás gente pueda utilizarlos',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights '¿Existe algún tipo de derehco de autor en estos datos?',
      :discussion_topic => :mx_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Existen',
      :pick => :one,
      :required => :required
    a_norights 'No, los datos solamente contienen hechos y cifras',
      :text_as_statement => 'ningún derecho sobre el contenido de los datos',
      :help_text => 'Los hechos no están sujetos a derecho de autor. Cuando los datos no abarcan contenido creado a partir de un esfuerzo intelectual, no están sujetos a derechos de autor.'
    a_samerights 'Sí y los derechos le corresopnden a una sola persona u organización',
      :text_as_statement => '',
      :help_text => 'Elija esta opción si el contenido de los datos fue creado o cedido a una misma persona u organización'
    a_mixedrights 'Sí y los derechos le corresponden a diferentes personas u organizaciones',
      :text_as_statement => '',
      :help_text => 'En algunos casos, los derechos sobre diferentes registros le corresponden a diversas personas u organizaciones. Es necesario incluir la información relativa a los derechos en los datos mismos.'

    q_explicitWaiver '¿Los datos y su contenido están marcados como del dominio público?',
      :discussion_topic => :mx_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'El contenido ha sido',
      :help_text => 'El contenido puede ser etiquetado como del dominio público utilizando la insignia de <a href="http://creativecommons.org/publicdomain/">Dominio Público de Creative Commons</a>. Esto ayudará a que la gente identifique que los datos pueden ser utilizados libremente.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Identificado como del dominio público',
      :requirement => ['standard_3']

    label_standard_3 'Debería etiquetar como del dominio púbico aquél contenido que se encuentre en el dominio público para que la gente sepa que puede reutilizarlo.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence '¿Bajo qué licencia puede utilizarse el contenido por terceros?',
      :discussion_topic => :mx_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'El contenido se encuentra disponible bajo',
      :help_text => 'Recuerde que todo aquél que realice un esfuerzo intelectual para crear contenidos, automáticamente obtiene derechos sobre dichos conteidos. En consecuencia la gente necesita una licencia o autorización en donde conste y se sustente legalmente que pueden utilizar los datos. A continuación enlistamos las licencias más comunes; Si los datos no están sujetos a derechos, los derechos han caducado o el titular ha renunciado a sus derechos, seleccione "No aplicable"',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Reconocimiento Creative Commons',
      :text_as_statement => 'Reconocimiento Creative Commons'
    a_cc_by_sa 'Reconocimiento-Compartir igual Creative Commons',
      :text_as_statement => 'Reconocimiento-Compartir igual Creative Commons'
    a_cc_zero 'CCZero Creative Commons',
      :text_as_statement => 'CCZero Creative Commons'
    a_na 'No aplicable',
      :text_as_statement => ''
    a_other 'Otra…',
      :text_as_statement => ''

    q_contentNotApplicable '¿Por qué no aplica ninguna licencia al contenido de los datos?',
      :discussion_topic => :mx_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'La información contenida en los datos no está licenciada por',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'El contenido de los datos no está sujeto a derechos de autor',
      :text_as_statement => 'No tiene derechos de autor',
      :help_text => 'Los derechos de autor aplican solamente si se realizó un esfuerzo creativo relacionado con los datos como por ejemplo escribir algún texto dentro de los datos . Si los datos se refieren únicamente a hechos, entonces no les aplica la protección del derecho de autor.'
    a_expired 'Los derechos de autor han caducado',
      :text_as_statement => 'Los derechos de autor han caducado',
      :help_text => 'Los derechos patrimoniales tienen una vigencia determinada que corre a partir de la muerte del autor o, en algunos casos, a partir de la publicación de la obra. Debe verificar la fecha en que el contenido fue publicado porque si eso sucedió hace mucho tiempo, es posible que los derechos sobre el mismo hayan caducado.'
    a_waived 'Los derechos de autor han sido exentados.',
      :text_as_statement => '',
      :help_text => 'Esto significa que nadie tiene derechos sobre los datos y cualquier persona puede hacer lo que quiera con los mismos.'

    q_contentWaiver '¿Qué método utiliza para exentar los derechos sobre los datos?',
      :discussion_topic => :mx_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Los derechos de autor han sido exentados mediante',
      :help_text => 'Necesita una declaración para hacer saber a la gente que ha hecho esto y que a su vez ellos puedan hacer lo que deseen con los datos. Existen formatos estándar como la CCZero pero también puede usted redactar su propio formato con la asesoría legal debida.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'CCZero Creative Commons',
      :text_as_statement => 'CCZero Creative Commons'
    a_other 'Otro…',
      :text_as_statement => 'Otro…'

    q_contentOtherWaiver '¿dónde se ubica la exención sobre los derechos de los datos?',
      :discussion_topic => :mx_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Los derechos de autor han sido exentados mediante',
      :help_text => 'Proporcione una URL para su formato de renuncia a fin de que la gente pueda verificar que efectivamente exenta los derechos relativos a los datos.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'URL de la exención',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL de la exención'

    q_otherContentLicenceName '¿cuál es el nombe de la licencia?',
      :discussion_topic => :mx_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'El contenido se encuentra disponible bajo',
      :help_text => 'Si utiliza una licencia diferente, nos debe proporcionar el nombre de la licencia para que la gente pueda verlo en su certificado de Datos Abiertos',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Nombre de la licencia',
      :string,
      :required => :required,
      :placeholder => 'Nombre de la licencia'

    q_otherContentLicenceURL '¿dónde está esta licencia?',
      :discussion_topic => :mx_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'La licencia del contenido se encuentra en',
      :help_text => 'Proporcione una URL a la licencia para que la gente pueda verla en su certificado de Datos Abiertos y verificar que está disponible al público.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL de la licencia',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL de la licencia'

    q_otherContentLicenceOpen 'La licencia ¿es una licencia abierta?',
      :discussion_topic => :mx_otherContentLicenceOpen,
      :help_text => 'Si no está seguro sobre lo que significa una licencia abierta, lea la lista de licencias abiertas de la Open Definition Advisory Board. Si no encuentra su licencia en esa lista puede ser que la misma no sea una licencia abierta o que no haya sido evaluada',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 'Debe publicar los datos abiertos bajo una licencia abierta a fin de que la demás gente pueda utilizarlos',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL '¿dónde se ubica la explicación sobre los derechos y licenciamiento del contenido?',
      :discussion_topic => :mx_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'Hay una explicación sobre los derechos y licencia de los contenidos en',
      :help_text => 'Proporcione la URL al sitio donde explique la manera en que un tercero puede obtener más información acerca de los derechos y licenciamiento relativos a una parte específica del contenido',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'URL de la descripción sobre los derechos de los contenidos',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL de la descripción sobre los derechos de los contenidos'

    q_copyrightStatementMetadata 'Su declaración sobre derechos ¿incluye una versión legible por máquinas?',
      :discussion_topic => :mx_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La declaración sobre derechos incluye información acerca de',
      :help_text => 'Es una buena práctica embeber información relativa a los derechos en formatos legibles por máquinas para que la gente pueda reconocerle automáticamente la titularidad de los derechos sobre los datos.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'licencia de datos',
      :text_as_statement => 'su licencia de datos',
      :requirement => ['standard_4']
    a_contentLicense 'licencia de contenido',
      :text_as_statement => 'su licencia de contenido',
      :requirement => ['standard_5']
    a_attribution 'texto para reconocimiento',
      :text_as_statement => 'que texto para reconocimiento usar',
      :requirement => ['standard_6']
    a_attributionURL 'URL del reconocimiento',
      :text_as_statement => '¿qué enlace proporcionar para el reconocimiento?',
      :requirement => ['standard_7']
    a_copyrightNotice 'Aviso sobre derechos de autor o declaración',
      :text_as_statement => 'Un aviso sobre derechos de autor o declaración',
      :requirement => ['exemplar_1']
    a_copyrightYear 'Año de los derechos de autor',
      :text_as_statement => 'Año de los derechos de autor',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'Titular de los derechos',
      :text_as_statement => 'El titular de los derechos',
      :requirement => ['exemplar_3']

    label_standard_4 'Debería proporcionar una versión legible por máquinas de su declaración sobre derechos de los datos para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Debería proporcionar una versión legible por máquinas de su declaración sobre derechos de los contenidos para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Debería proporcionar una versión legible por máquinas en su declaración sobre derechos acerca del texto que debe utilizarse para citar los datos para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Debería proporcionar una versión legible por máquinas en su declaración sobre derechos acerca de la URL que debe utilizarse para citar los datos para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Debería proporcionar una versión legible por máquinas en su declaración sobre derechos acerca de la declaracón de derechos de autor o el aviso relativo para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Debería proporcionar una versión legible por máquinas en su declaración sobre derechos acerca de la fecha de los derechos de autor para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Debería proporcionar una versión legible por máquinas en su declaración sobre derechos acerca del titular de los derechos sobre los datos para que herramientas automatizadas puedan aprovecharla.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_group_4 'Privacidad',
      :help_text => '¿Cómo protege la privacidad de la gente?',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal '¿Es posible identificar individuos mediante estos datos?',
      :discussion_topic => :mx_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos contienen',
      :pick => :one,
      :required => :pilot
    a_not_personal 'No, los datos no tratan sobre personas o sus actividades',
      :text_as_statement => 'Ningún dato sobre individuos',
      :help_text => 'Recuerde que las personas pueden ser identificadas aún cuando los datos no estén directamente relacionados con ellas. Por ejemplo, los datos sobre flujo de tránsito combinados con la costumbre de transporte de una persona, podría identificar a la persona.'
    a_summarised 'No, los datos han sido disociados y anonimizados, agrupándolos a fin de que los individuos que conforman el grupo no puedan ser identificados.',
      :text_as_statement => 'datos agregados',
      :help_text => 'Establecer controles sobre la revelación estadística puede contribuir a asegurarse que las personas no puedan ser identificadas en lo individual a partir de la agregación de datos'
    a_individual 'Sí, existe el riesgo de que algunos individuos puedan ser identificados por terceros que tengan acceso a información adicional, por ejemplo.',
      :text_as_statement => 'información que pudiera identificar individuos',
      :help_text => 'Algunos datos se refieren a información pública sobre individuos, como es el caso del pago de contribuciones o gastos públicos.'

    q_statisticalAnonAudited 'Su proceso de anonimización ¿ha sido auditado por un auditor independiente?',
      :discussion_topic => :mx_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'El proceso de anonimización ha sido',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'auditado por un auditor independiente',
      :requirement => ['standard_8']

    label_standard_8 'Debería auditar su proceso de anonimización por un auditor independiente a fin de asegurar que reduce el riesgo de que las personas puedan ser identificadas individualmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon '¿Ha intentado reducir o eliminar la posibilidad de que las personas puedan ser identificadas en lo individual?',
      :discussion_topic => :mx_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos sobre individuos han sido',
      :help_text => 'La anonimización reduce el riesgo de que las personas sean identificadas en lo individual a partir de los datos que publique. La técnica adecuada dependerá del tipo de datos que maneje.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Anonimizados'

    q_lawfulDisclosure '¿La ley le obliga o le permite publicar estos datos acerca de individuos?',
      :discussion_topic => :mx_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Por ley, estos datos sobre individuos',
      :help_text => 'Debería publicar datos personales únicamente cuando la ley lo obligue o se lo permita.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'deben ser publicados',
      :requirement => ['pilot_5']

    label_pilot_5 '
                     <strong></strong>
                  ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL '¿En dónde documenta el derecho que tiene para publicar estos datos personales?',
      :discussion_topic => :mx_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'El derecho a publicar estos datos personales se encuentra documentado en'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL de la justificación sobre revelación',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la justificación sobre revelación',
      :requirement => ['standard_9']

    label_standard_9 'Debería documentar su derecho a publicar datos personales para enterar a las personas que los utilicen así como a los posibles afectados por su revelación.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists '¿Ha evaluado los riesgos de revelar datos personales?',
      :discussion_topic => :mx_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'El curador ha',
      :help_text => 'Una evaluación de riesgos mide los riesgos a la privacidad de las personas en relación con sus datos así como con respecto al uso y revelación de dicha información',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'no realizó una evaluación de riesgos de privacidad'
    a_true 'yes',
      :text_as_statement => 'realizó una evaluación de riesgos de privacidad',
      :requirement => ['pilot_6']

    label_pilot_6 'Debería evaluar los riesgos de revelar datos personales si publica datos sobre personas en lo individual.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl '¿dónde se ubica publicada su evaluación de riesgos?',
      :discussion_topic => :mx_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La evaluaición de riesgos se encuentra publicada en',
      :help_text => 'Proporcione una URL en donde la gente pueda verificar la manera en que ha evaluado los riesgos de privacidad para los individuos. Dicha evaluación puede redactarse en extenso o de manera resumida en caso de contener información sensible.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL de la evaluación de riesgos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la evaluación de riesgos',
      :requirement => ['standard_10']

    label_standard_10 'Debería publicar su evaluación de riesgos de privacidad para que la gente pueda entender que ha evaluado los riesgos relacionados con la revelación de los datos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Su evaluación de riesgos ¿ha sido auditada por un auditor independiente?',
      :discussion_topic => :mx_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'La evaluación de riesgos ha sido',
      :help_text => 'Es una buena práctica verificar que su evaluación de riesgos fue hecha adecuadamente. Las auditorías realizadas por auditores independientes o terceros ajenos a su empresa suelen ser más rigurosas e imparciales.',
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
      :text_as_statement => 'auditado por un auditor independiente',
      :requirement => ['standard_11']

    label_standard_11 'Debería auditar su evaluación de riesgos para asegurar que ha sido realizada de manera adecuada.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_anonymisationAudited '¿Ha realizado una auditoría independiente a su método de anonimización?',
      :discussion_topic => :mx_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'La anonimización de los datos ha sido',
      :help_text => 'Es una buena práctica asegurarse que su proceso para eliminar datos personales identificables funcione correctamente. Las auditorías realizadas por auditores independientes o terceros ajenos a su empresa suelen ser más rigurosas e imparciales.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'auditado por un auditor independiente',
      :requirement => ['standard_12']

    label_standard_12 'Debería auditar su proceso de anonimización por un auditor independiente para asegurarse de que es el apropiado para los datos que maneja.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Información práctica',
    :description => 'Facilidad de localización, precisión, calidad y garantía' do

    label_group_6 'Facilidad de localización.',
      :help_text => '¿Cómo ayuda a las personas a encontrar sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite '¿Existe un enlace hacia estos datos abiertos desde su sitio web principal?',
      :discussion_topic => :onWebsite,
      :help_text => 'Los datos pueden ser encontrados más fácilmente si cuentan con un enlace desde su sitio web principal.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 'Usted debe asegurar que las personas puedan encontrar sus datos desde su sitio web principal, de manera que las personas puedan encontrarlos más fácilmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Página web' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage '¿Qué página en su sitio web enlaza con los datos?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'El sitio web enlaza con los datos de',
        :help_text => 'Ofrezca un URL en sitio web principal que incluya una liga a estos datos.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'URL de la página web',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL de la página web'

    end

    q_listed '¿Están sus datos enlistados dentro de alguna colección de bases de datos?',
      :discussion_topic => :listed,
      :help_text => 'Los datos son encontrados más fácilmente por las personas cuando están en catálogos de datos relevantes. Por ejemplo, académicos, del sector público, de salud; o cuando aparecen en resultados de investigaciones relevantes.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 'Usted debería asegurar que las personas puedan encontrar sus datos cuando los busquen en lugares que enlistan datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listado' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing '¿En dónde son enlistados?',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'Los datos aparecen en esta colección.',
        :help_text => 'Ofrezca un URL donde los datos sean enlistados dentro de una colección relevante. Por ejemplo, data.gov.uk (si se trata de datos del sector público de Reino Unido), hub.data.ac.uk (si se trata de datos académicos del Reino Unido) o un URL para los resultados de motores de búsqueda.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'URL del listado',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL del listado'

    end

    q_referenced '¿Son estos datos referidos en publicaciones suyas?',
      :discussion_topic => :referenced,
      :help_text => 'Cuando usted hace referencia a sus datos dentro de sus propias publicaciones, como son reportes, presentaciones o publicaciones en blogs; usted aporta mayor contexto y ayuda a las personas a encontrarlos y entenderlos mejor.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_15']

    label_standard_15 'Usted debería hacer referencia a sus datos desde sus propias publicaciones, para que las personas estén al tanto de su disponibilidad y su contexto.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Referencia' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference '¿En dónde se hace referencia a estos datos?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Estos datos son referidos de',
        :help_text => 'Ofrezca un URL a un documento en el que se citen o refieran estos datos.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL de referencia',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL de referencia'

    end

    label_group_7 'Precisión',
      :help_text => '¿Cómo mantiene sus datos actualizados?',
      :customer_renderer => '/partials/fieldset'

    q_serviceType '¿Los datos que están detrás de su API cambian?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos detrás la API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'No, la API da acceso a datos estáticos',
      :text_as_statement => 'No van a cambiar',
      :help_text => 'Algunas API sólo facilitan el acceso a datos que no cambian, particularmente cuando hay muchos de estos.'
    a_changing 'Sí, la API proporciona acceso a datos que cambian',
      :text_as_statement => 'Cambiarán',
      :help_text => 'Algunas API proporcionan acceso instantáneo a datos más actualizados y siempre cambiantes'

    q_timeSensitive '¿Los datos de usted caducarán?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'La precisión o la relevancia de estos datos',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'Sí, estos datos expirarán',
      :text_as_statement => 'Caducan',
      :help_text => 'Por ejemplo, un conjunto de datos sobre las paradas de autobús expirará cuando éstas cambien o se agreguen otras nuevas.'
    a_timestamped 'Sí, estos datos expirarán en un futuro, pero estan temporalizados',
      :text_as_statement => 'Expiran pero están temporalizados',
      :help_text => 'Por ejemplo, la estadísticas de población usualmente incluyen una temporalidad fija para indicar cuándo éstas son relevantes',
      :requirement => ['pilot_7']
    a_false 'No, estos datos no contienen ninguna información sensible al tiempo',
      :text_as_statement => 'No expiran',
      :help_text => 'Por ejemplo, los resultados de un experimento no expirarán porque los datos precisos reportan los resultados observados',
      :requirement => ['standard_16']

    label_pilot_7 'Usted debería indicar la temporalidad de sus datos cuando los lance, para que las personas conozcan el periodo al que se relacionan y cuando caducarán.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'Usted debería publicar actualizaciones de los datos sensibles al tiempo, para que estos no se vuelvan obsoletos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges '¿Estos datos cambian mínimo diariamente?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos cambien',
      :help_text => 'Informe a las personas si los datos subyacentes cambian la mayoría de los días. Cuando los datos cambian con frecuencia también expiran rápido, entonces las personas necesitan si usted actualizada frecuente y rápidamente.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Mínimo diariamente'

    q_seriesType '¿Qué tipo de serie de conjuntos de datos es ésta?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos son una serie de',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'Copias regulares de un conjunto de datos completa',
      :text_as_statement => 'Copias de una base da datos',
      :help_text => 'Seleccione si publica nuevas copias, actualizadas y completas de sus conjuntos de datos. Cuando usted crea un dump de bases de datos, es útil para las personas tener acceso a una fuente de los cambios, para que puedan guardar sus copias actualizadas.'
    a_aggregate 'Agregados regulares de datos cambiantes',
      :text_as_statement => 'Agregados de datos cambiantes',
      :help_text => 'Seleccione si usted crea nuevos conjuntos de datos regularmente. Usted puede hacer esto si los datos subyacentes no pueden ser lanzados como datos abiertos o si usted sólo publica datos que sean nuevos desde la última publicación.'

    q_changeFeed '¿Está disponible una fuente de cambios?',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'Una fuente de los cambios de estos datos',
      :help_text => 'Informe a las personas si usted provee cambios que afecten los datos, como nuevas entradas o enmiendas a entradas existentes. Las fuentes pueden estar en formatos RSS, Atom o personalizados.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Está disponible',
      :requirement => ['exemplar_4']

    label_exemplar_4 'Usted debería proveer una fuente de cambios de sus datos, para que las personas guarden sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication '¿Con qué frecuencia usted crea nuevos lanzamientos?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Nuevos lanzamientos de estos datos se hacen',
      :help_text => 'Esto determina cuan caducos los datos se tornarán antes de que las personas puedan obtener una actualización.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'Menos de una vez al mes',
      :text_as_statement => 'Menos de una vez al mes'
    a_monthly 'Por lo menos una vez al mes',
      :text_as_statement => 'Por lo menos una vez al mes',
      :requirement => ['pilot_8']
    a_weekly 'Al menos una vez a la semana',
      :text_as_statement => 'Al menos una vez a la semana',
      :requirement => ['standard_17']
    a_daily 'Por lo menos una vez al día',
      :text_as_statement => 'Por lo menos una vez al día',
      :requirement => ['exemplar_5']

    label_pilot_8 'Usted debería crear un nuevo lanzamiento de conjunto de datos cada mes, para que las personas guarden sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Usted debería crear un nuevo lanzamiento de conjunto de datos cada semana, para que las personas guarden sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_5 'Usted debería crear un nuevo lanzamiento de conjunto de datos cada día, para que las personas puedan guardar sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay '¿Qué tan larga es la demora entre la creación sus bases de datos y su publicación estas?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'La demora entre la creación y la publicación de estos datos es',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'Mayor a la brecha entre lanzamientos',
      :text_as_statement => 'Mayor a la brecha entre lanzamientos',
      :help_text => 'Por ejemplo, si usted crea una nueva versión de conjuntos de datos todos los días, elija esto si le toma más de un día en publicarlos.'
    a_reasonable 'Aproximadamente lo mismo que la brecha entre lanzamientos',
      :text_as_statement => 'Aproximadamente lo mismo que la brecha entre lanzamientos',
      :help_text => 'Por ejemplo, si usted crea una nueva versión de sus conjuntos de datos todos los días, elija esto si le toma aproximadamente un día publicarlos',
      :requirement => ['pilot_9']
    a_good 'Menos de la mitad de la brecha entre lanzamientos.',
      :text_as_statement => 'Menos de la mitad de la brecha entre lanzamientos.',
      :help_text => 'Por ejemplo, si usted crea una nueva versión de sus conjuntos de datos todos los días, elija esto si le toma menos de doce horas publicarlos.',
      :requirement => ['standard_18']
    a_minimal 'Hay un mínimo o no demora alguna',
      :text_as_statement => 'Mínimo',
      :help_text => 'Elija esto si usted publica en pocos segundos o minutos',
      :requirement => ['exemplar_6']

    label_pilot_9 'Usted debería tener una demora razonable entre la creación y la publicación de sus bases de datos, que sea menor a la brecha entre lanzamientos para que las personas puedan guardar sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Usted debería tener una demora corta entre la creación y la publicación de sus conjuntos de datos, que sea menos que la mitad de la brecha entre lanzamientos para que las personas guarden sus coipas actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_6 'Usted debería tener un retraso mínimoen la creación y publicación de sus conjuntos de datos, para que las personas puedan guardar sus copias actualizadas y precisas.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps '¿Usted también publica dumps de estos conjuntos de datos?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'El curador publica',
      :help_text => 'Un dump es un extracto de toda la base de datos en un documento que las personas pueden descargar. Esto permite a las personas realizar análisis que es diferente del que se realiza de un acceso API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Vertederos de datos',
      :requirement => ['standard_19']

    label_standard_19 'Usted debería permitir a las personas descargar su conjunto de datos completa, para que puedan realizar análisis más completos y precisos de los datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency '¿Con qué frecuencia crea dumps de los conjuntos de datos?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Los dumps de los conjuntos de datos son creados',
      :help_text => 'Un acceso rápido a extractos más frecuentes de toda la base de datos significa que las personas pueden iniciar más rápido con los datos más actualizados.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'Con menos frecuencia que una vez al mes',
      :text_as_statement => 'Con menos frecuencia que una vez al mes'
    a_monthly 'Por lo menos una vez al mes',
      :text_as_statement => 'Por lo menos una vez al mes',
      :requirement => ['pilot_10']
    a_weekly 'Una semana después de cualquier cambio',
      :text_as_statement => 'Una semana después de cualquier cambio',
      :requirement => ['standard_20']
    a_daily 'Un día después de cualquier cambio',
      :text_as_statement => 'Un día después de cualquier cambio',
      :requirement => ['exemplar_7']

    label_pilot_10 'Usted debería crear un nuevo dump de su conjunto de datos cada mes, para que las personas tengan los últimos datos.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Usted debería crear un dump del conjunto de datos una semana después de cualquier cambio, para que las personas esperen lo menos posible por los últimos datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_7 'Usted debería crear un nuevo dumop del conjunto de datos un día después de cualquier cambio, para que se les facilite a las personas obtener los últimos datos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected '¿Serán corregidos sus datos si cuenta con errores?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Cualquier error en esto datos es',
      :help_text => 'Es una buena práctica el corregir errores en sus datos especialmente si usted mismo los usa. Cuando hace correcciones, las personas necesitan ser informadas.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Corregido',
      :requirement => ['standard_21']

    label_standard_21 'Usted debería corregir sus datos cuando las personas reporten errores, para que todos se beneficien de las mejoras en precisión.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Calidad',
      :help_text => '¿Cuántas personas pueden confiar en sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl '¿En dónde documenta cuestiones sobre la calidad de los datos?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La calidad de los datos está documentada en',
      :help_text => 'Ofrezca un URL donde las personas puedan informarse sobre la calidad de sus datos. Las personas aceptan que los errores son inevitables, desde un malfuncionamiento del equipo o errores que suceden en la migración de sistemas. Usted debe ser abierto sobre la calidad para que las personas puedan juzgar qué tanto confían en sus datos.'
    a_1 'URL de la documentación de calidad de los datos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la documentación de calidad de los datos',
      :requirement => ['standard_22']

    label_standard_22 'Usted debería documentar cualquier asunto conocido sobre la calidad de sus datos, para que las personas puedan decidir cuánto confiar en sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl '¿En dónde se describe su proceso de control de calidad?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El proceso de control de calidad se describe en',
      :help_text => 'Ofrezca un URL para que las personas puedan conocer sobre las revisiones en curso de sus datos, ya sean automáticos o manuales. Esto les reasegura que usted toma la calidad seriamente y que alentará mejoras que beneficien a todos.'
    a_1 'URL de la descripción del proceso de control de calidad',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la descripción del proceso de control de calidad',
      :requirement => ['exemplar_8']

    label_exemplar_8 'Usted debería documentar su proceso de control de calidad, para que las personas puedan decidir que tanto confían en sus datos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garantías',
      :help_text => '¿Cuántas personas pueden depender de la disponibilidad de sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_backups '¿Realiza usted respaldos fuera del sitio?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos están',
      :help_text => 'El realizar respaldos regualres fuera del sitio ayuda a asegurar que los datos no se perderán en caso de un accidente.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Respaldo fuera del sitio',
      :requirement => ['standard_23']

    label_standard_23 'Usted debería tener un respaldo fuera de sitio, para que los datos no se pierdan en caso de que un accidente suceda',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl '¿En dónde describe usted cualquier garantía sobre la disponibilidad del servicio?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La disponibilidad del servicio se describe en',
      :help_text => 'Ofrezca un URL para una página que describa que garantías tiene usted sobre el servicio que está disponible para uso de las personas. Por ejemplo, puede que usted garantice un periodo de uso del 99.5%, o puede no proveer de garantía alguna.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL de documentación de disponibilidad del servicio',
      :string,
      :input_type => :url,
      :placeholder => 'URL de documentación de disponibilidad del servicio',
      :requirement => ['standard_24']

    label_standard_24 'Usted debería describir qué garantías tiene usted sobre la disponibilidad del servicio, para que las personas sepan que tanto pueden depender de ello.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl '¿En dónde ofrece usted información sobre el estado de servicio actual?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El estado del servicio se da en',
      :help_text => 'Ofrezca un URL para una página que informe a las personas sobre el actual estado de su servicio, incluyendo cualquier falla de la usted tenga conocimiento.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL de estado de servicio',
      :string,
      :input_type => :url,
      :placeholder => 'URL de estado de servicio',
      :requirement => ['exemplar_9']

    label_exemplar_9 'Usted debería contar con una página de estado de servicio que le informe a las personas sobre el actual estado de su servicio.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability '¿Cuánto tiempo estarán disponibles estos datos?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos están disponibles',
      :pick => :one
    a_experimental 'Podrían desaparecer en cualquier momento',
      :text_as_statement => 'Experimentalmente y podrían desaparecer en cualquier tiempo'
    a_short 'Están disponibles de manera experimental, pero deben estarlo aproximadamente por otro año',
      :text_as_statement => 'Experimentalmente más o menos por otro año',
      :requirement => ['pilot_11']
    a_medium 'Están en un plan a mediano plazo, por lo que deberían seguir aproximadamente por un par de años',
      :text_as_statement => 'Por lo menos por un par de años',
      :requirement => ['standard_25']
    a_long 'Es parte de sus operaciones día a día, por lo que estarán publicados por un largo tiempo',
      :text_as_statement => 'Por un largo tiempo',
      :requirement => ['exemplar_10']

    label_pilot_11 'Usted debería garantizar que sus datos estarán disponibles en este formato por lo menos un año, para que las personas pueden decidir que tanto depender en sus datos.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Usted debería garantizar que sus datos estarán disponibles en este formato en plazo mediano, para que las personas puedan decidir que tanto depender en sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_10 'Usted debería garantizar que sus datos estarán disponibles en este formato en un largo plazo, para que las personas puedan decidir que tanto depender en sus datos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Información técnica',
    :description => 'Locaciones, formatos y confianza' do

    label_group_11 'Locaciones',
      :help_text => '¿Cómo pueden las personas acceder a sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl '¿Dónde está su conjunto de datos?',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos son publicados en',
      :help_text => 'Ofrezca un URL directo al conjunto de datos. Los Datos abiertos deberían ser enlazados directamente en la página para que las personas puedan encontrarlos fácilmente y reusarlos.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'URL de conjunto de datos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de conjunto de datos',
      :requirement => ['basic_9', 'pilot_12']

    label_basic_9 'Usted debería proveer ya sea un URL a sus datos o un URL a documentación sobre estos, para que las personas puedan encontrarlos.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_12 'Usted debería tener un URL que sea un enlace directo a los propios datos, para que las personas accedan a estos con facilidad.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement '¿Cómo publica usted series de las mismos conjuntos de datos?',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'Como un único URL que es regularmente actualizado',
      :help_text => 'Elija esto si existe un único URL para que las personas descarguen la versión más reciente de su conjunto de datos actual.',
      :requirement => ['standard_26']
    a_template 'Como URL consistentes para cada lanzamiento',
      :help_text => 'Elija esto si la URL del conjunto de datos siguen un patrón regular que incluye el día de la publicación, por ejemplo, un URL que inicie "2013-04". Esto ayuda a las personas a entender que tan seguido usted hace nuevos lanzamientos de datos, y a escribir secuencias de comandos que busquen nuevos en cada momento que sean lanzados.',
      :requirement => ['pilot_13']
    a_list 'Como una lista de lanzamientos',
      :help_text => 'Elija esto si usted tiene una lista de conjuntos de datos en una página web o en una fuente (como Atom o RSS) cada uno con enlaces individuales a lanzamientos y sus detalles. Esto ayuda a las personas a entender qué tan seguido usted lanza datos, y para escribir secuencias de comandos que busquen nuevos en cada momento que sean lanzados.',
      :requirement => ['standard_27']

    label_standard_26 'Usted debería tener un único y persistente URL para descargar la actual versión de su conjunto de datos, para que las personas accedan con facilidad',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_13 'Usted debería usar un patrón consistente para diferentes URL de lanzamientos, para que las personas puedan descargar cada uno automáticamente.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'Usted debería tener un documento o fuente con una lista de lanzamientos disponibles, para que las personas creen secuencias de comandos para descargar todos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Usted debería proveer acceso a lanzamientos de sus datos mediante un URL que de la actual versión, una detectable serie de URL o mediante una página de documentación para que las personas puedan encontrarla.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl '¿En dónde se encuentra tu actual conjunto de datos?',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El conjunto de datos esta tisponible en',
      :help_text => 'Ofrezca un único URL a la versión más reciente de su conjunto de datos. El contenido de este URL cambiar cada vez que una nueva versión sea lanzada.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'URL actual del conjunto de datos',
      :string,
      :input_type => :url,
      :placeholder => 'URL actual del conjunto de datos',
      :required => :required

    q_versionsTemplateUrl '¿Qué formato de URL siguen los lanzamientos de su conjunto de datos?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Los lanzamientos siguen este patrón consistente de URL',
      :help_text => 'Esta es una estructura de URL cuando usted publica diferentes lanzamientos. Use "variables" para indicar partes del patrón de URL que cambien, por ejemplo, "http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'URL de versión de patrones',
      :string,
      :input_type => :text,
      :placeholder => 'URL de versión de patrones',
      :required => :required

    q_versionsUrl '¿En dónde está su lista de lanzamientos de conjuntos de datos?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Lanzamientos de estos datos se enlistan en',
      :help_text => 'De un URL a una página o fuente con una lectura mecánica de la lista de conjuntos de datos. Use el URL de la primera página que debería enlazarlo con el resto de las páginas.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'URL de versión de lista',
      :string,
      :input_type => :url,
      :placeholder => 'URL de versión de lista',
      :required => :required

    q_endpointUrl '¿En dónde está el endpoint su API?',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El punto final del servicio API es',
      :help_text => 'De un URL que sea un punto inicial para las secuencias de comandos de las personas para que accedan a su API. Este debe ser un documento de descripción de servicio que ayuda a la secuencia de comandos a cuadrar que servicios existen.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL del endpoint',
      :string,
      :input_type => :url,
      :placeholder => 'URL del endpoint',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Usted debe proveer ya sea el URL del endpoint de su API o un URL a su documentación, para que las personas puedan encontrarlo.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Usted debería tener un documento de descripción de servicio o un punto de entrada único a su API, para que las personas accedan.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement '¿Cómo publica usted vertederos de sus bases de datos?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'Como un único URL que es regularmente actualizado',
      :help_text => 'Escoja esto un único URL para que las personas descarguen la más reciente versión del dump actual de bases de datos.',
      :requirement => ['standard_29']
    a_template 'Como un URL consistente para cada lanzamiento',
      :help_text => 'Elija esto si URL del dump del conjunto de datos sigue un patrón regular que incluya la fecha de publicación, por ejemplo, un URL que inicie "2013-04". Esto ayuda a las personas a entender que tan seguido lanza usted datos, y a escribir secuencias de comandos que busquen nuevos en cada momento que sean lanzados.',
      :requirement => ['exemplar_11']
    a_list 'Como una lista de lanzamientos',
      :help_text => 'Elija esto si usted tiene una lista de vertederos de bases de datos en una página web o en una fuente (como son Atom o RSS) cada uno con enlaces individuales a lanzamientos y sus detalles. Esto ayuda a las personas que tan seguido libera usted datos, y a escribir secuencias de comandos que busquen otros nuevos en cada momento que sean lanzados.',
      :requirement => ['exemplar_12']

    label_standard_29 'Usted debería tener un único y persistente URL para descargar su dump actual de bases de datos, para que las personas lo encuentren.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_11 'Usted debería usar un patrón consistente para las URLs del dump del conjunto de datos, para que las personas puedan descargar cada uno automáticamente.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_12 'Usted debería tener un documento o fuente con una lista de los dumps de los conjuntos de datos disponibles, para que las personas puedan crear secuencias de comandos y los descarguen todos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl '¿Dónde está el dump actual del conjunto de datos?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El dump del conjunto de datos más reciente está siempre disponible en',
      :help_text => 'Dé un URL al dump más reciente del conjunto de datos. El contenido de este URL debería cambiar cada vez que un nuevo dums sea creado.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'URL del dump actual',
      :string,
      :input_type => :url,
      :placeholder => 'URL del dump actual',
      :required => :required

    q_dumpsTemplateUrl '¿Qué formato de URL siguen los dumps de los conjuntos de datos?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => '¿Los vertederos del conjunto de datos siguen el consistente patrón de URL?',
      :help_text => 'Esta es la estructura de URL cuando usted publica diferentes lanzamientos. Use "variable" para indicar las partes del patrón de URL que cambian, por ejemplo, "http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'URL dela plantilla del dump',
      :string,
      :input_type => :text,
      :placeholder => 'URL dela plantilla del dump',
      :required => :required

    q_dumpsUrl '¿Dónde está lista de dumps de los conjuntos de datos disponibles?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Una lista de los dumps de los conjuntos de datos está en',
      :help_text => 'De un URL a una página o fuente con una lista de los dumps de los conjuntos de datos legible por máquina. Use el URL de la primera página que debería enlazarlo con el resto de las páginas.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'URL de lista de dumps',
      :string,
      :input_type => :url,
      :placeholder => 'URL de lista de dumps',
      :required => :required

    q_changeFeedUrl '¿En dónde está su fuente de cambios?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Una fuente de los cambios de estos datos está en',
      :help_text => 'De un URL a una página web o fuente que provea una lectura mecánica de una lista de las versiones previas de vertederos de bases de datos. Use el URL de la primera página que debería enlazarlo con el resto de las páginas.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'URL de fuente de cambios',
      :string,
      :input_type => :url,
      :placeholder => 'URL de fuente de cambios',
      :required => :required

    label_group_12 'Formatos',
      :help_text => '¿Cómo pueden las personas trabajar con sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable '¿Los datos son legibles para una computadora?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos son',
      :help_text => 'Las personas prefieren formatos de datos en los que sea sencillo para una computadora procesarlos, por rapidez y precisión. Por ejemplo, una fotocopia escaneada de una hoja de cálculo no podrá tener una lectura mecánica pero un archivo CSV sí.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Legible por máquinas',
      :requirement => ['pilot_14']

    label_pilot_14 'Usted debería proveer sus datos en un formato legible por máquinas, para que sea fácil de procesar.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard '¿Están los datos en un formato estándar de datos abiertos?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'El formato de estos datos es',
      :help_text => 'Los estándares abiertos son creados a través de un proceso justo, transparente y colectivo. Cualquiera puede implementarlos y existe mucho apoyo, por lo cual, es más fácil para usted compartir datos con más personas. Por ejemplo, XML, CSV, y JSON son estándares abiertos.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Un formato abierto estandar',
      :requirement => ['standard_30']

    label_standard_30 'Usted debería proveer sus datos en un formato abierto estandar, para que las personas puedan usar ampliamente herramientas para procesarlo más fácilmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType '¿Qué tipo de datos publica?',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'Documentos de lectura humana',
      :help_text => 'Elija esto si sus datos son intencionados para consumo humano. Por ejemplo, documentos de políticas, documentos técnicos, reportes y minutas de reuniones. Estos usualmente tienen alguna estructura para sí, pero son en su mayoría texto.'
    a_statistical 'Datos estadísticos como cuentas, promedios y porcentajes',
      :help_text => 'Elija esto si sus datos son estadísticas o datos numéricos como cuentas, promedios y porcentajes. Puede tratarse de resultados de censo, información del flujo vehicular o estadísticas de crímenes.'
    a_geographic 'Información geográfica, tales como puntos y límites.',
      :help_text => 'Elija esto si sus datos pueden ser trazados en un mapa como puntos, límites o líneas.'
    a_structured 'Otros tipos de datos estructurados',
      :help_text => 'Elija esto si sus datos son estructurados en otras maneras. Puede tratarse de detalles de eventos, horarios de trenes, información de contacto o cualquier cosa que pueda ser interpretada como datos, y analizada y presentada en múltiples formas.'

    q_documentFormat '¿Sus documentos de lectura humana incluyen formatos que?',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Documentos son publicados',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'Describa la estructura semántica como HTML, DocBook o Markdown',
      :text_as_statement => 'En un formato semántico',
      :help_text => 'Estos formatos de estructuras etiquetadas como capítulos, encabezados y tablas que facilitan la creación automática de resúmenes como tablas de contenido y glosarios. También facilitan la aplicación de diferentes estilos al documento para que su apariencia cambie.',
      :requirement => ['standard_31']
    a_format 'Describa información sobre el formateo como OOXML o PDF',
      :text_as_statement => 'En un formato de exhibición',
      :help_text => 'Estos formatos enfatizan la apariencia como las fuentes, colores y posicionamiento de diferentes elementos dentro de la página. Estos son buenos para consumo humano, pero no son tan sencillos para que las personas los procesen automáticamente y cambien el estilo.',
      :requirement => ['pilot_15']
    a_unsuitable 'No son intencionados para documentos como Excel, JSON o CVS',
      :text_as_statement => 'En un formato inadecuado para documentos',
      :help_text => 'Estos formatos se adecuan más a datos tabulados o estructurados'

    label_standard_31 'Usted debería publicar documentos en in formato que exponga la estructura semántica, para que las personas puedan exponerlos en diferentes estilos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_15 'Usted debería publicar documentos en un formato diseñado específicamente para estos, para que sean fáciles de procesar.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat '¿Sus datos estadísticos incluyen formatos que?',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Datos estadísticos son publicados',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'Exponga la estructura de hipercubos de datos estadísticos como <a href="http://sdmx.org/">SDMX</a> o <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a>
                     ',
      :text_as_statement => 'En un formato de datos estadísticos',
      :help_text => 'Observaciones individuales en hipercubos se relacionan con una medida particular y a un conjunto de dimensiones. Cada observación puede también estar relacionada con anotaciones que dan contexto extra. Formatos como <a href="http://sdmx.org/">SDMX</a> and <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> son diseñados para expresar esta estructura subyacente.',
      :requirement => ['exemplar_13']
    a_tabular 'Tratar datos estadísticos como una tabla como CVS',
      :text_as_statement => 'En un formato de datos tabulados',
      :help_text => 'Estos formatos colocan datos estadísticos dentro de un tabla de filas y columnas. Esto carece de contexto extra sobre el hipercubo subyacente pero es fácil de procesar.',
      :requirement => ['standard_32']
    a_format 'Enfóquese en el formato de datos tabulados como Excel',
      :text_as_statement => 'En un formato de presentación',
      :help_text => 'Las hojas de cálculo usan formatos como itálicas o negritas y sangría dentro de los campos para describir su apariencia y estructura subyacente. Este estilo ayuda a las personas a entender el significado de sus datos pero los vuelve menos adecuados para que las computadoras los procesen.',
      :requirement => ['pilot_16']
    a_unsuitable 'No son intencionados para datos estadísticos o tabulados como Word o PDF',
      :text_as_statement => 'En un formato inadecuado para datos estadísticos',
      :help_text => 'Estos formatos no se adecuan a datos estadísticos porque obscurecen la estructura subyacente de los datos.'

    label_exemplar_13 'Usted debería publicar datos estadísticos en un formato que exponga dimensiones y medidas, para que sean fáciles de analizar.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Usted debería publicar datos tabulados en un formato que exponga tablas de datos, para que sea fácil de analizar.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_16 'Usted debería publicar datos tabulados en un formato diseñado para tal propósito, para que sea fácil de procesar.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat '¿Sus datos geográficos incluyen formatos que?',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Datos geográficos son publicados',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'Son diseñados para datos geográficos como <a href="http://www.opengeospatial.org/standards/kml/">KML</a> o <a href="http://www.geojson.org/">GeoJSON</a>
                     ',
      :text_as_statement => 'En un formato de datos geográficos',
      :help_text => 'Estos formatos describen puntos, líneas y límites, y exponen estructuras en los datos que facilitan el procesamiento automático',
      :requirement => ['exemplar_14']
    a_generic 'Mantiene los datos estructurados como JSON, XML o CVS',
      :text_as_statement => 'En un formato para datos genéricos',
      :help_text => 'Cualquier formato guarde datos estructurados normales puede expresar datos geográficos también, particularmente si sólo sostiene datos acerca de puntos.',
      :requirement => ['pilot_17']
    a_unsuitable 'No son diseñados para datos geográficos como Word o PDF',
      :text_as_statement => 'En un formato inadecuado para datos geográficos',
      :help_text => 'Estos formatos no se adecuan a datos geográficos porque obscurecen la estructura subyacente de los datos'

    label_exemplar_14 'Usted debería publicar datos geográficos en un formato diseñado a propósito, para que las personas puedan usar ampliamente las herramientas disponibles para procesarlos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_17 'Usted debería publicar datos geográficos como datos estructurados, para que sea fácil de procesar.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat '¿Sus datos estructurados incluyen formatos que?',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos estructurados son publicados',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'No son diseñados para datos estructurados como JSON, XML, Turtle o CSV',
      :text_as_statement => 'En un formato de datos estructurados',
      :help_text => 'Estos formatos organizan los datos en una estructura básica de las cosas que tienen valores para un conjunto conocido de propiedades. Estos formatos son fáciles para que las computadoras los procesen automáticamente.',
      :requirement => ['pilot_18']
    a_unsuitable 'No diseñados para datos estructurados como Word o PDF',
      :text_as_statement => 'En un formato inadecuado para datos estructurados',
      :help_text => 'Estos formatos no se adecuan a este tipo de datos porque obscurecen su estructura subyacente'

    label_pilot_18 'Usted debería publicar datos estructurados en formatos diseñados a propósito, para que sean fáciles de procesar.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers '¿Sus datos utilizan identificadores persistentes?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'Los datos incluyen',
      :help_text => 'Los datos son usualmente acerca de cosas reales como escuelas, caminos o usos de un esquema de codificación. Si los datos de diferentes fuentes utilizan el mismo identificador persistente y único para referirse a las mismas cosas, las personas pueden combinar fuentes fácilmente para crear datos más útiles. Los identificadores pueden ser GUIDs, DOIs o URL',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Identificadores persistentes',
      :requirement => ['standard_33']

    label_standard_33 'Usted debería utilizar identificadores para cosas en sus datos, para que sean fácilmente relacionados con otros datos sobre esas mismas cosas',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds '¿Pueden los identificadores de sus datos ser utilizados para encontrar información extra?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Los identificadores persistentes',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'No, los identificadores no pueden ser utilizados para encontrar información extra',
      :text_as_statement => ''
    a_service 'Sí, hay un servicio que las personas pueden usar para resolver los identificadores',
      :text_as_statement => 'Resuelva usando un servicio',
      :help_text => 'Los servicios en línea pueden ser usados para dar información a las personas sobre los identificadores como GUIDs o DOIs, que no pueden ser accedidos directamente en la manera en que los URL son',
      :requirement => ['standard_34']
    a_resolvable 'Sí, los identificadores son URL que resuelven para dar información',
      :text_as_statement => 'Resuelva porque son URL',
      :help_text => 'Los URL son útiles tanto para las personas como las computadoras. Las personas pueden poner un URL en sus buscadores y leer más información, como <a href="http://opencorporates.com/companies/gb/08030289">companies</a> and <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">postcodes</a>. Las computadoras también pueden procesar esta información extra utilizando secuencias de comandos para acceder a los datos subyacentes.',
      :requirement => ['exemplar_15']

    label_standard_34 'Usted debería proveer un servicio para resolver los identificadores que usted usa, para que las personas puedan encontrar información extra sobre estos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_15 'Usted debería enlazar a una página web de información acerca de cada una de las cosas en sus datos, para que las personas puedan fácilmente encontrar y compartir esa información.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL '¿Dónde está el servicio que es utilizado para resolver identificadores?',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'El servicio de resolución de identificadores está en',
      :help_text => 'El servicio de resolución debe tomar un identificador como un parámetro de indagación y regresar alguna información sobre las cosas que identifica.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'URL de servicio de resolución de identificadores',
      :string,
      :input_type => :url,
      :placeholder => 'URL de servicio de resolución de identificadores',
      :requirement => ['standard_35']

    label_standard_35 'Usted debería tener un URL a través del cual los identificadores pueden ser resueltos, para que una computadora pueda encontrar más información sobre estos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls '¿Existe en la web información de terceros sobre las cosas en tus datos?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Algunas veces otras personas fuera de tu control proveen de URL a las cosas que tus datos refieren. Por ejemplo, tus datos podrían tener códigos postales en si mismos que enlacen con el sitio web Ordnance Survey',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls '¿Es la información de terceros confiable?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'Si un tercero provee URL públicos sobre cosas de tus datos, estos probablemente toman pasos para asegurar la calidad y la fiabilidad de los datos. Esta es una medida de cuánto confía usted sus procesos para hacerlo. Busque su certificado de datos abiertos o sellos similares para ayudarle a tomar una decisión.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls '¿Sus datos utilizan los URL de terceros?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'El URL de terceros es',
      :help_text => 'Usted debería usar los URL de terceros que resuelvan información sobre las cosas a las que sus datos se refieren. Esto reduce la duplicación y ayuda a las personas a combinar datos de diferentes fuentes, para que sea más útil.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Referencias en estos datos',
      :requirement => ['exemplar_16']

    label_exemplar_16 'Usted debería usar URL de la información de terceros, para que sea más fácil combinarlos con otros datos que también usen esos URL',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Confianza',
      :help_text => '¿Cuánto pueden confiar las personas en sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_provenance '¿Usted provee una procedencia legible para computadora de sus datos?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'La procedencia de estos datos es',
      :help_text => 'Esto es acerca de los orígenes de cómo sus datos fueron creados y procesados antes de ser publicados. Genera confianza en los datos que usted publica, porque las personas pueden rastrear cómo han sido manejados.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Lectura mecánica',
      :requirement => ['exemplar_17']

    label_exemplar_17 'Usted debería proveer un rastro de procedencia de lectura mecánica sobre sus datos, para que las personas puedan rastrear cómo fueron procesados.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate '¿En dónde especifica cómo pueden las personas verificar que los datos que reciben provienen de usted?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Estos datos pueden ser verificados usando',
      :help_text => 'Si usted entrega datos importantes a las personas, éstas deberían tener la posibilidad de revisar que lo que reciben es lo mismo que usted publica. Por ejemplo, usted puede firmar digitalmente los datos que publica, para que las personas pueden ver si han sido alterados.'
    a_1 'URL de proceso de verificación',
      :string,
      :input_type => :url,
      :placeholder => 'URL de proceso de verificación',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Usted debería describir cómo las personas pueden revisar que los datos que reciben son los mismo que usted publica, para que puedan confiar en estos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Información social',
    :description => 'Documentación, asistencia y servicios' do

    label_group_15 'Documentación',
      :help_text => '¿Cómo ayuda usted a las personas a entender el contexto y contenido de sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata '¿Su documentación de datos incluye datos legibles por máquina para?',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La documentación incluye datos legibles por máquina para',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'Título',
      :text_as_statement => 'Título',
      :requirement => ['standard_36']
    a_description 'Descripción',
      :text_as_statement => 'Descripción',
      :requirement => ['standard_37']
    a_issued 'Fecha de lanzamiento',
      :text_as_statement => 'Fecha de lanzamiento',
      :requirement => ['standard_38']
    a_modified 'Fecha de modificación',
      :text_as_statement => 'Fecha de modificación',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'Frecuencia de lanzamientos',
      :text_as_statement => 'Frecuencia de liberación',
      :requirement => ['standard_40']
    a_identifier 'Identificador',
      :text_as_statement => 'Identificador',
      :requirement => ['standard_41']
    a_landingPage 'Página de destino',
      :text_as_statement => 'Página de destino',
      :requirement => ['standard_42']
    a_language 'Idioma',
      :text_as_statement => 'Idioma',
      :requirement => ['standard_43']
    a_publisher 'Editor',
      :text_as_statement => 'Editor',
      :requirement => ['standard_44']
    a_spatial 'Cobertura espacial/geográfica',
      :text_as_statement => 'Cobertura espacial/geográfica',
      :requirement => ['standard_45']
    a_temporal 'Cobertura temporal',
      :text_as_statement => 'Cobertura temporal',
      :requirement => ['standard_46']
    a_theme 'Tema(s)',
      :text_as_statement => 'Tema(s)',
      :requirement => ['standard_47']
    a_keyword 'Palabra(s) clave o etiqueta(s)',
      :text_as_statement => 'Palabra(s) clave o etiqueta(s)',
      :requirement => ['standard_48']
    a_distribution 'Distribución',
      :text_as_statement => 'Distribución'

    label_standard_36 'Usted debería incluir un título a sus datos legibles por máquina en su documentación, para que las personas sepan cómo referirse a ésta.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Usted debería incluir una descripción de datos legibles por máquina en su documentación, para que las personas sepan qué contienen',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Usted debería incluir una fecha de lanzamiento de datos legibles por máquina en su documentación, para que las personas sepan qué tan oportunos son',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Usted debería incluir una última fecha de modificación legible por máquina en su documentación, para que las personas sepan que cuentan con los últimos datos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Usted debería proveer metadatos legibles por máquina sobre la frecuencia lanza usted nuevas versiones de sus datos, para que las personas sepan con qué frecuencia los actualiza.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Usted debería incluir un URL canónico para sus datos en su documentación legible por máquina, para que las personas sepan cómo acceder a estos de forma consistente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Usted debería incluir un URL canónico para sus datos en su documentación legible por máquina, para que las personas sepan cómo acceder a estos de forma consistente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Usted debería el lenguaje de datos en su documentación legible por máquina, para que las personas que los busquen sepan si podrán entenderlos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Usted debería indicar el editor de datos en su documentación legible por máquina, para que las personas puedan decidir qué tanto confiar en sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Usted debería incluir la cobertura geográfica en su documentación legible por máquina, para que las personas puedan entender en dónde aplican sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Usted debería incluir el periodo de tiempo en su documentación legible por máquina, para que las personas entiendan cuándo son aplicables sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Usted debería incluir el tema en su documentación legible por máquina, para que las personas conozcan aproximadamente de qué se tratan sus datos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Usted debería incluir palabras clave o etiquetas legibles por máquina en su documentación, para ayudar a las personas a buscar dentro de los datos de manera efectiva.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata '¿Su documentación incluye metadatos legibles por máquina por cada distribución en?',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La documentación acerca de cada distribución incluye datos legibles por máquina para',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'Título',
      :text_as_statement => 'Título',
      :requirement => ['standard_49']
    a_description 'Descripción',
      :text_as_statement => 'Descripción',
      :requirement => ['standard_50']
    a_issued 'Fecha de lanzamiento',
      :text_as_statement => 'Fecha de lanzamiento',
      :requirement => ['standard_51']
    a_modified 'Fecha de modificación',
      :text_as_statement => 'Fecha de modificación',
      :requirement => ['standard_52']
    a_rights 'Declaración de derechos',
      :text_as_statement => 'Declaración de derechos',
      :requirement => ['standard_53']
    a_accessURL 'URL para acceder a los datos',
      :text_as_statement => 'Un URL para acceder a los datos',
      :help_text => 'Estos metadatos deberían ser utilizados cuando sus datos no estén disponibles como una descarga, como una API por ejemplo.'
    a_downloadURL 'URL para descargar la base de datos',
      :text_as_statement => 'Un URL para descargar la base de datos'
    a_byteSize 'Tamaño en bytes',
      :text_as_statement => 'Tamaño en bytes'
    a_mediaType 'Tipos de medios de descarga',
      :text_as_statement => 'Tipos de medios de descarga'

    label_standard_49 'Usted debería incluir títulos legibles por máquina dentro de su documentación, para que las personas sepan cómo referirse a cada distribución de datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Usted debería incluir descripciones legibles por máquina dentro de su documentación, para que las personas conozcan lo que cada distribución de datos contiene.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Usted debería incluir fechas de lanzamiento legibles por máquina dentro de su documentación, para que las personas conozcan qué tan actual cada distribución es',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'Usted debería incluir fechas de última modificación legibles por máquina dentro de su documentación, para que las personas conozcan si su copia de distribución de datos está actualizada.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Usted debería incluir un enlace a la declaración de derechos aplicables legible por máquina, para que las personas encuentren qué es lo que pueden hacer con una distribución de datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation '¿En dónde está la documentación técnica de los datos?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'La documentación técnica para estos datos está en'
    a_1 'URL de documentación técnica',
      :string,
      :input_type => :url,
      :placeholder => 'URL de documentación técnica',
      :requirement => ['pilot_19']

    label_pilot_19 'Usted debería proveer documentación técnica para los datos, para que las personas puedan entender cómo usarlos',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary '¿Los formatos de datos usan vocabularios o esquemas personalizados?',
      :discussion_topic => :vocabulary,
      :help_text => 'Formatos como CSV, JSON, XML o Turtle usan vocabularios o esquemas personalizados que indican qué columnas o propiedades contienen los datos',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl '¿Dónde está la documentación acerca de los vocabularios de sus datos?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Los vocabularios utilizados en estos datos están documentados en'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'URL de la documentación de esquemas',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la documentación de esquemas',
      :requirement => ['standard_54']

    label_standard_54 'Usted debería documentar cualquier vocabulario que usted utilizó dentro de sus datos, para que las personas conozcan cómo interpretarlos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists '¿Existe algún código utilizado en estos datos?',
      :discussion_topic => :codelists,
      :help_text => 'Si sus datos utilizan códigos para referirse a cosas como áreas geográficas, categorías de gastos o enfermedades, por ejemplo; estos necesitan ser explicados a las personas',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl '¿Dónde está documentado algún código en tus datos?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Los códigos en estos datos están documentados en'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'URL documentación de lista de códigos',
      :string,
      :input_type => :url,
      :placeholder => 'URL documentación de lista de códigos',
      :requirement => ['standard_55']

    label_standard_55 'Usted debería documentar los códigos utilizados dentro de sus datos, para que las personas sepan como interpretarlos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Asistencia',
      :help_text => '¿Cómo se comunica usted con las personas que utilizan sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl '¿En dónde pueden las personas encontrar los contactos necesarios para realizar acerca de estos datos?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Encuentre la manera de contactar a alguien sobre estos datos en',
      :help_text => 'Ofrezca un URL a una página que describa cómo las personas pueden contactar a alguien si tienen dudas sobre los datos'
    a_1 'URL de contacto',
      :string,
      :input_type => :url,
      :placeholder => 'URL de contacto',
      :requirement => ['pilot_20']

    label_pilot_20 'Usted debería proveer información de contactos para que las personas envíen preguntas sobre sus datos también',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact '¿En dónde pueden las personas encontrar cómo mejorar la forma en que los datos fueron publicados?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Encuentre cómo sugerir mejoras a una publicación en'
    a_1 'URL de sugerencia de mejoras',
      :string,
      :input_type => :url,
      :placeholder => 'URL de sugerencia de mejoras',
      :requirement => ['pilot_21']

    label_pilot_21 'Usted debería proveer instrucciones acerca de cómo sugerir mejoras a la manera en que usted publica sus datos, para que usted descubra lo que las personas necesitan',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl '¿En dónde pueden las personas encontrar cómo contactar a alguien para preguntar sobre la privacidad?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Encuentre a dónde enviar preguntas sobre privacidad'
    a_1 'Documentación de contactos de confidencialidad',
      :string,
      :input_type => :url,
      :placeholder => 'Documentación de contactos de confidencialidad',
      :requirement => ['pilot_22']

    label_pilot_22 'Usted debería proveer información de contactos para que las personas envíen preguntas sobre la privacidad y la divulgación de detalles personales también',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia '¿Hace uso redes sociales para conectarse con las personas que utilizan sus datos?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 'Usted debería utilizar redes sociales para llegar a las personas que usan sus datos y descubrir cómo están siendo utilizados sus datos.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Cuenta' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account '¿En cuáles cuentas de redes sociales las personas pueden llegar a usted?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Contacte al curador a través de estas cuentas en redes sociales',
        :help_text => 'De un URL a sus cuentas de redes sociales, como su Twitter o su página de perfil de Facebook',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'URL de redes sociales',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL de redes sociales'

    end

    q_forum '¿En dónde deberían las personas discutir sobre esta base de datos?',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Discuta estos datos en',
      :help_text => 'De un URL a su fórum o lista de correos donde las personas puedan hablar sobre sus datos'
    a_1 'URL de fórums o lista de correos',
      :string,
      :input_type => :url,
      :placeholder => 'URL de fórums o lista de correos',
      :requirement => ['standard_57']

    label_standard_57 'Usted debería decirle a las personas en dónde pueden discutir sus datos y apoyarse el uno al otro',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting '¿Dónde pueden las personas encontrar cómo solicitar una corrección a sus datos?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Encuentre cómo solicitar correcciones de datos en',
      :help_text => 'De un URL donde las personas puedan reportar errores que detectaron en sus datos'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL de instrucciones de corrección',
      :string,
      :input_type => :url,
      :placeholder => 'URL de instrucciones de corrección',
      :requirement => ['standard_58']

    label_standard_58 'Usted debería proveer instrucciones acerca de cómo las personas pueden reportar errores en sus datos',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery '¿Dónde pueden las personas encontrar cómo obtener notificaciones de las correcciones de sus datos?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Encuentre cómo obtener notificaciones sobre correcciones de datos en',
      :help_text => 'De un URL dónde usted describa cómo son las notificaciones sobre correcciones compartidas con la gente'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL de notificación de correcciones',
      :string,
      :input_type => :url,
      :placeholder => 'URL de notificación de correcciones',
      :requirement => ['standard_59']

    label_standard_59 'Usted debería proveer una lista de correos o una fuente con actualizaciones que las personas puedan utilizar para guardar las copias de sus datos actualizados',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam '¿Tiene usted a alguien que activamente construya una comunidad alrededor de estos datos?',
      :discussion_topic => :engagementTeam,
      :help_text => 'Un equipo de compromiso comunitario se involucra a través de redes sociales, blogs; organiza hackdays o competencias para alentar a las personas a usar los datos',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Usted debería construir una comunidad de personas alrededor de sus datos para alentar un amplio uso de sus datos',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl '¿Dónde está su página principal?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'El compromiso comunitario es realizado por',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'URL de la página principal del equipo de compromiso comunitario',
      :string,
      :input_type => :url,
      :placeholder => 'URL de la página principal del equipo de compromiso comunitario',
      :required => :required

    label_group_17 'Servicios',
      :help_text => '¿Cómo ofrece acceso a herramientas que las personas necesitan para trabajar con sus datos?',
      :customer_renderer => '/partials/fieldset'

    q_libraries '¿En dónde enlista herramientas para trabajar con sus datos?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Herramientas que ayudan a utilizar estos datos se enlistan en',
      :help_text => 'Ofrezca un URL que enliste las herramientas que usted conoce o recomienda, de manera que las personas las utilicen cuando trabajen con sus datos'
    a_1 'URL de herramientas',
      :string,
      :input_type => :url,
      :placeholder => 'URL de herramientas',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Usted debería proveer una lista de bibliotecas de software y otras herramientas de lectura disponible, para que las personas puedan rápidamente trabajar con sus datos.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end

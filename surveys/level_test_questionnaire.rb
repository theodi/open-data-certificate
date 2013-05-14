survey 'Level Test Questionnaire',
       :default_mandatory => 'false' do

  section_general 'General Information' do

    q_basic_1 'Complete me to achieve basic'
    a_1 'basic 1',
        :string,
        :placeholder => 'basic 1',
        :requirement => 'basic_1'

    label_basic_requirement_1 'You should complete the basic1 question',
                              :custom_renderer => '/partials/requirement_basic',
                              :requirement => 'basic_1'
    dependency :rule => 'A or B'
    condition_A :q_basic_1, '==', { :string_value => '', :answer_reference => '1' }
    condition_B :q_basic_1, 'count==0'


    q_pilot_1 'Complete me to achieve pilot'
    a_1 'pilot 1',
        :string,
        :placeholder => 'pilot 1',
        :requirement => 'pilot_1'

    label_pilot_requirement_1 'You should complete the pilot1 question',
                              :custom_renderer => '/partials/requirement_pilot',
                              :requirement => 'pilot_1'
    dependency :rule => 'A or B'
    condition_A :q_pilot_1, '==', { :string_value => '', :answer_reference => '1' }
    condition_B :q_pilot_1, 'count==0'


    q_standard_1 'Complete me to achieve standard'
    a_1 'standard 1',
        :string,
        :placeholder => 'standard 1',
        :requirement => 'standard_1'

    label_standard_requirement_1 'You should complete the standard1 question',
                                 :custom_renderer => '/partials/requirement_standard',
                                 :requirement => 'standard_1'
    dependency :rule => 'A or B'
    condition_A :q_standard_1, '==', { :string_value => '', :answer_reference => '1' }
    condition_B :q_standard_1, 'count==0'


    q_exemplar_1 'Complete me to achieve exemplar'
    a_1 'exemplar 1',
        :string,
        :placeholder => 'exemplar 1',
        :requirement => 'exemplar_1'

    label_exemplar_requirement_1 'You should complete the exemplar1 question',
                                 :custom_renderer => '/partials/requirement_exemplar',
                                 :requirement => 'exemplar_1'
    dependency :rule => 'A or B'
    condition_A :q_exemplar_1, '==', { :string_value => '', :answer_reference => '1' }
    condition_B :q_exemplar_1, 'count==0'


    q_multi_requirement 'Pick which of these levels you meet:',
            :pick => :any
    a_basic2 'basic2',
             :requirement => 'basic_2'
    a_pilot2 'pilot2',
             :requirement => 'pilot_2'
    a_standard2 'standard2',
                :requirement => 'standard_2'
    a_exemplar2 'exemplar2',
                :requirement => 'exemplar_2'

    label_basic_requirement_2 'You should complete the basic2 question',
                                 :custom_renderer => '/partials/requirement_basic',
                                 :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_basic2

    label_pilot_requirement_2 'You should complete the pilot2 question',
                                 :custom_renderer => '/partials/requirement_pilot',
                                 :requirement => 'pilot_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_pilot2

    label_standard_requirement_2 'You should complete the standard2 question',
                                 :custom_renderer => '/partials/requirement_standard',
                                 :requirement => 'standard_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_standard2

    label_exemplar_requirement_2 'You should complete the exemplar2 question',
                                 :custom_renderer => '/partials/requirement_exemplar',
                                 :requirement => 'exemplar_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_exemplar2

  end

end
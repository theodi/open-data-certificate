survey 'Level Test Questionnaire',
       :dataset_title => 'dataTitle',
       :dataset_curator => 'dataTitle' do

  section_general 'General Information', :display_header => false do

    q_dataTitle 'What\'s a good title for this data?',
      :help_text => 'This is a mandatory question,  it will be included in the basic count',
      :required => :required
    a_1 'Data Title',
        :string,
        :placeholder => 'Data Title',
        :required => :required

    q_basic_1 'Complete me to achieve basic'
    a_1 'basic 1',
        :string,
        :placeholder => 'basic 1',
        :requirement => 'basic_1'

    label_basic_requirement_1 'You should complete the basic1 question',
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
                                 :requirement => 'exemplar_1'
    dependency :rule => 'A or B'
    condition_A :q_exemplar_1, '==', { :string_value => '', :answer_reference => '1' }
    condition_B :q_exemplar_1, 'count==0'


    q_multi_requirement 'Pick which of these levels you meet:',
                        :help_text => 'For check boxes, whichever answer you choose should only count that requirement level as complete',
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
                                 :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_basic2

    label_pilot_requirement_2 'You should complete the pilot2 question',
                                 :requirement => 'pilot_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_pilot2

    label_standard_requirement_2 'You should complete the standard2 question',
                                 :requirement => 'standard_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_standard2

    label_exemplar_requirement_2 'You should complete the exemplar2 question',
                                 :requirement => 'exemplar_2'
    dependency :rule => 'A'
    condition_A :q_multi_requirement, '!=', :a_exemplar2



    q_radio_requirement 'Pick which of these levels you meet:',
                        :help_text => 'For radio buttons, whichever answer you choose should calculate that and all the lower requirement levels as complete',
                        :pick => :one
    a_basic3 'basic3',
             :requirement => 'basic_3'
    a_pilot3 'pilot3',
             :requirement => 'pilot_3'
    a_standard3 'standard3',
                :requirement => 'standard_3'
    a_exemplar3 'exemplar3',
                :requirement => 'exemplar_3'

    label_basic_requirement_3 'You should complete the basic3 question',
                              :requirement => 'basic_3'
    dependency :rule => 'A'
    condition_A :q_radio_requirement, 'count==0'

    label_pilot_requirement_3 'You should complete the pilot3 question',
                              :requirement => 'pilot_3'
    dependency :rule => 'A or B'
    condition_A :q_radio_requirement, 'count==0'
    condition_B :q_radio_requirement, '==', :a_basic3

    label_standard_requirement_3 'You should complete the standard3 question',
                                 :requirement => 'standard_3'
    dependency :rule => 'A or B or C'
    condition_A :q_radio_requirement, 'count==0'
    condition_B :q_radio_requirement, '==', :a_basic3
    condition_C :q_radio_requirement, '==', :a_pilot3

    label_exemplar_requirement_3 'You should complete the exemplar3 question',
                                 :requirement => 'exemplar_3'
    dependency :rule => 'A or B or C or D'
    condition_A :q_radio_requirement, 'count==0'
    condition_B :q_radio_requirement, '==', :a_basic3
    condition_C :q_radio_requirement, '==', :a_pilot3
    condition_D :q_radio_requirement, '==', :a_standard3


  end

end

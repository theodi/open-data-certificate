# encoding: UTF-8
survey "Date Survey", :dataset_title => 'dataTitle', :dataset_curator => 'dataTitle' do

  section "Simple date questions" do

    q_dataTitle "What's a good title for this data?"
    a_1 'Data Title', :string

    q "What is your birth date?"
    a :date

    q "At what time were you born?"
    a :time

    q "When would you like to schedule your next appointment?"
    a :datetime

  end
end

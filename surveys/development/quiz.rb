# encoding: UTF-8
survey "Favorites", :dataset_title => 'q_dataTitle' do
  section "Foods" do

    q_dataTitle "What's a good title for this data?"
    a_1 'Data Title', :string

    # In a quiz, both the questions and the answers need to have reference identifiers
    # Here, the question has reference_identifier: "1", and the answers: "oint", "tweet", and "moo"
    q_meat "What is the best meat?", :pick => :one, :correct => "oink"
    a_oink "bacon"
    a_tweet "chicken"
    a_moo "beef"
  end
end

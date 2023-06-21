require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyorController do

  let!(:survey)           { FactoryGirl.create(:survey, :title => "Alphabet", :access_code => "alpha", :survey_version => 0)}
  let!(:survey_beta)      { FactoryGirl.create(:survey, :title => "Alphabet", :access_code => "alpha", :survey_version => 1)}
  let!(:response_set)      { FactoryGirl.create(:response_set, :survey => survey, :access_code => "pdq")}
  let!(:response_set_beta) { FactoryGirl.create(:response_set, :survey => survey_beta, :access_code => "rst")}
  before { ResponseSet.stub(:create).and_return(response_set) }

  before do
    user = double('user')
    allow(user).to receive(:admin?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  context "#edit" do
    def do_get(params = {})
      survey.sections = [FactoryGirl.create(:survey_section, :survey => survey)]
      get :edit, {:locale => 'en', :response_set_code => "pdq"}.merge(params)
    end
    it "renders edit" do
      do_get
      response.should be_success
      response.should render_template('edit')
    end
    it "assigns survey and response set" do
      do_get
      assigns[:survey].should == survey
      assigns[:response_set].should == response_set
    end
    it "redirects for missing response set" do
      do_get :response_set_code => "DIFFERENT"
      response.status.should == 404
    end
    it "assigns earlier survey_version" do
      do_get
      assigns[:response_set].should == response_set
      assigns[:survey].should == survey
    end
    it "assigns later survey_version" do
      survey_beta.sections = [FactoryGirl.create(:survey_section, :survey => survey_beta)]
      do_get :response_set_code => "rst"
      assigns[:survey].should == survey_beta
      assigns[:response_set].should == response_set_beta

    end
  end

  context "#update" do
    let(:responses_ui_hash) { {} }
    let(:update_params) {
      {
        :locale => 'en',
        :response_set_code => "pdq"
      }
    }
    shared_examples "#update action" do
      before do
        ResponseSet.stub(:find_by_access_code).and_return(response_set)
        responses_ui_hash['11'] = {'api_id' => 'something', 'answer_id' => '56', 'question_id' => '9'}
      end
      it "finds a response set" do
        ResponseSet.should_receive(:find_by_access_code).and_return(response_set)
        do_put
      end
      it "saves responses" do
        response_set.should_receive(:update_from_ui_hash).with(responses_ui_hash)

        do_put(:r => responses_ui_hash)
      end
      it "does not fail when there are no responses" do
        lambda { do_put }.should_not raise_error
      end
      context "with update exceptions" do
        it 'retries the update on a constraint violation' do
          response_set.should_receive(:update_from_ui_hash).ordered.with(responses_ui_hash).and_raise(ActiveRecord::StatementInvalid)
          response_set.should_receive(:update_from_ui_hash).ordered.with(responses_ui_hash)

          expect { do_put(:r => responses_ui_hash) }.to_not raise_error
        end

        it 'only retries three times' do
          response_set.should_receive(:update_from_ui_hash).exactly(3).times.with(responses_ui_hash).and_raise(ActiveRecord::StatementInvalid)

          expect { do_put(:r => responses_ui_hash) }.to raise_error(ActiveRecord::StatementInvalid)
        end

        it 'does not retry for other errors' do
          response_set.should_receive(:update_from_ui_hash).once.with(responses_ui_hash).and_raise('Bad news')

          expect { do_put(:r => responses_ui_hash) }.to raise_error('Bad news')
        end
      end
    end

    context "with form submission" do
      def do_put(extra_params = {})
        put :update, update_params.merge(extra_params).merge(locale: 'en')
      end

      it_behaves_like "#update action"

      it "completes the found response set on finish" do
        do_put :finish => 'finish'
        response_set.reload.should be_complete
      end
      it "redirects for missing response set" do
        do_put :response_set_code => "DIFFERENT"
        response.status.should == 404
      end
    end

    context 'with ajax' do
      def do_put(extra_params = {})
        xhr :put, :update, update_params.merge(extra_params)
      end

      it_behaves_like "#update action"
      it "returns dependencies" do
        ResponseSet.stub(:find_by_access_code).and_return(response_set)
        response_set.should_receive(:all_dependencies).and_return({"show" => ['q_1'], "hide" => ['q_2']})

        do_put
        JSON.parse(response.body).should == {"show" => ['q_1'], "hide" => ["q_2"]}
      end
      it "returns 404 for missing response set" do
        do_put :response_set_code => "DIFFERENT"
        response.status.should == 404
      end
    end
  end
end

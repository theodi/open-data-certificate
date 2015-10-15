require_relative '../spec_helper'

describe MainController do

  it 'works' do
    get :home, locale: 'en'
    expect(response).to be_success
  end

end

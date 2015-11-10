require_relative '../spec_helper'

describe Certificate do

  describe '#attained_level' do
    it "starts out as 'none'" do
      cert = Certificate.new
      expect(cert.attained_level).to eql('none')
    end

    it 'cannot be saved as nil' do
      cert = FactoryGirl.create(:certificate)
      cert.attained_level = nil
      expect {
        cert.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end

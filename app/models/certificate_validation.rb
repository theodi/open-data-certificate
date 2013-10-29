class CertificateValidation < ActiveRecord::Base
  belongs_to :user
  belongs_to :certificate

  attr_accessible :value
end

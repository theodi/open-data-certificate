class CertificateValidation < ActiveRecord::Base
  attr_accessible :certificate_id, :user_id, :value
end

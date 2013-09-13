json.version 0.1
json.license "http://opendatacommons.org/licenses/odbl/"
json.certificate do |certificate|
  certificate.partial! 'certificates/certificate', cert: @certificate
end
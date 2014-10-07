json.version 0.1
json.license "http://opendatacommons.org/licenses/odbl/"

json.certificates do
  json.partial! 'certificates/certificate', collection: @datasets.map{|d| d.certificate}, as: :cert
end

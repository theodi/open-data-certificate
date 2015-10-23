require 'spec_helper'

describe DatasetsCSV do

  subject(:exporter) { DatasetsCSV.new(Dataset) }

  it 'generates a url for a dataset' do
    response_set = FactoryGirl.create(:response_set_with_dataset)
    url = exporter.url(:dataset_url, response_set.dataset)
    expect(url).to end_with(dataset_path(response_set.dataset, locale: 'en'))
  end
end

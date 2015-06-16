Given(/^I have a a dataset at the URL "(.*?)"$/) do |url|
  @url = url
end

Given(/^I run the rake task to create a single certificate$/) do
  ENV['URL'] = @url
  ENV['USER_ID'] = @api_user.id.to_s
  execute_rake('certificate_factory', 'certificate')
end

Given(/^the background jobs have all completed$/) do
  Delayed::Job.all.each { |j| j.invoke_job }
end

Then(/^there should be (\d+) certificates?$/) do |count|
  assert_equal count.to_i, Certificate.count
end

Given(/^I have a CKAN atom feed with (\d+) datasets$/) do |num|
  @url = "http://data.gov.uk/feeds/custom.atom"

  feed = """
  <feed xml:lang=\"en\" xmlns=\"http://www.w3.org/2005/Atom\">
    <title>DGU - Custom query</title>
    <link href=\"http://data.gov.uk/feeds/custom.atom\" rel=\"first\"/>
    <link href=\"http://data.gov.uk/feeds/custom.atom\" rel=\"last\"/>
  """

  num.to_i.times do |num|
    feed << """
    <entry>
      <title>Dataset #{num}</title>
      <link href=\"http://data.example.com/dataset#{num}\" rel=\"alternate\"/>
      <link length=\"13307\" href=\"http://data.example.com/api/2/rest/package/dataset#{num}\" type=\"application\/json\" rel=\"enclosure\"/>
    </entry>
    """

    stub_request(:get, "http://data.example.com/api/2/rest/package/dataset#{num}").
                to_return(:status => 200, :body => {
                  'ckan_url' => "http://data.example.com/dataset#{num}"
                }.to_json)
  end

  feed << """
    </feed>
  """

  stub_request(:get, @url).to_return(body: feed)
end

Given(/^I run the rake task to create certificates from the feed$/) do
  ENV['URL'] = @url
  ENV['USER_ID'] = @api_user.id.to_s
  ENV['CAMPAIGN'] = @campaign
  ENV['LIMIT'] = @limit
  execute_rake('certificate_factory', 'certificates')
end

Given(/^I only want (\d+) datasets$/) do |limit|
  @limit = limit
end

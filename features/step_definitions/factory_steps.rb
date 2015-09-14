Given(/^I have a a dataset at the URL "(.*?)"$/) do |url|
  @url = url
end

Given(/^I run the rake task to create a single certificate$/) do
  ENV['URL'] = @url
  ENV['USER_ID'] = @api_user.id.to_s
  execute_rake('certificate_factory', 'certificate')
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

Given(/^I have a CKAN atom feed with (\d+) datasets over (\d+) pages$/) do |total, pages|
  @url = "http://data.gov.uk/feeds/custom.atom"
  total = total.to_i
  pages = pages.to_i

  per_page = (total / pages)

  pages.to_i.times do |page|
    page = page + 1

    feed = """
    <feed xml:lang=\"en\" xmlns=\"http://www.w3.org/2005/Atom\">
      <title>DGU - Custom query</title>
    """

    feed << "<link href=\"http://data.gov.uk/feeds/custom.atom?page=#{page + 1}\" rel=\"next\"/>" unless page == pages

    feed << """
      <link href=\"http://data.gov.uk/feeds/custom.atom\" rel=\"first\"/>
      <link href=\"http://data.gov.uk/feeds/custom.atom?page=#{pages}\" rel=\"last\"/>
    """

    per_page.times do |num|
      feed << """
      <entry>
        <title>Dataset #{page}#{num}</title>
        <link href=\"http://data.example.com/dataset#{page}#{num}\" rel=\"alternate\"/>
        <link length=\"13307\" href=\"http://data.example.com/api/2/rest/package/dataset#{page}#{num}\" type=\"application\/json\" rel=\"enclosure\"/>
      </entry>
      """

      stub_request(:get, "http://data.example.com/api/2/rest/package/dataset#{page}#{num}").
                  to_return(:status => 200, :body => {
                    'ckan_url' => "http://data.example.com/dataset#{page}#{num}"
                  }.to_json)
    end

    feed << """
      </feed>
    """

    if page == 1
      stub_request(:get, @url).to_return(body: feed)
    else
      stub_request(:get, "#{@url}?page=#{page}").to_return(body: feed)
    end
  end

end

Given(/^I run the rake task to create certificates$/) do
  ENV['URL'] = @url
  ENV['USER_ID'] = @api_user.id.to_s
  ENV['CAMPAIGN'] = @campaign
  ENV['LIMIT'] = @limit
  execute_rake('certificate_factory', 'certificates')
end

Given(/^the campaign is created$/) do
  campaign = CertificationCampaign.find_by_name(@campaign)
  CertificateFactory::Factory.new("feed"=>@url,
      "user_id"=>@api_user.id,
      "limit"=>@limit,
      "campaign"=>campaign,
      "jurisdiction"=>"cert-generator").build
end

When(/^the certificates are created$/) do
  Sidekiq::Worker.drain_all
end

Given(/^I only want (\d+) datasets$/) do |limit|
  @limit = limit
end

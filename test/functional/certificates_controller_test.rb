require_relative '../test_helper'

class CertificatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "published certificates can be shown" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    assert_response :success
  end

  test "published certificates with legacy empty kitten_data can be shown" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.response_set.create_kitten_data
    KittenData.any_instance.stubs(:data).returns(false)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    assert_response :success
  end

  test "unpublished certificates can't be shown" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    assert_response 404
  end

  test "unpublished certificates can be shown to their creator" do
    user = FactoryGirl.create(:user)
    sign_in user

    cert = FactoryGirl.create(:certificate_with_dataset)
    cert.response_set.assign_to_user! user

    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}

    assert_response :success
  end

  test "Requesting a JSON version of a certificate returns JSON" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "json"}
    assert_response :success
    assert_equal "application/json", response.content_type
  end

  test "Requesting legacy url performs a redirect" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :legacy_show, {id: cert.id}
    assert_redirected_to dataset_certificate_url dataset_id: cert.dataset.id, id: cert.id
  end

  test "Requesting legacy url for badge performs a redirect" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :legacy_show, {id: cert.id, type: "badge", format: "png"}

    assert_redirected_to "http://test.host/en/datasets/1/certificates/1/badge.png"
  end

  test "Requesting legacy url for embed performs a redirect" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :legacy_show, {id: cert.id, type: "embed"}

    assert_redirected_to "http://test.host/en/datasets/1/certificates/1/embed"
  end

  test "requesting a legacy url with another type returns a not found" do
    # Some spiders are mistaking arguments to juvia as urls to fetch

    cert = FactoryGirl.create(:published_certificate_with_dataset)
    cert.attained_level = "basic"
    cert.save
    get :legacy_show, {id: cert.id, type: "random"}

    assert_response :not_found
  end

  test "Requesting a JSON version of a certificate returns the correct level" do
    levels = {
        "basic" => "bronze",
        "pilot" => "silver",
        "standard" => "gold",
        "exemplar" => "platinum"
      }

    levels.each do |level, actual|
      cert = FactoryGirl.create(:"published_#{level}_certificate_with_dataset")
      get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "json"}

      json = JSON.parse(response.body)

      assert_equal actual, json["certificate"]["level"]
    end
  end

  test "Requesting a JSON version of a certificate returns the correct juristiction and status" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "json"}

    json = JSON.parse(response.body)

    assert_equal "Simple survey", json["certificate"]["jurisdiction"]
    assert_equal "alpha", json["certificate"]["status"]
  end

  test "Requesting a JSON version of a certificate returns the correct badge urls" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "json"}

    json = JSON.parse(response.body)

    assert_equal "http://test.host/en/datasets/1/certificate/badge.js", json["certificate"]["badges"]["application/javascript"]
    assert_equal "http://test.host/en/datasets/1/certificate/badge.html", json["certificate"]["badges"]["text/html"]
    assert_equal "http://test.host/en/datasets/1/certificate/badge.png", json["certificate"]["badges"]["image/png"]
  end

  test "Requesting a JSON version of a certificate in production returns https urls" do
    Rails.env.stubs :production? => true
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :show, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "json"}

    json = JSON.parse(response.body)

    assert_match /https:\/\//, json["certificate"]["uri"]
    assert_match /https:\/\//, json["certificate"]["badges"]["application/javascript"]
    assert_match /https:\/\//, json["certificate"]["badges"]["text/html"]
    assert_match /https:\/\//, json["certificate"]["badges"]["image/png"]
    assert_match /https:\/\//, json["certificate"]["dataset"]["uri"]
  end

  test "requesting the png badge image" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    get :badge, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, format: "png"}

    assert_equal File.read(File.join(Rails.root, 'app/assets/images/badges/basic_level_badge.png')), response.body
  end

  test "mark certificate as valid" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:user)
    sign_in user

    assert_difference ->{cert.verifications.count}, 1 do
      post :verify, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end
  end

  test "sign in to mark certificate as valid" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:user)

    assert_no_difference ->{cert.verifications.count} do
      post :verify, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end

    assert_redirected_to dataset_certificate_url dataset_id: cert.dataset.id, id: cert.id

  end

  test "undo validation" do
    cv = FactoryGirl.create(:verification, certificate: FactoryGirl.create(:certificate_with_dataset))
    cert = cv.certificate
    sign_in cv.user

    assert_difference ->{cert.verifications.count}, -1 do
      post :verify, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, undo: true}
    end
  end

  test "Non-admin tries to mark a certificate as audited" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:user)
    sign_in user

    put :update, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, audited: true}

    assert_response 403
  end

  test "Admin marks a certificate as audited" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    user = FactoryGirl.create(:admin_user)
    sign_in user

    assert_equal false, cert.audited

    put :update, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, certificate: {audited: true}}

    cert.reload
    assert_equal true, cert.audited
  end

  test "Admin unmarks a certificate as audited" do
    cert = FactoryGirl.create(:published_audited_certificate_with_dataset)
    user = FactoryGirl.create(:admin_user)
    sign_in user

    assert_equal true, cert.audited

    put :update, {locale: :en, dataset_id: cert.dataset.id, id: cert.id, certificate: {audited: false}}

    cert.reload
    assert_equal false, cert.audited
  end

  test "creates an embed stat when a badge is embeded" do
    @request.env['HTTP_REFERER'] = 'http://example.com'

    cert = FactoryGirl.create(:published_certificate_with_dataset)

    assert_difference ->{cert.dataset.embed_stats.count}, 1 do
      get :badge, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end
  end

  test "creates an embed stat when default badge is embeded" do
    @request.env['HTTP_REFERER'] = 'http://example.com'

    cert = FactoryGirl.create(:published_certificate_with_dataset)

    assert_difference ->{cert.dataset.embed_stats.count}, 1 do
      get :badge, {locale: :en, dataset_id: cert.dataset.id}
    end
  end

  test "doesn't create a stat when there is no referrer" do
    @request.env['HTTP_REFERER'] = nil

    cert = FactoryGirl.create(:published_certificate_with_dataset)

    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end
    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id}
    end
  end

  test "doesn't create a stat when unpublished" do
    @request.env['HTTP_REFERER'] = 'http://example.com'

    cert = FactoryGirl.create(:certificate_with_dataset)

    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end
    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id}
    end
  end

  test "doesn't create a stat when the referrer is local" do
    @request.env['HTTP_REFERER'] = 'http://test.host/example.html'

    cert = FactoryGirl.create(:published_certificate_with_dataset)

    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id, id: cert.id}
    end
    assert_no_difference ->{cert.dataset.embed_stats.count} do
      get :badge, {locale: :en, dataset_id: cert.dataset.id}
    end
  end

  test "reporting certificate requires user to be logged in" do
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id
    assert_response :found
  end

  test "reporting certificate sends an email" do
    user = FactoryGirl.create(:user)
    sign_in user
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      Delayed::Worker.new.work_off 1
    end
  end

  test "reporting certificate includes the reasons" do
    user = FactoryGirl.create(:user)
    sign_in user
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id, reasons: "broken"
    Delayed::Worker.new.work_off 1
    assert_match /broken/, ActionMailer::Base.deliveries.last.body.to_s
  end

  test "reporting certificate includes remote ip" do
    user = FactoryGirl.create(:user)
    sign_in user
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    @request.env['REMOTE_ADDR'] = '255.0.0.1'
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id
    Delayed::Worker.new.work_off 1
    assert_match /255.0.0.1/, ActionMailer::Base.deliveries.last.body.to_s
  end

  test "reporting certificate includes user agent" do
    user = FactoryGirl.create(:user)
    sign_in user
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    @request.env['HTTP_USER_AGENT'] = 'Web Browser/1.0'
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id
    Delayed::Worker.new.work_off 1
    assert_match /Web Browser\/1.0/, ActionMailer::Base.deliveries.last.body.to_s
  end

  test "reporting certificate has email of user as sender" do
    user = FactoryGirl.create(:user)
    sign_in user
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    post :report, locale: 'en', dataset_id: certificate.dataset.id, id: certificate.id
    Delayed::Worker.new.work_off 1
    assert ActionMailer::Base.deliveries.last.from.include?(user.email)
  end

  test "finds latest certificate when no :id specified" do
    old_certificate = nil
    Timecop.freeze(3.days.ago) do
      old_certificate = FactoryGirl.create(:published_certificate_with_dataset)
    end
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    certificate.response_set.update_attribute(:dataset_id, old_certificate.dataset.id)
    old_certificate.response_set.archive!
    dataset = old_certificate.dataset

    assert_equal dataset.id, certificate.dataset.id

    get :show, locale: 'en', dataset_id: certificate.dataset.id

    assert_equal certificate, assigns(:certificate)
  end

  test "find certificate by dataset_url redirects to certificate path" do
    certificate = FactoryGirl.create(:published_certificate_with_dataset)
    dataset = certificate.dataset

    get :certificate_from_dataset_url, :datasetUrl => dataset.documentation_url

    assert_redirected_to dataset_certificate_path(dataset.id, certificate.id)
  end

  test "find certificate by dataset_url 404s on unfound dataset" do
    get :certificate_from_dataset_url, :datasetUrl => "http://example.org"

    assert_response :not_found
  end

  test "find certificate by dataset_url 404s on unpublished certificate" do
    certificate = FactoryGirl.create(:certificate_with_dataset)
    dataset = certificate.dataset

    get :certificate_from_dataset_url, :datasetUrl => dataset.documentation_url

    assert_response :not_found
  end

  test "badge returns not found if certificate is draft" do
    cert = FactoryGirl.create(:certificate_with_dataset)
    get :badge, {locale: :en, dataset_id: cert.dataset.id}
    assert_response 404
  end

end

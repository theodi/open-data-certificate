require_relative '../test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  def setup
    stub_request(:head, "http://www.example.com/error").to_return(status: 200)
    load_custom_survey 'cert_generator.rb'
    @user = FactoryGirl.create :user
  end

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: {}, user: @user).generate('blank', false)

      certificate = Certificate.last

      assert certificate.published
      assert_equal 'blank', CertificateGenerator.last.survey.access_code
    end
  end

  test "creating certificate which auto publishes" do

    dataset = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      generator = CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      assert CertificateGenerator.last.completed

      certificate = Certificate.last

      assert certificate.published
      assert_equal 1, Certificate.count
    end
  end

  test "creating certificate with missing field" do

    dataset = {
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      certificate = Certificate.last

      refute certificate.published
    end
  end

  test "creating certificate with invalid URL" do
    stub_request(:head, "http://www.example.com/error").
                to_return(status: 404)

    dataset = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com/error',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      refute Certificate.last.published
    end
  end

  test "publishing a certificate after creating and updating it" do

    create = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
    }

    update = {
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
      refute Certificate.last.published
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal({}, response[:errors])
    end
  end

  test "updating a certificate with a missing field" do

    create = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    update = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherRights: 'yes',
      publisherUrl: '',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
      assert Certificate.last.published
    end

    assert_difference 'ResponseSet.count', 1 do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal({'publisherUrl' => ['mandatory']}, response[:errors])
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal({'publisherUrl' => ['mandatory']}, response[:errors])
    end
  end

  test "updating a certificate after the survey has been updated" do

      create = {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }

      update = {
        dataTitle: 'The title 2',
      }

      assert_difference 'ResponseSet.count', 1 do
        CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
        assert Certificate.last.published
      end

      assert_difference 'Survey.count', 1 do
        load_custom_survey 'cert_generator_updated.rb'
      end

      assert_difference 'ResponseSet.count', 1 do
        response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
        assert_equal(true, response[:success])
        assert_equal(false, response[:published])
        assert_equal({'favouriteAnimal' => ['mandatory']}, response[:errors])
      end
    end

  test "determining contact email for dataset creates new user from publisher contact email" do
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = [DataKitten::Agent.new(mbox: 'test@datapub.org')]
    kd[:data][:maintainers] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]
    kd[:data][:contributors] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]

    user = generator.determine_user(response_set, true)

    assert user.persisted?
    assert_equal 'test@datapub.org', user.email
  end

  test "determining contact email for dataset finds user from publisher contact email" do
    existing_user = FactoryGirl.create(:user, email: 'test@datapub.org')
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = [DataKitten::Agent.new(mbox: 'test@datapub.org')]
    kd[:data][:maintainers] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]
    kd[:data][:contributors] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]

    found_user = generator.determine_user(response_set, true)

    assert_equal existing_user, found_user
  end

  test "determing contact email uses maintainer if no publisher present" do
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = []
    kd[:data][:maintainers] = [DataKitten::Agent.new(mbox: 'test@datapub.org')]
    kd[:data][:contributors] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]

    user = generator.determine_user(response_set, true)

    assert user.persisted?
    assert_equal 'test@datapub.org', user.email
  end

  test "determing contact email uses contributor if no publisher present" do
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = []
    kd[:data][:maintainers] = nil
    kd[:data][:contributors] = [
      DataKitten::Agent.new(mbox: ''),
      DataKitten::Agent.new(mbox: 'test@datapub.org')
    ]

    user = generator.determine_user(response_set, true)

    assert user.persisted?
    assert_equal 'test@datapub.org', user.email
  end

  test "finds first existant user before trying to create an owner" do
    existing_user = FactoryGirl.create(:user, email: 'present@datapub.org')
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = [DataKitten::Agent.new(mbox: 'test@datapub.org')]
    kd[:data][:maintainers] = [DataKitten::Agent.new(mbox: 'present@datapub.org')]
    kd[:data][:contributors] = [DataKitten::Agent.new(mbox: 'wrong@datapub.org')]

    found_user = generator.determine_user(response_set, true)

    assert_equal existing_user, found_user
  end

  test "does not create user if create is false" do
    generator = CertificateGenerator.create(request: {}, user: @user)
    response_set = generator.build_response_set
    response_set.kitten_data = kd = KittenData.new
    kd[:data][:publishers] = []
    kd[:data][:maintainers] = nil
    kd[:data][:contributors] = [DataKitten::Agent.new(mbox: 'test@datapub.org')]

    user = generator.determine_user(response_set, false)

    assert_equal user, @user
  end

  test "creating a user when already exists" do
    existing_user = FactoryGirl.create(:user, email: 'present@datapub.org')
    generator = CertificateGenerator.create(request: {}, user: @user)
    user = generator.create_user_from_contact(DataKitten::Agent.new(mbox: 'present@datapub.org'))
    assert_equal existing_user, user
  end

  test "bulk update queues completed generators to be updated" do
    Sidekiq::Testing.fake! do
      generator = CertificateGenerator.create(request: {}, user: @user, completed: true)
      generator2 = CertificateGenerator.create(request: {}, user: @user, completed: false)
      collection = [generator, generator2]
      result = CertificateGenerator.bulk_update(collection, 'gb', @user)
      assert_equal 1, result[:skipped]
      assert_equal 1, result[:queued]
    end    
  end


  test "compares and adopts responses that are not available in current response_set" do
    default = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    sparse = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    template_cg=CertificateGenerator.create(request: default, user: @user)
    template_cg.generate('cert-generator', false)
    new_cg=CertificateGenerator.create(request: sparse, user: @user)
    new_cg.generate('cert-generator', false)
    
    response_count = new_cg.response_set.responses.count
    difference = template_cg.response_set.responses.count - response_count

    extra_responses = new_cg.compare_responses(template_cg.response_set)
    assert_true extra_responses.count.eql?(difference)
    
    new_cg.adopt_responses(extra_responses)
    assert_true new_cg.response_set.responses.count.eql?(response_count + difference)
  end

end

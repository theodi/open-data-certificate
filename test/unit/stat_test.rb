require 'test_helper'

class StatTest < ActiveSupport::TestCase

  test "with published certificates correct count for all certificates is generated" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end

    s = Stat.generate_published
    assert_equal s.all, 5
  end

  test "with published certificates correct counts for levels are generated" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    4.times do
      FactoryGirl.create(:published_pilot_certificate_with_dataset)
    end
    3.times do
      FactoryGirl.create(:published_standard_certificate_with_dataset)
    end
    2.times do
      FactoryGirl.create(:published_exemplar_certificate_with_dataset)
    end

    s = Stat.generate_published

    assert_equal s.level_basic, 5
    assert_equal s.level_pilot, 4
    assert_equal s.level_standard, 3
    assert_equal s.level_exemplar, 2
  end

  test "with published certificates correct correct counts for expired certificates are generated" do
    2.times do
      FactoryGirl.create(:published_certificate_with_dataset, expires_at: DateTime.now - 1.year)
    end

    s = Stat.generate_published

    assert_equal s.expired, 2
  end

  test "with published certificates correct correct counts for publishers are generated" do
    ['Batman', 'Wonder Woman', 'Superman'].each do |hero|
      cert = FactoryGirl.create(:published_certificate_with_dataset)
      cert.curator = hero
      cert.save
    end

    s = Stat.generate_published

    assert_equal s.publishers, 3
  end

  test "with published certificates correct correct counts for certificates this month are generated" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end

    5.times do
      FactoryGirl.create(:published_certificate_with_dataset, created_at: 2.month.ago)
    end

    s = Stat.generate_published

    assert_equal s.this_month, 5
  end

end

require 'test_helper'

class StatTest < ActiveSupport::TestCase

  context "with published certificates" do

    should "type is generated" do
      s = Stat.generate_published

      assert_equal s.name, 'published'
    end

    should "correct count for all certificates is generated" do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
      end

      s = Stat.generate_published
      assert_equal s.all, 5
    end

    should "correct counts for levels are generated" do
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

    should "correct correct counts for expired certificates are generated" do
      2.times do
        FactoryGirl.create(:published_certificate_with_dataset, expires_at: DateTime.now - 1.year)
      end

      s = Stat.generate_published

      assert_equal s.expired, 2
    end

    should "correct correct counts for publishers are generated" do
      ['Batman', 'Wonder Woman', 'Superman'].each do |hero|
        cert = FactoryGirl.create(:published_certificate_with_dataset)
        cert.curator = hero
        cert.save
      end

      s = Stat.generate_published

      assert_equal s.publishers, 3
    end

    should "correct correct counts for certificates this month are generated" do
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

  context "with all certificates" do

    should "type is generated" do
      s = Stat.generate_all

      assert_equal s.name, 'all'
    end

    should "correct count for all certificates is generated" do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
      end
      5.times do
        FactoryGirl.create(:certificate_with_dataset)
      end

      s = Stat.generate_all
      assert_equal s.all, 10
    end

    should "correct counts for levels are generated" do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
        c = FactoryGirl.create(:published_certificate_with_dataset)
        c.response_set.aasm_state = "draft"
        c.response_set.save
        c.aasm_state = "draft"
        c.save
      end
      4.times do
        FactoryGirl.create(:published_pilot_certificate_with_dataset)
        c = FactoryGirl.create(:published_pilot_certificate_with_dataset)
        c.response_set.aasm_state = "draft"
        c.response_set.save
        c.aasm_state = "draft"
        c.save
      end
      3.times do
        FactoryGirl.create(:published_standard_certificate_with_dataset)
        c = FactoryGirl.create(:published_standard_certificate_with_dataset)
        c.response_set.aasm_state = "draft"
        c.response_set.save
        c.aasm_state = "draft"
        c.save
      end
      2.times do
        FactoryGirl.create(:published_exemplar_certificate_with_dataset)
        c = FactoryGirl.create(:published_exemplar_certificate_with_dataset)
        c.response_set.aasm_state = "draft"
        c.response_set.save
        c.aasm_state = "draft"
        c.save
      end

      s = Stat.generate_all

      assert_equal s.level_basic, 10
      assert_equal s.level_pilot, 8
      assert_equal s.level_standard, 6
      assert_equal s.level_exemplar, 4
    end

    should "correct correct counts for expired certificates are generated" do
      2.times do
        FactoryGirl.create(:published_certificate_with_dataset, expires_at: DateTime.now - 1.year)
      end
      2.times do
        FactoryGirl.create(:certificate_with_dataset, expires_at: DateTime.now - 1.year)
      end

      s = Stat.generate_all

      assert_equal s.expired, 4
    end

    should "correct correct counts for publishers are generated" do
      ['Batman', 'Wonder Woman', 'Superman'].each do |hero|
        cert = FactoryGirl.create(:published_certificate_with_dataset)
        cert.curator = hero
        cert.save
      end

      cert = FactoryGirl.create(:certificate_with_dataset)
      cert.curator = 'Iron Man'

      s = Stat.generate_all

      assert_equal s.publishers, 4
    end

    should "correct correct counts for certificates this month are generated" do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
        c = FactoryGirl.create(:certificate_with_dataset)
      end

      5.times do
        FactoryGirl.create(:published_certificate_with_dataset, created_at: 2.month.ago)
        FactoryGirl.create(:certificate_with_dataset, created_at: 2.month.ago)
      end

      s = Stat.generate_all

      assert_equal s.this_month, 10
    end

  end

  should "generate a correct csv row" do
    stat = FactoryGirl.create(:all_stat,
                              all: 10,
                              expired: 5,
                              publishers: 5,
                              this_month: 2,
                              level_none: 6,
                              level_basic: 5,
                              level_pilot: 4,
                              level_standard: 3,
                              level_exemplar: 2
                            )

    assert_equal stat.csv_row, [Date.today.iso8601, 10, 5, 5, 2, 6, 5, 4, 3, 2]
  end

  should "generate a csv correctly" do
    5.times do
      FactoryGirl.create(:all_stat)
    end

    2.times do
      FactoryGirl.create(:published_stat)
    end

    csv = CSV.parse(Stat.csv("all"))

    assert_equal 6, csv.count
  end

end

FactoryGirl.define do

  factory :stat do |s|
    s.all 0
    s.expired 0
    s.publishers 0
    s.this_month 0
    s.level_none 0
    s.level_basic 0
    s.level_pilot 0
    s.level_standard 0
    s.level_exemplar 0

    factory :all_stat do |s|
      s.name "all"
    end

    factory :published_stat do |s|
      s.name "published"
    end
  end

end

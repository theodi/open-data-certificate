module Counts
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def counts
      Hash[[:all, :all_this_month, :published, :published_this_month, :levels].map do |count|
        [count, Certificate.send("count_#{count}")]
      end]
    end

    def count_levels
      Hash[[:basic, :pilot, :standard, :expert].map do |level|
        [level, Certificate.where(published: true, attained_level: level).count]
      end]
    end

    def count_all
      Certificate.count
    end

    def count_all_this_month
      Certificate.where(created_at: within_last_month).count
    end

    def count_published
      Certificate.where(published: true).count
    end

    def count_published_this_month
      Certificate.where(published: true, created_at: within_last_month).count
    end

    def within_last_month
      (Time.now - 1.month)..Time.now
    end

  end

end

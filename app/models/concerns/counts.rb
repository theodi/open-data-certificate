module Counts
  extend ActiveSupport::Concern

  class << self

    def counts
      Hash[[:all, :all_this_month, :published, :published_this_month, :levels].map do |count|
        [count, Certificate::Counts.send(count)]
      end]
    end

    def levels
      Hash[[:basic, :pilot, :standard, :expert].map do |level|
        [level, Certificate.where(published: true, attained_level: level).count]
      end]
    end

    def all
      Certificate.count
    end

    def all_this_month
      Certificate.where(created_at: within_last_month).count
    end

    def published
      Certificate.where(published: true).count
    end

    def published_this_month
      Certificate.where(published: true, created_at: within_last_month).count
    end

    def within_last_month
      (Time.now - 1.month)..Time.now
    end

  end

end

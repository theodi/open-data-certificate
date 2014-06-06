module Stats

   module Certificate

     def self.counts
       Hash[[:all, :all_this_month, :published, :published_this_month, :levels].map do |count|
         [count, self.send("#{count}")]
       end]
     end

     def self.levels
       Hash[[:basic, :pilot, :standard, :expert].map do |level|
         [level, ActiveRecord::Base::Certificate.where(published: true, attained_level: level).count]
       end]
     end

     def self.all
       ActiveRecord::Base::Certificate.count
     end

     def self.all_this_month
       ActiveRecord::Base::Certificate.where(created_at: Stats.within_last_month).count
     end

     def self.published
       ActiveRecord::Base::Certificate.where(published: true).count
     end

     def self.published_this_month
       ActiveRecord::Base::Certificate.where(published: true, created_at: Stats.within_last_month).count
     end

   end

   class ResponseSet

     def self.counts
       Hash[[:all, :all_datasets, :all_datasets_this_month, :published_datasets, :published_datasets_this_month].map do |count|
         [count, ResponseSet.send(count)]
       end]
     end

     def self.all
       ActiveRecord::Base::ResponseSet.count
     end

     def self.all_datasets
      ActiveRecord::Base:: ResponseSet.select("DISTINCT(dataset_id)").count
     end

     def self.all_datasets_this_month
       ActiveRecord::Base::ResponseSet.select("DISTINCT(dataset_id)").where(created_at: Stats.within_last_month).count
     end

     def self.published_datasets
       ActiveRecord::Base::ResponseSet.published.select("DISTINCT(dataset_id)").count
     end

     def self.published_datasets_this_month
       ActiveRecord::Base::ResponseSet.published.select("DISTINCT(dataset_id)").where(created_at: Stats.within_last_month).count
     end

   end

   def self.within_last_month
     (Time.now - 1.month)..Time.now
   end

end

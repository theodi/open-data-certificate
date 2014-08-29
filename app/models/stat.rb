class Stat < ActiveRecord::Base

  def self.generate(type, result)
    s = create
    s.name = type
    s.all = result.count
    s.expired = result.select {|r| r.certificate.expires_at < DateTime.now rescue nil}.count
    s.publishers = result.uniq_by { |d| d.certificate.curator }.count
    s.this_month = result.select {|r| r.certificate.created_at >= Time.now - 1.month }.count

    ['none', 'basic', 'pilot', 'standard', 'exemplar'].each do |level|
      s.send("level_#{level}=", result.select{|r| r.certificate.attained_level == level}.count)
    end

    s.save
    s
  end

  def self.generate_published
    result = ResponseSet.where(aasm_state: ['published']).all(:group => :dataset_id)
    generate('published', result)
  end

  def self.generate_all
    result = ResponseSet.where(aasm_state: ['draft', 'published']).all(:group => :dataset_id)
    generate('all', result)
  end

end

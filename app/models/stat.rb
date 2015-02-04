class Stat < ActiveRecord::Base

  def self.generate(type, result)
    create({
        name: type,
        all: result.count,
        expired: expired(result),
        publishers: publishers(result),
        this_month: this_month(result),
        level_none: level('none', result),
        level_basic: level('basic', result),
        level_pilot: level('pilot', result),
        level_standard: level('standard', result),
        level_exemplar: level('exemplar', result),
      })
  end

  def self.expired(result)
    result.select {|r| r.certificate.expires_at < DateTime.now rescue nil}.count
  end

  def self.publishers(result)
    result.uniq_by { |d| d.certificate.curator }.count
  end

  def self.this_month(result)
    result.select {|r| r.certificate.created_at.month == Date.today.month }.count
  end

  def self.level(level, result)
    result.select{|r| r.certificate.attained_level == level}.count
  end

  def self.generate_published
    result = ResponseSet.where(aasm_state: ['published']).all(:group => :dataset_id)
    generate('published', result)
  end

  def self.generate_all
    result = ResponseSet.where(aasm_state: ['draft', 'published']).all(:group => :dataset_id)
    generate('all', result)
  end

  def self.csv(name)
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << csv_cols.map { |c| c.humanize.titleize }
      where(name: name).each { |s| csv << s.csv_row }
    end
  end

  def self.csv_cols
    ["date"] + (column_names - ["id", "name", "updated_at", "created_at"])
  end

  def csv_row
    Stat.csv_cols.map { |c| send(c) }
  end

  def date
    created_at.to_date.iso8601
  end

end

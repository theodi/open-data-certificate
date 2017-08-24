class UserExport

  def self.perform
    file = upload
    file.public_url
  end

  def self.users
    User.engaged_users
  end

  def self.csv
    CSV.generate do |csv|
      csv << ['Name', 'Email']
      users.each { |u| csv << [u.name, u.email] }
    end
  end

  def self.write_file
    tmp = Tempfile.new('users.csv')
    tmp.write csv
    tmp.rewind
    tmp.close
    tmp
  end

  def self.upload
    tmp = write_file
    Rackspace.upload('users.csv', File.open(tmp.path), {
      content_type: 'text/csv',
      content_disposition: 'attachment',
      public: true
    })
  end

end

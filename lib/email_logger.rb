class EmailLogger

  def delivering_email(mail)
    title = " YOU HAVE MAIL "
    width = 80
    puts title.rjust((width+title.length)/2, "=").ljust(width, "=")
    puts "To: #{mail.to.join(', ')}"
    puts "From: #{mail.from.join(', ')}"
    puts "Subject: #{mail.subject}"
    puts
    puts mail.body
    puts "=" * width
  end

end

require 'rss'



class XMLFeed

  # Atom class, which will handle all xml parsing/converting, or whatever features
  # are needed.
  class Atom

    # *************************************************************************************
    # This function will rely on the current route paths, as it uses the certificate / dataset path.
    #
    # *************************************************************************************
    def self.dataset_to_feed(dataset,atom_url)
      # Makes sure is dataset.
      return nil if(dataset.class != Dataset)
      dataset_url = atom_url
      dataset_url=chop_url(dataset_url)
      certificates=dataset.certificates.where(:published => true).by_newest

      @rss = RSS::Maker.make("atom") do |maker|
        user = dataset.user
        maker.channel.author =  "#{user.first_name} #{user.last_name}"
        maker.channel.updated = dataset.updated_at.to_s
        maker.channel.id = atom_url.to_s
        maker.channel.title = dataset.title.to_s
        maker.channel.link = dataset.documentation_url.to_s

        certificates.each do |certificate|
          maker.items.new_item do |item|
            item.link = "#{dataset_url}certificates/#{certificate.id}"
            item.title = certificate.name
            item.content.content = certificate.attained_level
            item.updated = certificate.updated_at.to_s
            item.id = "#{dataset_url}certificates/#{certificate.id}"
          end
        end
     end
     return @rss
    end


    # The purpose of this function is to get the dataset url by chopping off the added '/to_atom' from the url.
    def self.chop_url(url)
        url=url.chop
        while(url[-1] != "/")
          url=url.chop
        end
        return url
    end

  end
end



require 'rss'

class XMLFeed

  # Atom class, which will handle all xml parsing/converting, or whatever features
  # are needed.
  class Atom
    class << self
      # The atom-making methods are class methods, so to get access to route-helpers
      #   we need to include them in the eigenclass
      include Rails.application.routes.url_helpers
    end

    # *************************************************************************************
    # This function will rely on the current route paths, as it uses the certificate / dataset path.
    #
    # *************************************************************************************
    def self.dataset_to_feed(dataset, protocol, host)
      # Makes sure is dataset.
      return unless dataset.is_a?(Dataset)

      RSS::Maker.make("atom") do |maker|
        maker.channel.author =  dataset.user_full_name
        maker.channel.updated = dataset.updated_at.to_s
        maker.channel.id = dataset_url(dataset, host: host, format: :feed)
        maker.channel.title = dataset.title
        maker.channel.link = dataset.documentation_url

        dataset.certificates.where(published: true).by_newest.each do |certificate|
          maker.items.new_item do |item|
            item.link = dataset_certificate_url(dataset, certificate, host: host, protocol: protocol)
            item.title = certificate.name
            item.content.content = certificate.attained_level
            item.updated = certificate.updated_at.to_s
            item.id = item.link
          end
        end
      end
    end
    
    def self.datasets_to_feed(title, datasets, protocol, host, path)
      
      RSS::Maker.make("atom") do |maker|
        maker.channel.updated = DateTime.now.to_s
        maker.channel.id = protocol + host + path
        maker.channel.title = title
        maker.channel.link = protocol + host + path
        maker.channel.author =  "Open Data Institute"

        datasets.each do |dataset|
          maker.items.new_item do |item|
            item.title = dataset.title
            item.link = dataset_url(dataset, host: host, protocol: protocol)
            item.content.content = dataset.certificate.attained_level_title
            item.updated = dataset.updated_at.to_s
            item.id = item.link
          end
        end
      end
    end

  end
end



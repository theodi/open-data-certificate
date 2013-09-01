require 'rss'

class XMLFeed

  # Atom class, which will handle all xml parsing/converting, or whatever features
  # are needed.
  class Atom

    # *************************************************************************************
    # This function will rely on the current route paths, as it uses the certificate / dataset path.
    #
    # *************************************************************************************
    def self.dataset_to_feed(dataset, host)
      # Makes sure is dataset.
      return unless dataset.is_a?(Dataset)

      RSS::Maker.make("atom") do |maker|
        maker.channel.author =  dataset.user_full_name
        maker.channel.updated = dataset.updated_at.to_s
        maker.channel.id = Rails.application.routes.url_helpers.dataset_atom_url(dataset, host: host)
        maker.channel.title = dataset.title
        maker.channel.link = dataset.documentation_url

        dataset.certificates.where(published: true).by_newest.each do |certificate|
          maker.items.new_item do |item|
            item.link = Rails.application.routes.url_helpers.dataset_certificate_url(dataset, certificate, host: host)
            item.title = certificate.name
            item.content.content = certificate.attained_level
            item.updated = certificate.updated_at.to_s
            item.id = item.link
          end
        end
      end
    end

  end
end



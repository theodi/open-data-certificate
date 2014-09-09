class EmbedStatsController < ActionController::Base

  def index
    render text: EmbedStat.csv, content_type: "text/csv; header=present"
  end

end

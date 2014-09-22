class EmbedStatsController < ActionController::Base

  def index
    send_data EmbedStat.csv, filename: "badges.csv", type: "text/csv; header=present; charset=utf-8"
  end

end

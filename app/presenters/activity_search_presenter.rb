class ActivitySearchPresenter
  include Search::DateFormat

  attr_reader :start_date, :end_date, :query
  def initialize(query, user, date_search_attr="created_at")
    @query = Search::QueryDefaults.new(query[:q] || {}, date_search_attr).query
    @user = user

    @start_date = format_date(@query["#{date_search_attr}_date_gteq".to_s])
    @end_date = format_date(@query["#{date_search_attr}_date_lteq".to_s])
  end
end

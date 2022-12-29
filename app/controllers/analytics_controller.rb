# frozen_string_literal: true

class AnalyticsController < AuthenticatedController
  authorize_resource class: false

  def index; end

  def average_search_time
    @data = @organization.searches.completed.where(created_at: timeframe..).group(:category)
      .average("completed_at - created_at").map do |type, average|
      { type: type.titleize, average: ActiveSupport::Duration.build(average).inspect.gsub(/,? and.+/, "") }
    end
  end

  def average_no_per_search
    no_results_count = @organization.results.includes(:search)
      .where(state: "declined").where(created_at: timeframe..).where.not(searches: { completed_at: nil }).size
    completed_searches_count = @organization.searches.completed.size
    @data = (no_results_count / completed_searches_count.to_f).round(2)
    @title = "Average No's per Search"
  end

  def average_time_per_search
    average = @organization.searches.completed.where(created_at: timeframe..).average("completed_at - created_at")
    @data = average ? ActiveSupport::Duration.build(average).inspect.gsub(/,? and.+/, "") : average
    @title = "Average Time to Complete a Search"
  end

  def average_yes_per_search
    yes_results_count = @organization.results.includes(:search)
      .where(searches: { created_at: timeframe.. }, state: "selected")
      .where.not(searches: { completed_at: nil }).size
    completed_searches_count = @organization.searches.completed.size
    @data = (yes_results_count / completed_searches_count.to_f).round(2)
    @title = "Average Yes's per Search"
  end

  def search_types
    grouped_search_types = @organization.searches.where(created_at: timeframe..).group(:category).count
    grouped_search_types = Search.categories.map { |type, _| [type, 0] }.to_h if grouped_search_types.empty?
    @data = grouped_search_types.map { |type, count| { type: type.titleize, count: } }.to_json
  end

  def searches_by_created_at
    @data = {}
    @organization.searches.where(created_at: timeframe..).group_by_day_of_week(:created_at,
      format: "%A").group_by_hour_of_day(:created_at).count.each do |day_and_hour, count|
      day, hour = day_and_hour
      @data[day] ||= Array.new(24, 0)
      @data[day][hour] += count
    end

    labels = []
    start_day = :sunday
    # rubocop:disable Lint/UselessAssignment
    # We aren't actually assigning the variable here but rubocop thinks we are
    beginning_of_week = Time.zone.now.beginning_of_week(start_day = start_day)
    end_of_week = Time.zone.now.end_of_week(start_day = start_day)
    # rubocop:enable Lint/UselessAssignment
    (beginning_of_week.to_i..end_of_week.to_i).step(1.hour) do |date|
      labels << Time.zone.at(date).strftime("%a %-l %p")
    end.map(&:to_s)
    @data = {
      labels: labels,
      datasets: [
        {
          label: "Searches",
          data: @data.values.flatten,
        },
      ],
    }.to_json
  end

  private

  def timeframe
    @timeframe = case params[:timeframe]
    when "YTD" # Year to date
      Time.zone.now.beginning_of_year
    when /\d+/ # Days
      params[:timeframe].to_i.days.ago
    else # All time
      Time.zone.at(0)
    end
  end
end

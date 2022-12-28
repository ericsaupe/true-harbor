# frozen_string_literal: true

class AnalyticsController < AuthenticatedController
  authorize_resource class: false

  def index; end

  def search_types
    @data = @organization.searches.group(:category).count.map { |type, count| { type: type.titleize, count: } }.to_json
  end

  def searches_by_created_at
    @data = {}
    @organization.searches.group_by_day_of_week(:created_at,
      format: "%A").group_by_hour_of_day(:created_at).count.each do |day_and_hour, count|
      day, hour = day_and_hour
      @data[day] ||= Array.new(24, 0)
      @data[day][hour] += count
    end
    # @data = @data.map { |label, count| { label:, count: } }.to_json

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
end

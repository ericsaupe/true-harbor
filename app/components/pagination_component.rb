# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  def initialize(records:, page: 1, records_per_page: 25)
    @records = records.page(page).per(records_per_page)
    @page = page
    @records_per_page = records_per_page
  end
end

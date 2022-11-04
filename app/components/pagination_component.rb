# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  def initialize(records:, page: 1)
    @records = records.page(page)
    @page = page
  end
end

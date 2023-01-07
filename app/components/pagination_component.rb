# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  def initialize(records:, page: 1, **kwargs)
    @kwargs = kwargs
    @records = records.page(page)
    @page = page
  end
end

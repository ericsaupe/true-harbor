# frozen_string_literal: true

class PageHeaderComponent < ViewComponent::Base
  def initialize(page_title:)
    @page_title = page_title
  end
end

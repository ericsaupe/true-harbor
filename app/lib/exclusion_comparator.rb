# frozen_string_literal: true

class ExclusionComparator
  class << self
    def exclusion_hit?(search: nil, exclusion:)
      return false if search.nil?

      search.children.any? do |child|
        (exclusion.gender == "any" || exclusion.gender == child.gender) &&
          (
            (exclusion.comparator == "less_than" && child.age < exclusion.age) ||
            (exclusion.comparator == "greater_than" && child.age > exclusion.age)
          )
      end
    end
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can(:manage, Child, search_id: Search.where(organization_id: user.organization_id).pluck(:id))
    can(:manage, Exclusion, family_id: Family.where(organization_id: user.organization_id).pluck(:id))
    can(:manage, Family, organization_id: user.organization_id)
    can(:create, Note)
    can(:manage, Result, family_id: Family.where(organization_id: user.organization_id).pluck(:id))
    can(:manage, Search, organization_id: user.organization_id)
    return unless user.admin?

    can(:manage, :imports) # custom administrate action
    can(:manage, Organization, id: user.organization_id)
    cannot(:destroy, Organization)
    can(:manage, User, id: nil)
    can(:manage, User, organization_id: user.organization_id)
    can(:manage, Region, id: nil)
    can(:manage, Region, organization_id: user.organization_id)
    can(:manage, SchoolDistrict, id: nil)
    can(:manage, SchoolDistrict, organization_id: user.organization_id)
    can(:manage, ChildNeed, id: nil)
    can(:manage, ChildNeed, organization_id: user.organization_id)
    return unless user.super_admin?

    can(:manage, :all)
  end
end

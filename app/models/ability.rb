# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can(:manage, Family, organization_id: user.organization_id)
    can(:manage, Search, organization_id: user.organization_id)
    can(:manage, Result, family_id: Family.where(organization_id: user.organization_id).pluck(:id))
    return unless user.admin?

    can(:manage, Organization, id: user.organization_id)
    cannot(:destroy, Organization)
    can(:manage, User, organization_id: user.organization_id)
    return unless user.super_admin?

    can(:manage, :all)
  end
end

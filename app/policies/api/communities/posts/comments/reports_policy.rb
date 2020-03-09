class Api::Communities::Posts::Comments::ReportsPolicy < ApplicationPolicy
  def index?
    moderator?
  end

  def create?
    user? && !muted?
  end

  alias new? create?

  def permitted_attributes_for_create
    [:text]
  end
end

# frozen_string_literal: true

class ModQueuePolicy < ApplicationPolicy
  def index?
    user?
  end

  class Scope
    attr_accessor :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.staff?
        scope
      else
        scope.joins(sub: :moderators).where(subs: { moderators: { user: user } })
      end
    end
  end
end
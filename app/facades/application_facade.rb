# frozen_string_literal: true

class ApplicationFacade
  attr_reader :user, :sub, :record

  def initialize(context, record = nil)
    @user = context.user
    @sub = context.sub
    @record = record
  end

  def user_ban
    return nil if user.blank?

    @_user_ban ||= BansQuery.new(sub.bans).with_user(user).take
  end

  def subs_moderated_by_user
    return [] if user.blank?

    @_subs_moderated_by_user ||= SubsQuery.new.with_user_moderator(user).all
  end

  def subs_followed_by_user
    return [] if user.blank?

    @_subs_followed_by_user ||= SubsQuery.new.with_user_follower(user).all
  end

  def rules
    @_rules ||= sub.rules.order(id: :asc).all
  end

  def recent_moderators
    @_recent_moderators ||= ModeratorsQuery.new(sub.moderators).recent(10).includes(:user).all
  end

  def pagination_params
    []
  end
end
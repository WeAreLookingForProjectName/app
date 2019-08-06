# frozen_string_literal: true

class BansController < ApplicationController
  before_action :set_ban, only: [:edit, :update, :destroy]
  before_action :set_sub
  before_action :set_facade
  before_action -> { authorize(Ban) }, only: [:index, :new, :create]
  before_action -> { authorize(@ban) }, only: [:edit, :update, :destroy]

  def index
    @records, @pagination = scope.paginate(after: params[:after])
  end

  def new
    @form = CreateBanForm.new

    render partial: "new"
  end

  def edit
    attributes = @ban.slice(:reason, :days, :permanent)

    @form = UpdateBanForm.new(attributes)

    render partial: "edit"
  end

  def create
    @form = CreateBanForm.new(create_params)

    if @form.save
      head :no_content, location: bans_path(sub: @sub)
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def update
    @form = UpdateBanForm.new(update_params)

    if @form.save
      render partial: "ban", object: @form.ban
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def destroy
    DeleteBanService.new(@ban).call

    head :no_content
  end

  private

  def context
    Context.new(current_user, @sub)
  end

  def scope
    query_class = BansQuery

    if @sub.present?
      scope = query_class.new.sub(@sub)
    else
      scope = query_class.new.global
    end

    scope = query_class.new(scope).filter_by_username(params[:query])
    scope.includes(:user, :banned_by)
  end

  def set_facade
    @facade = BansFacade.new(context)
  end

  def set_sub
    if @ban.present?
      @sub = @ban.sub
    elsif params[:sub].present?
      @sub = SubsQuery.new.where_url(params[:sub]).take!
    end
  end

  def set_ban
    @ban = Ban.find(params[:id])
  end

  def create_params
    attributes = policy(Ban).permitted_attributes_for_create

    params.require(:create_ban_form).permit(attributes).merge(sub: @sub, banned_by: current_user)
  end

  def update_params
    attributes = policy(@ban).permitted_attributes_for_update

    params.require(:update_ban_form).permit(attributes).merge(ban: @ban)
  end
end

# frozen_string_literal: true

class SubsController < ApplicationController
  layout "narrow", only: "show"
  before_action :set_sub
  before_action -> { authorize(@sub) }

  def show
    @records, @pagination_record = Post.not_removed
                                       .in_date_range(date)
                                       .where(sub: @sub)
                                       .includes(:sub, :user)
                                       .paginate(attributes: ["#{sort}_score", :id], after: params[:after])

    @records = @records.map(&:decorate)
  end

  def edit
    attributes = @sub.slice(:title, :description)

    @form = UpdateSub.new(attributes)
  end

  def update
    @form = UpdateSub.new(update_params)

    if @form.save
      head :no_content, location: edit_sub_path(@sub)
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  private

  def pundit_user
    UserContext.new(current_user, @sub)
  end

  def set_sub
    @sub = Sub.find_by_lower_url(params[:id])
  end

  def update_params
    attributes = policy(@sub).permitted_attributes_for_update

    params.require(:update_sub).permit(attributes).merge(sub: @sub, current_user: current_user)
  end

  def sort
    ThingsSorting.new(params[:sort]).key
  end

  def date
    ThingsDates.new(params[:date]).date
  end
end

class Api::Users::Votes::CommentsController < ApplicationController
  before_action :set_user
  before_action -> { authorize(@user, policy_class: Api::Users::Votes::CommentsPolicy) }

  def index
    @comments, @pagination = query.paginate(after: params[:after])
  end

  private

  def query
    CommentsQuery.new.voted_by_user(@user).includes(:user, :post, :community)
  end

  def set_user
    @user = UsersQuery.new.with_username(params[:user_id]).take!
  end
end

# frozen_string_literal: true

class CreateVote
  include ActiveModel::Model

  attr_accessor :model, :current_user, :type
  attr_reader :vote

  validates :type, presence: true, inclusion: { in: %w(down meh up) }

  def save
    return false if invalid?

    @vote = @model.votes.where(user: @current_user).take

    if @vote.blank?
      @vote = @model.votes.create!(vote_type: @type, user: @current_user)
    else
      @vote.update!(vote_type: @type)
    end
  end
end

class Communities::Posts::Comments::CreateDownVote
  include ActiveModel::Model

  attr_accessor :comment, :user

  def call
    return previous_vote if user_have_same_opinion?

    ActiveRecord::Base.transaction do
      if user_changed_opinion?
        previous_vote.destroy!
      end

      vote = comment.votes.create!(user: user, vote_type: :down)

      if user_changed_opinion?
        Comment.update_counters(comment.id, {up_votes_count: -1, down_votes_count: 1})
      else
        comment.increment!(:down_votes_count)
      end

      comment.reload.update_scores!

      vote
    end
  end

  private

  def previous_vote
    @_previous_vote ||= comment.votes.where(user: user).take
  end

  def user_have_same_opinion?
    previous_vote.present? && previous_vote.down?
  end

  def user_changed_opinion?
    previous_vote.present? && previous_vote.up?
  end
end

# frozen_string_literal: true

class CommentsQuery
  attr_reader :relation

  def initialize(relation = Comment.all)
    @relation = relation
  end

  def not_moderated
    relation.where(deleted_at: nil, approved_at: nil)
  end

  def from_sub(sub = nil)
    return relation if sub.blank?

    relation.joins(:post).where(posts: { sub: sub })
  end

  def from_subs_where_user_is_moderator(user)
    relation.joins(post: { sub: :moderators }).where(posts: { subs: { moderators: { user: user } } })
  end
end
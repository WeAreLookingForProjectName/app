class Comment < ApplicationRecord
  belongs_to :community
  belongs_to :post, counter_cache: :comments_count
  belongs_to :comment, class_name: "Comment", foreign_key: "comment_id", counter_cache: :comments_count, optional: true
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true
  belongs_to :edited_by, class_name: "User", foreign_key: "edited_by_id", optional: true
  belongs_to :removed_by, class_name: "User", foreign_key: "removed_by_id", optional: true
  has_many :comments, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  after_save :upsert_in_topic

  validates :text, presence: true, length: {maximum: 10_000}
  validates :removed_reason, allow_blank: true, length: {maximum: 5_000}

  def update_scores!
    update!(
      new_score: ScoreCalculator.new_score(created_at),
      hot_score: ScoreCalculator.hot_score(up_votes_count, down_votes_count, created_at),
      best_score: ScoreCalculator.best_score(up_votes_count, down_votes_count),
      top_score: ScoreCalculator.top_score(up_votes_count, down_votes_count),
      controversy_score: ScoreCalculator.controversy_score(up_votes_count, down_votes_count)
    )
  end

  private

  def upsert_in_topic
    json = {
      id: id,
      # TODO fix it
      # thing_id: reply_to.id,
      removed: removed_at.present?,
      new_score: new_score,
      hot_score: hot_score,
      best_score: best_score,
      top_score: top_score,
      controversy_score: controversy_score
    }.to_json

    query = "UPDATE topics
             SET tree = jsonb_set(tree, '{#{id}}', '#{json}', true),
                 updated_at = '#{Time.current.strftime("%Y-%m-%d %H:%M:%S.%N")}'
             WHERE post_id = #{post_id};"

    ActiveRecord::Base.connection.execute(query)
  end
end

require "rails_helper"

RSpec.describe CommentsQuery do
  subject { described_class }

  describe ".not_moderated" do
    it "returns not moderated comments" do
      not_moderated_comments = create_pair(:not_moderated_comment)
      create_pair(:moderated_comment)

      result = subject.new.not_moderated

      expect(result).to match_array(not_moderated_comments)
    end
  end

  describe ".not_removed" do
    it "returns not removed comments" do
      not_removed_comments = create_pair(:comment)
      create_pair(:removed_comment)

      result = subject.new.not_removed

      expect(result).to match_array(not_removed_comments)
    end
  end

  describe ".reported" do
    it "returns comments that have reports" do
      comments_with_reports = create_pair(:comment_with_reports, reports_count: 1)
      create_pair(:comment)

      result = subject.new.reported

      expect(result).to match_array(comments_with_reports)
    end
  end

  describe ".for_the_last_day" do
    it "returns comments created for the last day" do
      comments_created_for_the_last_day = create_pair(:comment)
      _other_comments = create_pair(:comment, created_at: 1.week.ago)

      result = subject.new.for_the_last_day

      expect(result).to match_array(comments_created_for_the_last_day)
    end
  end

  describe ".for_the_last_week" do
    it "returns comments created for the last week" do
      comments_created_for_the_last_week = create_pair(:comment)
      _other_comments = create_pair(:comment, created_at: 1.month.ago)

      result = subject.new.for_the_last_week

      expect(result).to match_array(comments_created_for_the_last_week)
    end
  end

  describe ".for_the_last_month" do
    it "returns comments created for the last month" do
      comments_created_for_the_last_month = create_pair(:comment)
      _other_comments = create_pair(:comment, created_at: 1.year.ago)

      result = subject.new.for_the_last_month

      expect(result).to match_array(comments_created_for_the_last_month)
    end
  end

  describe ".down_voted_by_user" do
    it "returns comments that down voted by given user" do
      user = create(:user)
      comments_down_voted_by_user = create_pair(:comment_with_down_vote, voted_by: user)
      _comments_up_voted_by_user = create_pair(:comment_with_up_vote, voted_by: user)
      _other_voted_comments = create_pair(:comment_with_vote)

      result = described_class.new.down_voted_by_user(user)

      expect(result).to match_array(comments_down_voted_by_user)
    end
  end
end

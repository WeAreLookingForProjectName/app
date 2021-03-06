require "rails_helper"

RSpec.describe PostsQuery do
  subject { described_class }

  describe ".not_moderated" do
    it "returns not moderated posts" do
      not_moderated = create_pair(:not_moderated_post)
      create_pair(:moderated_post)

      result = subject.new.not_moderated

      expect(result).to match_array(not_moderated)
    end
  end

  describe ".not_removed" do
    it "returns not removed posts" do
      not_removed_posts = create_pair(:post)
      create_pair(:removed_post)

      result = subject.new.not_removed

      expect(result).to match_array(not_removed_posts)
    end
  end

  describe ".reported" do
    it "returns posts that have reports" do
      posts_with_reports = create_pair(:post_with_reports, reports_count: 2)
      create_pair(:post)

      result = subject.new.reported

      expect(result).to match_array(posts_with_reports)
    end
  end

  describe ".for_the_last_day" do
    it "returns posts created for the last day" do
      posts_created_for_the_last_day = create_pair(:post)
      _other_posts = create_pair(:post, created_at: 1.week.ago)

      result = subject.new.for_the_last_day

      expect(result).to match_array(posts_created_for_the_last_day)
    end
  end

  describe ".for_the_last_week" do
    it "returns posts created for the last week" do
      posts_created_for_the_last_week = create_pair(:post)
      _other_posts = create_pair(:post, created_at: 1.month.ago)

      result = subject.new.for_the_last_week

      expect(result).to match_array(posts_created_for_the_last_week)
    end
  end

  describe ".for_the_last_month" do
    it "returns posts created for the last month" do
      posts_created_for_the_last_month = create_pair(:post)
      _other_posts = create_pair(:post, created_at: 1.year.ago)

      result = subject.new.for_the_last_month

      expect(result).to match_array(posts_created_for_the_last_month)
    end
  end
end

require "rails_helper"

RSpec.describe Api::Users::Comments::Controversial::DayController, context: :as_signed_in_user do
  describe ".index" do
    it "returns paginated daily comments sorted by controversial score" do
      user = context.user
      _unrelated_comment = create(:created_yesterday_comment, created_by: user)
      first_comment = create(:created_today_comment, created_by: user, controversy_score: 3)
      second_comment = create(:created_today_comment, created_by: user, controversy_score: 2)
      third_comment = create(:created_today_comment, created_by: user, controversy_score: 1)

      get "/api/users/#{user.to_param}/comments/controversial/day.json?after=#{first_comment.to_param}"

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("controllers/api/users/comments/controversial/day_controller/index/200")
      expect(response).to have_sorted_json_collection(second_comment, third_comment)
    end
  end
end

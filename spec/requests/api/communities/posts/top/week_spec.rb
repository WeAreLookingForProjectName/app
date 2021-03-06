require "rails_helper"

RSpec.describe Api::Communities::Posts::Top::WeekController, context: :as_signed_out_user do
  describe ".index" do
    it "returns paginated weekly posts sorted by top score" do
      community = create(:community)
      _unrelated_post = create(:created_last_week_post, community: community)
      first_post = create(:created_this_week_post, community: community, top_score: 3)
      second_post = create(:created_this_week_post, community: community, top_score: 2)
      third_post = create(:created_this_week_post, community: community, top_score: 1)

      get "/api/communities/#{community.to_param}/posts/top/week.json?after=#{first_post.to_param}"

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("controllers/api/communities/posts/top/week_controller/index/200")
      expect(response).to have_sorted_json_collection(second_post, third_post)
    end
  end
end

require "rails_helper"

RSpec.describe Api::Communities::Posts::Comments::ApproveController, context: :as_moderator_user do
  describe ".update" do
    it "approves comment" do
      community = context.community
      post = create(:post, community: community)
      comment = create(:not_approved_comment, post: post)

      put "/api/communities/#{community.to_param}/posts/#{post.to_param}/comments/#{comment.to_param}/approve.json"

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("controllers/api/communities/posts/comments/approve_controller/update/200")
    end
  end
end

require "rails_helper"

RSpec.describe Communities::CreateBan do
  describe ".call" do
    it "creates ban" do
      community = create(:community)
      user = create(:user)

      service = described_class.new(
        community: community,
        username: user.username,
        permanent: true
      )

      service.call

      expect(Ban.count).to eq(1)
    end
  end
end
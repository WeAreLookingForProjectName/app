require "rails_helper"

RSpec.describe ModQueuePolicy do
  subject { described_class }

  let(:sub) { create(:sub) }
  let(:context) { Context.new(user, sub) }

  context "for visitor" do
    let(:user) { nil }
    
    permissions :posts?, :comments? do
      it { is_expected.to_not permit(context) }
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    permissions :posts?, :comments? do
      it { is_expected.to_not permit(context) }
    end
  end

  context "for moderator" do
    let(:user) { create(:moderator, sub: sub).user }

    permissions :posts?, :comments? do
      it { is_expected.to permit(context) }
    end
  end
end
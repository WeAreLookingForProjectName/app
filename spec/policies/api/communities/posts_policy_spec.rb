require "rails_helper"

RSpec.describe Api::Communities::PostsPolicy do
  subject { described_class }

  context "for signed out user", context: :as_signed_out_user do
    let(:post) { create(:post) }

    permissions :show? do
      it { is_expected.to permit(user, post) }
    end

    permissions :create? do
      it { is_expected.to_not permit(user) }
    end

    permissions :update? do
      it { is_expected.to_not permit(user, post) }
    end
  end

  context "for signed in user", context: :as_signed_in_user do
    let(:post) { create(:post) }

    permissions :create? do
      it { is_expected.to permit(user) }
    end

    permissions :show? do
      it { is_expected.to permit(user, post) }
    end

    permissions :update? do
      it { is_expected.to_not permit(user, post) }
    end
  end

  context "for moderator", context: :as_moderator_user do
    let(:post) { create(:post, community: user_context.community) }

    permissions :create? do
      it { is_expected.to permit(user_context) }
    end

    permissions :show? do
      it { is_expected.to permit(user_context, post) }
    end

    permissions :update? do
      it { is_expected.to_not permit(user_context, post) }
    end
  end

  context "for author", context: :as_signed_in_user do
    let(:post) { create(:post, created_by: user) }

    permissions :create? do
      it { is_expected.to permit(user) }
    end

    permissions :show? do
      it { is_expected.to permit(user, post) }
    end

    context "text post" do
      let(:post) { create(:text_post, created_by: user) }

      permissions :update? do
        it { is_expected.to permit(user, post) }
      end
    end

    context "image post" do
      let(:post) { create(:image_post, created_by: user) }

      permissions :update? do
        it { is_expected.to_not permit(user, post) }
      end
    end
  end

  describe ".permitted_attributes_for_create" do
    it "contains attributes" do
      policy = described_class.new(nil)

      expect(policy.permitted_attributes_for_create).to contain_exactly(:title, :text, :file, :explicit, :spoiler)
    end
  end

  describe ".permitted_attributes_for_update" do
    context "for author", context: :as_signed_in_user do
      it "contains :text attribute" do
        post = create(:post, created_by: user)
        policy = described_class.new(user, post)

        expect(policy.permitted_attributes_for_update).to contain_exactly(:text)
      end
    end
  end
end

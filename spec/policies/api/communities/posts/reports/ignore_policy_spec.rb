require "rails_helper"

RSpec.describe Api::Communities::Posts::Reports::IgnorePolicy do
  subject { described_class }

  context "for signed out user", context: :as_signed_out_user do
    permissions :create?, :destroy? do
      it { is_expected.to_not permit(user) }
    end
  end

  context "for signed in user", context: :as_signed_in_user do
    permissions :create?, :destroy? do
      it { is_expected.to_not permit(user) }
    end
  end

  context "for moderator", context: :as_moderator_user do
    permissions :create?, :destroy? do
      it { is_expected.to permit(user_context) }
    end
  end
end

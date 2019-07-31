require "rails_helper"

RSpec.describe ContributorPolicy do
  subject { described_class }

  let(:sub) { create(:sub) }
  let(:contributor_class) { Contributor }
  let(:global_contributor) { create(:global_contributor) }
  let(:sub_contributor) { create(:sub_contributor, sub: sub) }

  context "for visitor" do
    let(:user) { nil }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(described_class).to_not permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "denies access" do
          expect(described_class).to_not permit(context, global_contributor)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(described_class).to_not permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "denies access" do
          expect(described_class).to_not permit(context, sub_contributor)
        end
      end
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(described_class).to_not permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "denies access" do
          expect(described_class).to_not permit(context, global_contributor)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(described_class).to_not permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "denies access" do
          expect(described_class).to_not permit(context, sub_contributor)
        end
      end
    end
  end

  context "for sub moderator" do
    let(:user) { create(:sub_moderator, sub: sub).user }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(described_class).to_not permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "denies access" do
          expect(described_class).to_not permit(context, global_contributor)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "grants access" do
          expect(described_class).to permit(context, sub_contributor)
        end
      end
    end
  end

  context "for global moderator" do
    let(:user) { create(:global_moderator).user }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "grants access" do
          expect(described_class).to permit(context, global_contributor)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index?, :search? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(described_class).to permit(context, contributor_class)
        end
      end

      permissions :destroy? do
        it "grants access" do
          expect(described_class).to permit(context, sub_contributor)
        end
      end
    end
  end
end
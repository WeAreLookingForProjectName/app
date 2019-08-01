require "rails_helper"

RSpec.describe TagPolicy do
  subject { described_class }

  let(:sub) { create(:sub) }
  let(:tag_class) { Tag }
  let(:global_tag) { create(:global_tag) }
  let(:sub_tag) { create(:sub_tag, sub: sub) }

  context "for visitor" do
    let(:user) { nil }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(subject).to_not permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "denies access" do
          expect(subject).to_not permit(context, global_tag)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(subject).to_not permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "denies access" do
          expect(subject).to_not permit(context, sub_tag)
        end
      end
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(subject).to_not permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "denies access" do
          expect(subject).to_not permit(context, global_tag)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(subject).to_not permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "denies access" do
          expect(subject).to_not permit(context, sub_tag)
        end
      end
    end
  end

  context "for sub moderator" do
    let(:user) { create(:sub_moderator, sub: sub).user }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "denies access" do
          expect(subject).to_not permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "denies access" do
          expect(subject).to_not permit(context, global_tag)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "grants access" do
          expect(subject).to permit(context, sub_tag)
        end
      end
    end
  end

  context "for global moderator" do
    let(:user) { create(:global_moderator).user }

    context "global" do
      let(:context) { UserContext.new(user) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "grants access" do
          expect(subject).to permit(context, global_tag)
        end
      end
    end

    context "sub" do
      let(:context) { UserContext.new(user, sub) }

      permissions :index? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :new?, :create? do
        it "grants access" do
          expect(subject).to permit(context, tag_class)
        end
      end

      permissions :edit?, :update?, :destroy? do
        it "grants access" do
          expect(subject).to permit(context, sub_tag)
        end
      end
    end
  end
end
require "rails_helper"

RSpec.describe SignInForm, type: :form do
  subject { described_class }

  describe "validations" do
    context "invalid" do
      before do
        @form = subject.new(username: "username", password: "password")
      end

      it "is invalid if credentials does not match" do
        @form.validate

        expect(@form).to have_error(:invalid_credentials).on(:username)
      end
    end

    context "valid" do
      before do
        @user = instance_double(User)
        allow(@user).to receive(:authenticate).with(anything).and_return(true)

        @form = subject.new(username: double, password: double)
        allow(@form).to receive(:user).and_return(@user)
      end

      it { expect(@form).to be_valid }
    end
  end
end
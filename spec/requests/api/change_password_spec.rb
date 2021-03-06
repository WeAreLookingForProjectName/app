require "rails_helper"

RSpec.describe Api::ChangePasswordController, context: :as_signed_out_user do
  describe ".update" do
    context "with valid params" do
      it "changes user password, signs him in user and returns user" do
        user = create(:user, forgot_password_token: "token")

        put "/api/change_password.json", params: {token: "token", password: "password"}

        expect(session["warden.user.default.key"]).to eq(user.id)
        expect(response).to have_http_status(200)
        expect(response).to match_json_schema("controllers/api/change_password_controller/update/200", strict: true)
      end
    end

    context "with invalid params" do
      it "returns error messages" do
        put "/api/change_password.json", params: {token: "token", password: "password"}

        expect(session["warden.user.default.key"]).to be_nil
        expect(response).to have_http_status(422)
        expect(response).to match_json_schema("controllers/api/change_password_controller/update/422")
      end
    end
  end
end

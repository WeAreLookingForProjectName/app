require "rails_helper"

RSpec.describe Api::SignOutController do
  describe ".destroy", context: :as_signed_in_user do
    it "signs out user" do
      delete "/api/sign_out.json"

      expect(response).to have_http_status(204)
      expect(request.session["warden.user.default.key"]).to be_nil
    end
  end
end
